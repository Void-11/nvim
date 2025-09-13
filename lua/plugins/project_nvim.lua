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
      local ok, telescope = pcall(require, 'telescope')
      if ok then telescope.load_extension('projects') end
      vim.keymap.set('n', '<leader>fp', ':Telescope projects<CR>', { desc = "Find Projects" })
    end,
  },
}

