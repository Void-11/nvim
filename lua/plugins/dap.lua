return {
  -- Core DAP with UI and adapters
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<leader>B", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Debug: Conditional" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
      -- Windows: quick launch MSVC cppvsdbg config by name
      { "<leader>dm", function()
          if vim.fn.has("win32") == 1 then
            local dap = require("dap")
            for _, cfg in ipairs(dap.configurations.cpp or {}) do
              if cfg.type == "cppvsdbg" then
                return dap.run(vim.deepcopy(cfg))
              end
            end
            vim.notify("cppvsdbg config not found", vim.log.levels.WARN)
          else
            vim.notify("cppvsdbg is Windows-only", vim.log.levels.WARN)
          end
        end, desc = "Debug: MSVC (cppvsdbg)" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_registry = require("mason-registry")

      require("nvim-dap-virtual-text").setup({})
      dapui.setup()

      -- Mason DAP
      local ensure = { "js-debug-adapter", "python" }
      if vim.fn.has("win32") == 1 then
        table.insert(ensure, "cpptools")
      end
      require("mason-nvim-dap").setup({
        ensure_installed = ensure,
        automatic_installation = true,
      })

      -- Python
      require("dap-python").setup("python")

      local function mason_path(pkg, sub, exe)
        local ok, p = pcall(mason_registry.get_package, pkg)
        if not ok then return nil end
        local path = p:get_install_path() .. sub
        if vim.fn.has("win32") == 1 and exe then path = path .. ".exe" end
        return path
      end

      -- JavaScript/TypeScript (js-debug: pwa-node)
      local js_debug = mason_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js", false)
      if js_debug then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = { command = "node", args = { js_debug, "${port}" } },
        }
        dap.configurations.javascript = {
          {
            name = "Launch Next.js (dev)",
            type = "pwa-node",
            request = "launch",
            program = "${workspaceFolder}/node_modules/.bin/next",
            args = { "dev" },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            runtimeExecutable = "node",
          },
        }
        dap.configurations.typescript = dap.configurations.javascript
      end


      -- Windows MSVC debugger (cppvsdbg)
      if vim.fn.has("win32") == 1 then
        local ok, pkg = pcall(mason_registry.get_package, "cpptools")
        if ok then
          local base = pkg:get_install_path()
          local exe = base .. "/extension/debugAdapters/bin/OpenDebugAD7.exe"
          if require("vim.fs").stat(exe) then
            dap.adapters.cppvsdbg = { type = "executable", command = exe }
            -- Prepend an MSVC config for convenience
            dap.configurations.cpp = dap.configurations.cpp or {}
            -- Filter out any codelldb configs to hide it on Windows
            if vim.tbl_islist(dap.configurations.cpp) then
              local filtered = {}
              for _, cfg in ipairs(dap.configurations.cpp) do
                if cfg.type ~= "codelldb" then table.insert(filtered, cfg) end
              end
              dap.configurations.cpp = filtered
            end
            table.insert(dap.configurations.cpp, 1, {
              name = "Launch C++ (MSVC/cppvsdbg)",
              type = "cppvsdbg",
              request = "launch",
              program = function() return vim.fn.input('Path to exe: ', vim.fn.getcwd() .. '/', 'file') end,
              cwd = '${workspaceFolder}',
              stopAtEntry = false,
            })
            dap.configurations.c = dap.configurations.cpp
            -- Remove codelldb adapter on Windows to avoid listing
            dap.adapters.codelldb = nil
          end
        end
      end

      -- UI lifecycle
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },
}

