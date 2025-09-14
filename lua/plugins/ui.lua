return {
  -- Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night" },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local navic = require("nvim-navic")
      return {
        options = {
          theme = "tokyonight",
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            { "filename", path = 1 },
            {
              function()
                if navic.is_available() then
                  return navic.get_location()
                end
                return ""
              end,
              cond = function() return navic.is_available() end,
              color = { fg = "#7aa2f7" },
            },
            {
              function()
                if vim.g.unified_project and vim.g.unified_project.has_pixi then
                  local env = vim.fn.getenv("PIXI_ENVIRONMENT_NAME")
                  if env and env ~= vim.NIL and env ~= "" then
                    return " 🐍 " .. env
                  end
                end
                return ""
              end,
              color = { fg = "#7aa2f7" },
            },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
  -- Notifications
  {
    "rcarriga/nvim-notify",
    lazy = false,
    opts = { 
      stages = "fade",
      render = "default",
      timeout = 3000,
      top_down = false,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
  -- Which-key: lazy-load with v3 spec registration via opts
  {
    "folke/which-key.nvim",
    lazy = false,
    opts = {
      spec = {
        { "<leader>f", group = "Find/Format" },
        { "<leader>g", group = "Git/GUI" },
        { "<leader>l", group = "LSP" },
        { "<leader>d", group = "Debug" },
        { "<leader>t", group = "Terminal/Tasks" },
        { "<leader>c", group = "CMake" },
        { "<leader>u", group = "UE5" },
        { "<leader>p", group = "Project" },
        { "<leader>o", group = "Overseer" },
        { "<leader>db", group = "Databases" },
      },
    },
  },
  -- Indent guides
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = "VeryLazy", opts = { scope = { enabled = true } } },
  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.startify")
      alpha.setup(dashboard.opts)
    end,
  },
}

