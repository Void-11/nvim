return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerOpen", "OverseerToggle", "OverseerRun" },
    keys = {
      { "<leader>oo", "<cmd>OverseerOpen<CR>", desc = "Overseer: Open" },
      { "<leader>ot", "<cmd>OverseerToggle<CR>", desc = "Overseer: Toggle" },
      { "<leader>or", "<cmd>OverseerRun<CR>", desc = "Overseer: Run Task" },
    },
    config = function()
      require("overseer").setup({
        templates = { "builtin" },
        strategy = { "toggleterm", direction = "horizontal", quit_on_exit = "never" },
      })
    end,
  },
}

