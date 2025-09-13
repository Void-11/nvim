return {
  -- Utilities used across stacks
  { "nvim-lua/plenary.nvim" },
  { "tpope/vim-fugitive", cmd = { "Git", "G" } },
  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gcc" },
    opts = {},
  },
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  -- Indent detection
  { "tpope/vim-sleuth", event = "VeryLazy" },
  -- Diagnostics/UI improvements
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix (Trouble)" },
      { "<leader>xr", "<cmd>Trouble lsp_references toggle<CR>", desc = "References (Trouble)" },
    },
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "rcarriga/nvim-notify", "MunifTanjim/nui.nvim" },
    opts = {
      presets = { bottom_search = true, command_palette = true, long_message_to_split = true },
      lsp = { progress = { enabled = true } },
    },
  },
  -- Spectre (project-wide find/replace)
  {
    "nvim-pack/nvim-spectre",
    cmd = { "Spectre" },
    keys = {
      { "<leader>sr", function() require('spectre').open() end, desc = "Spectre: Replace" },
    },
    opts = {},
  },
  -- Diffview (rich git diffs)
  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" } },
  -- TODO comments surfacing
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  -- Colorizer for CSS/JS/etc
  { "NvChad/nvim-colorizer.lua", event = "VeryLazy", opts = {} },
  -- Flash for fast jumping
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Remote Flash" },
      { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Treesitter Search" },
      { "<c-s>", function() require("flash").toggle() end, mode = { "c" }, desc = "Toggle Flash Search" },
    },
  },
  -- Aerial symbols outline
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen" },
    keys = { { "<leader>sa", "<cmd>AerialToggle!<CR>", desc = "Aerial: Toggle" } },
    opts = { attach_mode = "global", layout = { default_direction = "prefer_right" } },
  },
  -- SchemaStore for JSON/YAML (also loaded as LSP dependency)
  { "b0o/schemastore.nvim" },
}

