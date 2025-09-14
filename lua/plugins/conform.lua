return {
  {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({ async = true, lsp_fallback = true, stop_after_first = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          stop_after_first = true,
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format" },
        -- Prefer Biome when available; fall back to Prettier
        javascript = { "biome", "prettierd", "prettier" },
        typescript = { "biome", "prettierd", "prettier" },
        javascriptreact = { "biome", "prettierd", "prettier" },
        typescriptreact = { "biome", "prettierd", "prettier" },
        json = { "biome", "prettierd", "prettier" },
        jsonc = { "biome", "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        markdown = { "biome", "prettierd", "prettier" },
        css = { "biome", "prettierd", "prettier" },
        html = { "biome", "prettierd", "prettier" },
        -- C/C++: use clang-format if present
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      -- Commands and keys to toggle Python formatting
      vim.api.nvim_create_user_command("PythonFormatUseRuff", function()
        require("core.python_format_toggle").use_ruff()
      end, {})
      vim.keymap.set("n", "<leader>Pr", ":PythonFormatUseRuff<CR>", { desc = "Python: use Ruff" })
    end,
  },
}

