return {
  {
    "nvim-telescope/telescope.nvim",
    -- Track latest; rely on lazy-lock for reproducibility
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help" },
      { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Doc symbols" },
      { "<leader>fw", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "Workspace symbols" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = (function()
          if vim.fn.has("win32") == 1 then
            return table.concat({
              "cmake -S . -B build -DCMAKE_BUILD_TYPE=Release",
              "cmake --build build --config Release",
              "cmake --install build --prefix build",
            }, " && ")
          else
            return "make"
          end
        end)(),
        cond = function()
          if vim.fn.has("win32") == 1 then
            return vim.fn.executable("cmake") == 1
          else
            return vim.fn.executable("make") == 1
          end
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local has_fd = (vim.fn.executable("fd") == 1)
      local vimgrep = {
        "rg", "--color=never", "--no-heading", "--with-filename",
        "--line-number", "--column", "--smart-case","--hidden",
        "--glob", "!.git/*",
      }
      telescope.setup({
        defaults = {
          vimgrep_arguments = vimgrep,
          file_ignore_patterns = {
            "node_modules/", ".git/", "dist/", "build/", ".next/", "__pycache__/", ".pytest_cache/", ".mypy_cache/",
            ".pixi/", ".convex/", "target/"
          },
        },
        pickers = {
          find_files = has_fd
            and { find_command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" } }
            or { hidden = true },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })
      pcall(telescope.load_extension, "fzf")
      telescope.load_extension("ui-select")
    end,
  },
}

