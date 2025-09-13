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
  -- Python venv selector
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    cmd = { "VenvSelect", "VenvSelectCached" },
    opts = {},
    keys = {
      { "<leader>pv", function() require("venv-selector").select() end, desc = "Python: Select venv" },
    },
  },
  -- SchemaStore for JSON/YAML (also loaded as LSP dependency)
  { "b0o/schemastore.nvim" },
}

