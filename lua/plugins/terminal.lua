return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        shade_terminals = true,
        start_in_insert = true,
        direction = "float",
        float_opts = { border = "curved" },
        close_on_exit = true,
        shell = vim.o.shell,
      })

      local Terminal = require("toggleterm.terminal").Terminal

      -- Project-specific terminals
      local pnpm_dev = Terminal:new({ cmd = "pnpm dev", dir = "git_dir", direction = "float" })
      local pixi_shell = Terminal:new({ cmd = "pixi shell", dir = "git_dir", direction = "float" })
      local docker_up = Terminal:new({ cmd = "docker compose up", dir = "git_dir", direction = "float" })
      local convex_dev = Terminal:new({ cmd = "npx convex dev", dir = "git_dir", direction = "float" })

      vim.keymap.set("n", "<leader>td", function() pnpm_dev:toggle() end, { desc = "pnpm dev" })
      vim.keymap.set("n", "<leader>tp", function() pixi_shell:toggle() end, { desc = "Pixi shell" })
      vim.keymap.set("n", "<leader>tc", function() docker_up:toggle() end, { desc = "docker compose up" })
      vim.keymap.set("n", "<leader>tx", function() convex_dev:toggle() end, { desc = "convex dev" })

      -- Terminal toggles
      vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<CR>', { desc = "Terminal: Float" })
      vim.keymap.set('n', '<leader>th', ':ToggleTerm direction=horizontal<CR>', { desc = "Terminal: Horizontal" })
      vim.keymap.set('n', '<leader>tv', ':ToggleTerm direction=vertical<CR>', { desc = "Terminal: Vertical" })
    end,
  },
}

