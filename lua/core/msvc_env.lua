local M = {}

local uv = vim.uv or vim.loop

local function exists(p)
  return p and uv.fs_stat(p) ~= nil
end

-- Load MSVC Developer environment into the current Neovim process.
-- This makes cl.exe, the Windows SDK, and related tools available on PATH.
-- Returns true on success, false otherwise.
function M.load(opts)
  local uname = uv.os_uname()
  if not uname or uname.sysname ~= "Windows_NT" then
    return false
  end
  if vim.g._msvc_env_loaded then
    return true
  end

  opts = opts or {}
  local arch = opts.arch or "x64"

  local function join_paths(...)
    return table.concat({ ... }, "\\")
  end

  -- Locate Visual Studio via vswhere (preferred), else use known BuildTools path
  local vswhere = [[C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe]]
  local vs_path
  if exists(vswhere) then
    local out = vim.fn.systemlist(string.format('"%s" -latest -products * -property installationPath', vswhere))
    if vim.v.shell_error == 0 and type(out) == "table" and #out > 0 then
      vs_path = vim.fn.trim(out[1] or "")
      if vs_path == "" then vs_path = nil end
    end
  end

  local devcmd
  if vs_path then
    devcmd = join_paths(vs_path, "Common7", "Tools", "VsDevCmd.bat")
  end
  if not exists(devcmd) then
    local fallback = [[C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\VsDevCmd.bat]]
    if exists(fallback) then
      devcmd = fallback
    end
  end
  if not exists(devcmd) then
    vim.schedule(function()
      vim.notify("MSVC env: VsDevCmd.bat not found. Use 'Developer PowerShell for VS' or ensure Build Tools C++ workload.", vim.log.levels.WARN)
    end)
    return false
  end

  -- Run VsDevCmd through a temporary batch file to avoid quoting issues
  local tmpbat = vim.fn.tempname() .. ".bat"
  local f = io.open(tmpbat, "w+")
  if not f then
    vim.schedule(function()
      vim.notify("MSVC env: Failed to create temporary batch file", vim.log.levels.WARN)
    end)
    return false
  end
  f:write("@echo off\r\n")
  f:write(string.format("call \"%s\" -arch=%s\r\n", devcmd, arch))
  f:write("set\r\n")
  f:close()

  local cmd = string.format('cmd.exe /d /q /c "%s"', tmpbat)
  local lines = vim.fn.systemlist(cmd)

  -- Clean up temp file
  pcall(function() os.remove(tmpbat) end)

  -- Sanitize lines (remove trailing CRs) before parsing
  for i = 1, #lines do
    lines[i] = lines[i]:gsub("\r+$", "")
  end

  if vim.v.shell_error ~= 0 or type(lines) ~= "table" or #lines == 0 then
    vim.schedule(function()
      vim.notify("MSVC env: Failed to load environment via VsDevCmd.bat", vim.log.levels.WARN)
    end)
    return false
  end

  for _, line in ipairs(lines) do
    local k, v = line:match([[^([^=]+)=(.*)$]])
    if k and v then
      -- Trim CR characters from Windows SET output to avoid PATH/LOCALAPPDATA containing ^M
      v = v:gsub("\r+$", "")
      local kl = k:lower()
      vim.env[k] = v
      -- Normalize common env var casings for Windows so Neovim/libuv sees them
      if kl == "path" then
        vim.env.PATH = v
        vim.env.Path = v
      elseif kl == "pathext" then
        vim.env.PATHEXT = v
        vim.env.PathExt = v
      elseif kl == "include" then
        vim.env.INCLUDE = v
      elseif kl == "lib" then
        vim.env.LIB = v
      end
    end
  end

  if not vim.env.CC or vim.env.CC == "" then
    vim.env.CC = "cl"
  end

  vim.g._msvc_env_loaded = true
  return (vim.fn.executable("cl") == 1)
end

return M
