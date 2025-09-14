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
  -- Optional dependency for Molten's WezTerm image provider (Windows-friendly)
  {
    "willothy/wezterm.nvim",
    cond = function()
      return vim.fn.has("win32") == 1 and vim.fn.executable("wezterm") == 1
    end,
  },
  -- Molten (optional richer Jupyter kernel)
  {
    "benlubas/molten-nvim",
    ft = { "python", "ipynb", "qmd", "markdown" },
    build = ":UpdateRemotePlugins",
    config = function()
      local is_windows = vim.fn.has("win32") == 1
      local has_wezterm = vim.fn.executable("wezterm") == 1

      if is_windows and has_wezterm then
        -- WezTerm provider is the most reliable for images on Windows
        vim.g.molten_image_provider = "wezterm"
        vim.g.molten_auto_open_output = false -- must be false for wezterm provider
        vim.g.molten_split_direction = "right"
        vim.g.molten_split_size = 40 -- percent
        vim.g.molten_virt_text_output = true -- keep context in buffer
      else
        -- Fallback: no inline images, use external viewer when needed
        vim.g.molten_image_provider = "none"
        vim.g.molten_auto_image_popup = true -- opens images via default viewer
        vim.g.molten_auto_open_output = true
      end

      vim.g.molten_use_border_highlights = true
      vim.g.molten_output_win_zindex = 50

      -- Keymaps (safe to define always)
      vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { silent = true, desc = "Molten: Init" })
      vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Molten: Eval line" })
      vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "Molten: Eval visual" })
      vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "Molten: Re-eval cell" })
      vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "Molten: Show/enter output" })
      vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>", { silent = true, desc = "Molten: Hide output" })
    end,
  },
}

