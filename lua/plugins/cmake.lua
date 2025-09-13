return {
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
    cmd = {
      "CMakeGenerate",
      "CMakeBuild",
      "CMakeRun",
      "CMakeDebug",
      "CMakeClean",
      "CMakeRunTest",
      "CMakeSelectBuildType",
      "CMakeSelectBuildTarget",
    },
    keys = {
      { "<leader>cg", "<cmd>CMakeGenerate<CR>", desc = "CMake: Generate" },
      { "<leader>cb", "<cmd>CMakeBuild<CR>", desc = "CMake: Build" },
      { "<leader>cr", "<cmd>CMakeRun<CR>", desc = "CMake: Run" },
      { "<leader>cd", "<cmd>CMakeDebug<CR>", desc = "CMake: Debug" },
      { "<leader>cc", "<cmd>CMakeClean<CR>", desc = "CMake: Clean" },
      { "<leader>ct", "<cmd>CMakeRunTest<CR>", desc = "CMake: Run Tests" },
      { "<leader>cs", "<cmd>CMakeSelectBuildType<CR>", desc = "CMake: Build Type" },
      { "<leader>cT", "<cmd>CMakeSelectBuildTarget<CR>", desc = "CMake: Target" },
    },
    config = function()
      require("cmake-tools").setup({
        cmake_use_preset = true,
        cmake_regenerate_on_save = true,
        cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_build_directory = function()
          if _G.is_ue5_project and _G.is_ue5_project() then
            return vim.g.ue5_project_root .. "/Intermediate/Build"
          end
          return "build"
        end,
        cmake_soft_link_compile_commands = true,
        cmake_executor = { name = "toggleterm", opts = { direction = "horizontal", close_on_exit = false, auto_scroll = true } },
        cmake_runner = { name = "toggleterm", opts = { direction = "horizontal", close_on_exit = false, auto_scroll = true } },
      })
    end,
  },
}

