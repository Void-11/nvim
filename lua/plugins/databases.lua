return {
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = { "DBUI", "DBUIToggle", "DB", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
    config = function()
      -- Keymaps for DB UI
      vim.keymap.set('n', '<leader>dbu', ':DBUI<CR>', { desc = "DB: Open UI" })
      vim.keymap.set('n', '<leader>dbc', ':DBUIToggle<CR>', { desc = "DB: Toggle UI" })
      vim.g.db_ui_win_position = 'left'
      vim.g.db_ui_use_nerd_fonts = 1
      -- Use completion in SQL buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          vim.cmd([[setlocal omnifunc=vim_dadbod_completion#omni]])
        end,
      })
    end,
  },
}

