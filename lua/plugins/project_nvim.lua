return {
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "CMakeLists.txt", "*.uproject" },
        silent_chdir = true,
        scope_chdir = 'global',
      })

      -- Runtime patch: replace deprecated vim.lsp.buf_get_clients() usage with vim.lsp.get_clients
      -- without modifying the plugin files on disk, so updates remain unblocked.
      pcall(function()
        local proj = require("project_nvim.project")
        proj.find_lsp_root = function()
          -- Get lsp client for current buffer
          local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
          local clients
          if type(vim.lsp.get_clients) == "function" then
            clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
          else
            clients = vim.lsp.buf_get_clients() -- fallback for old Neovim
          end
          if not clients or next(clients) == nil then
            return nil
          end
          local cfg = require("project_nvim.config")
          for _, client in pairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.tbl_contains(filetypes, buf_ft) then
              if not vim.tbl_contains(cfg.options.ignore_lsp, client.name) then
                return client.config.root_dir, client.name
              end
            end
          end
          return nil
        end
      end)

      local ok, telescope = pcall(require, 'telescope')
      if ok then telescope.load_extension('projects') end
      vim.keymap.set('n', '<leader>fp', ':Telescope projects<CR>', { desc = "Find Projects" })
    end,
  },
}

