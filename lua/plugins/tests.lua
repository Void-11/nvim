return {
  -- Core neotest
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      -- Adaptors
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "alfaix/neotest-gtest",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Test: Run nearest" },
      { "<leader>tT", function() require("neotest").run.run(vim.fn.expand('%')) end, desc = "Test: Run file" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: Output" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: Summary" },
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-python")({ dap = { justMyCode = false } }),
          require("neotest-jest")({ jestCommand = "npm test --" }),
          require("neotest-vitest")({}),
          require("neotest-gtest")({}),
        },
      })
    end,
  },
}
