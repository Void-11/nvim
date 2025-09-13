-- ============================================================================
-- Core Options (Unified)
-- ============================================================================

-- Basic UI/UX
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.updatetime = 100
vim.opt.timeoutlen = 300
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.completeopt = { "menu", "menuone", "noinsert" }

-- Encoding/locale: ensure UTF-8 inside Neovim and set environment for healthcheck
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.g.encoding = "utf-8"
vim.env.LANG = vim.env.LANG or "en_US.UTF-8"
vim.env.LC_ALL = vim.env.LC_ALL or "en_US.UTF-8"
vim.env.LC_CTYPE = vim.env.LC_CTYPE or "en_US.UTF-8"

-- Point Python provider to system python if available
if vim.fn.executable("python") == 1 then
  vim.g.python3_host_prog = vim.fn.exepath("python")
end

-- Performance for large projects
-- Noice requires lazyredraw to be disabled; enable other perf tweaks instead
vim.opt.lazyredraw = false
vim.opt.synmaxcol = 300
vim.opt.maxmempattern = 20000

-- File handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Indentation defaults (spaces), but C/C++/UE5 will override to tabs below
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- Windows-specific shell settings
if vim.fn.has("win32") == 1 then
  vim.opt.shell = "powershell"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = '"'
  vim.opt.shellxquote = ""
end

-- Disable optional providers you don't use to silence health warnings
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Treat .h as C++ headers, and UE5 filetypes
vim.filetype.add({
  extension = {
    h = "cpp",
    uproject = "json",
    uplugin = "json",
  },
})

-- C/C++ local indentation (UE5 uses tabs)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "cuda", "h", "hpp" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.cindent = true
    vim.opt_local.cinoptions = "g0,:0,N-s,(0"
  end,
})

-- Disable heavy features for very large files
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function()
    local ok, size = pcall(vim.fn.getfsize, vim.fn.expand("%:p"))
    if ok and size > 1024 * 1024 then -- > 1MB
      vim.opt_local.syntax = "off"
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
    end
  end,
})

