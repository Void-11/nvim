-- ============================================================================
-- Project Detection & Environment Flags
-- ============================================================================
local M = {}

local fn = vim.fn
local uv = vim.uv or vim.loop

local function exists(path)
  local stat = (uv.fs_stat or uv.fs_stat)(path)
  return stat ~= nil
end

local function cwd()
  return fn.getcwd()
end

local function any_glob(pattern)
  local matches = fn.glob(pattern, false, true)
  return matches and #matches > 0
end

local function file_exists(name)
  return fn.filereadable(name) == 1 or exists(name)
end

local function detect_ue5()
  local root = cwd()
  local projects = fn.glob(root .. "/*.uproject", false, true)
  if #projects > 0 then
    vim.g.ue5_project_root = root
    vim.g.ue5_project_file = projects[1]

    -- Try to detect UE5 engine path
    local possible_paths = {
      "/Applications/Epic Games/UE_5.6.1",
      "/Users/Shared/Epic Games/UE_5.6.1",
      "/opt/UnrealEngine",
      "C:/Program Files/Epic Games/UE_5.6.1",
    }
    for _, p in ipairs(possible_paths) do
      if fn.isdirectory(p) == 1 then
        vim.g.ue5_engine_path = p
        break
      end
    end
    return true
  end
  return false
end

function _G.get_ue5_project_name()
  if vim.g.ue5_project_file then
    return fn.fnamemodify(vim.g.ue5_project_file, ":t:r")
  end
  return nil
end

function _G.is_ue5_project()
  return vim.g.ue5_project_root ~= nil
end

function _G.get_ue5_relative_path(filepath)
  if vim.g.ue5_project_root and filepath then
    return fn.fnamemodify(filepath, ":s?" .. vim.g.ue5_project_root .. "/??")
  end
  return filepath
end

local function detect_flags()
  local root = cwd()
  local flags = {}

  -- Web/Frontend
  flags.has_package_json = file_exists("package.json")
  flags.is_nextjs = flags.has_package_json and (file_exists("next.config.js") or file_exists("next.config.ts"))
  flags.has_ts = file_exists("tsconfig.json")
  flags.has_tailwind = file_exists("tailwind.config.js") or file_exists("tailwind.config.ts")
  flags.has_shadcn = file_exists("components.json") -- shadcn/ui default

  -- Package managers
  flags.has_pnpm = file_exists("pnpm-lock.yaml") or file_exists("pnpm-workspace.yaml")
  flags.has_npm = file_exists("package-lock.json")
  flags.has_pixi = file_exists("pixi.toml")
  flags.has_pip = file_exists("requirements.txt") or file_exists("pyproject.toml")
  flags.has_brew = (fn.executable("brew") == 1)

  -- Backend / APIs / Databases
  flags.has_prisma = file_exists("prisma/schema.prisma")
  flags.has_sql = any_glob("**/*.sql")
  flags.has_redis = file_exists("redis.conf") or fn.executable("redis-server") == 1
  flags.has_convex = fn.isdirectory("convex") == 1

  -- Containers
  flags.has_docker = file_exists("Dockerfile")
  flags.has_docker_compose = file_exists("docker-compose.yml") or file_exists("compose.yml")

  -- Python / ML / Notebooks
  flags.has_notebooks = any_glob("**/*.ipynb")
  flags.has_ml = flags.has_pip or flags.has_pixi

  -- C++ / Build systems
  flags.has_cmake = file_exists("CMakeLists.txt") or file_exists("CMakePresets.json")
  flags.has_make = file_exists("Makefile")
  flags.has_compile_commands = file_exists("compile_commands.json")

  -- UE5
  flags.is_ue5 = detect_ue5()

  vim.g.unified_project = flags
end

function M.setup()
  -- Defer initial detection to avoid blocking startup
  vim.schedule(detect_flags)
  vim.api.nvim_create_autocmd("VimEnter", { callback = detect_flags })
  vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
      vim.schedule(detect_flags)
    end,
  })
end

return M

