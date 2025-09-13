local has_cc = (vim.fn.executable("cc") == 1)
  or (vim.fn.executable("gcc") == 1)
  or (vim.fn.executable("clang") == 1)
  or (vim.fn.executable("cl") == 1)
  or (vim.fn.executable("zig") == 1)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = has_cc and ":TSUpdate" or nil,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "windwp/nvim-ts-autotag" },
    },
    init = function()
      -- Load MSVC environment as early as possible so healthcheck sees `cl`
      pcall(function()
        local uname = (vim.uv or vim.loop).os_uname()
        if uname and uname.sysname == "Windows_NT" then
          require("core.msvc_env").load({ arch = "x64" })
        end
      end)
      -- Set compilers early so healthcheck uses them
      local ok, install = pcall(require, "nvim-treesitter.install")
      if ok then
        if vim.fn.getenv("CC") ~= vim.NIL and vim.fn.getenv("CC") ~= "" then
          install.compilers = { vim.fn.getenv("CC") }
        else
          install.compilers = { "cl", "zig", "clang", "gcc" }
        end
      end
    end,
    opts = function()
      local ensure = {
        "bash", "c", "cpp", "cmake", "css", "dockerfile", "diff", "gitignore",
        "go", "html", "javascript", "typescript", "tsx", "json", "jsonc", "lua",
        "markdown", "markdown_inline", "python", "regex", "sql", "toml", "yaml",
      }
      if not has_cc then ensure = {} end
      return {
        ensure_installed = ensure,
        auto_install = has_cc,
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = { ["]m"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_previous_start = { ["[m"] = "@function.outer", ["[c"] = "@class.outer" },
          },
        },
      }
    end,
    config = function(_, opts)
      -- Ensure MSVC env is loaded so `cl` is available when Neovim wasn't launched from a Developer shell
      pcall(function()
        local uname = (vim.uv or vim.loop).os_uname()
        if uname and uname.sysname == "Windows_NT" then
          require("core.msvc_env").load({ arch = "x64" })
        end
      end)
      local install = require("nvim-treesitter.install")
      install.compilers = { "cl", "zig", "clang", "gcc" }
      -- Also honor CC/CXX if set in the environment
      if vim.fn.getenv("CC") ~= vim.NIL and vim.fn.getenv("CC") ~= "" then
        install.compilers = { vim.fn.getenv("CC") }
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}

