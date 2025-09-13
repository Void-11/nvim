return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorer" },
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = { "node_modules", ".git", ".DS_Store", "__pycache__", ".next", ".convex", ".pixi" },
          },
          follow_current_file = { enabled = true, leave_dirs_open = true },
        },
        window = { position = "left", width = 40 },
      })
    end,
  },
}

