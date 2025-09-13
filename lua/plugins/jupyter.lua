return {
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "hrsh7th/nvim-cmp",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "qmd" },
    opts = { lspFeatures = { languages = { "python" }, chunks = "curly" } },
  },
  {
    "GCBallesteros/jupytext.nvim",
    ft = { "ipynb", "python", "markdown" },
    config = function()
      require("jupytext").setup({ style = "markdown", output_extension = ".md", force_ft = "markdown" })
    end,
  },
  {
    "dccsillag/magma-nvim",
    build = ":UpdateRemotePlugins",
    ft = { "python", "ipynb", "qmd", "markdown" },
    config = function()
      vim.g.magma_image_provider = "kitty" -- or "ueberzug" depending on terminal
      vim.keymap.set('n', '<leader>mi', ":MagmaInit<CR>", { desc = "Magma: Init" })
      vim.keymap.set('n', '<leader>mr', ":MagmaEvaluateOperator<CR>", { desc = "Magma: Eval Operator" })
      vim.keymap.set('n', '<leader>ml', ":MagmaEvaluateLine<CR>", { desc = "Magma: Eval Line" })
      vim.keymap.set('v', '<leader>mv', ":<C-u>MagmaEvaluateVisual<CR>", { desc = "Magma: Eval Visual" })
      vim.keymap.set('n', '<leader>mc', ":MagmaReevaluateCell<CR>", { desc = "Magma: Re-eval Cell" })
      vim.keymap.set('n', '<leader>md', ":MagmaDelete<CR>", { desc = "Magma: Delete Cell" })
    end,
  },
}

