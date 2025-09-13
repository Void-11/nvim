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
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
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

