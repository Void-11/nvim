-- ============================================================================
-- Unified IDE Neovim Configuration
-- Combines AI/ML, Web (Next.js/TS/React/Tailwind), C++/UE5, Backend, Docker, DB
-- Cross-platform: macOS (primary), Linux, Windows/WSL2
-- ============================================================================

-- Set leaders early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Enable Lua module loader for faster startup (Neovim 0.9+)
pcall(function() vim.loader.enable() end)

-- Ensure this config directory is on runtimepath and package.path when using -u with a custom path
local function add_self_to_paths()
  local src = debug.getinfo(1, "S").source
  local dir
  if src:sub(1, 1) == "@" then
    dir = vim.fn.fnamemodify(src:sub(2), ":p:h")
  else
    dir = vim.fn.getcwd()
  end
  -- Normalize to forward slashes
  dir = dir:gsub("\\", "/")
  -- Expose config root for other modules (e.g., lockfile path)
  vim.g.unified_config_root = dir
  -- Add to runtimepath if missing
  local rtp = vim.opt.rtp:get()
  local present = false
  for _, p in ipairs(rtp) do
    if p == dir then present = true; break end
  end
  if not present then vim.opt.rtp:prepend(dir) end
  -- Add lua subpaths to Lua package.path for direct requires
  local lua1 = dir .. "/lua/?.lua"
  local lua2 = dir .. "/lua/?/init.lua"
  if not string.find(package.path, lua1, 1, true) then
    package.path = table.concat({ package.path, lua1, lua2 }, ";")
  end
end
add_self_to_paths()

-- Core settings and project detection
require("core.options")

-- On Windows, import MSVC Developer environment so `cl` is available for build helpers
pcall(function()
  local uname = (vim.uv or vim.loop).os_uname()
  if uname and uname.sysname == "Windows_NT" then
    require("core.msvc_env").load({ arch = "x64" })
  end
end)

require("core.project_detection").setup()

-- Setup plugins
require("lazy").setup(require("plugins"), {
  ui = { border = "rounded" },
  change_detection = { notify = false },
  defaults = { lazy = true },
  rocks = { enabled = false },
  lockfile = (vim.g.unified_config_root or vim.fn.stdpath("config")) .. "/lazy-lock.json",
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
        -- disable netrw suite (neo-tree used instead)
        "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
      },
    },
  },
})

-- Extra keymaps
pcall(require, "core.keymaps")

-- Colors
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

vim.defer_fn(function()
  vim.notify("Unified IDE Neovim config loaded!", vim.log.levels.INFO)
end, 500)
