return {
  -- Mason core
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = { ensure_installed = { "lua_ls", "clangd", "vtsls", "pyright", "ruff", "eslint", "tailwindcss", "jsonls", "yamlls", "dockerls", "docker_compose_language_service", "bashls", "html", "cssls", "sqlls", "emmet_language_server", "marksman" } },
  },
  { "WhoIsSethDaniel/mason-tool-installer.nvim", event = "VeryLazy" },

  -- LSP core
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "b0o/schemastore.nvim",
      "SmiteshP/nvim-navic",
    },
    config = function()
      -- Initialize neodev early so lua_ls picks up Neovim runtime and globals
      pcall(function()
        require("neodev").setup({})
      end)

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Diagnostics
      vim.diagnostic.config({
        virtual_text = { prefix = "●", source = "if_many" },
        float = { source = "always", border = "rounded" },
        signs = true, underline = true, update_in_insert = false, severity_sort = true,
      })

      -- Common on_attach
      local on_attach = function(client, bufnr)
        local function bufmap(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end
        bufmap("n", "gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
        bufmap("n", "gr", require("telescope.builtin").lsp_references, "Goto References")
        bufmap("n", "gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
        bufmap("n", "<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
        bufmap("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
        bufmap("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
        bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        bufmap({"n","v"}, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        bufmap("n", "K", vim.lsp.buf.hover, "Hover")
        bufmap("n", "gD", vim.lsp.buf.declaration, "Declaration")
        
        -- Avoid formatter conflicts (use conform.nvim for JS/TS formatting)
        if client.name == "vtsls" or client.name == "eslint" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
        
        -- Breadcrumbs (nvim-navic)
        local ok_navic, navic = pcall(require, "nvim-navic")
        if ok_navic and client.server_capabilities.documentSymbolProvider then
          pcall(navic.attach, client, bufnr)
        end
        
        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          local ih = vim.lsp.inlay_hint
          if type(ih) == "table" and type(ih.enable) == "function" then
            pcall(ih.enable, bufnr, true)
          elseif type(ih) == "function" then
            pcall(ih, bufnr, true)
          end
        end
      end

      -- Servers
      local servers = {
        -- TypeScript/JavaScript (vtsls)
        vtsls = {
          settings = {
            typescript = { preferences = { includePackageJsonAutoImports = "on", importModuleSpecifier = "non-relative" } },
            javascript = { preferences = { includePackageJsonAutoImports = "on" } },
            vtsls = {
              tsserver = { globalPlugins = {} },
              experimental = { completion = { enableServerSideFuzzyMatch = true } },
            },
          },
        },
        emmet_language_server = {},
        -- Markdown
        marksman = {},
        -- Python
        pyright = {
          settings = {
            python = { analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true, diagnosticMode = "workspace", typeCheckingMode = "basic" } },
          },
        },
        -- Tailwind
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  "tw`([^`]*)",
                  "tw=\"([^\"]*)",
                  "tw={\"([^\"}]*)",
                  "tw\\.\\w+`([^`]*)",
                  "tw\\(.*?\\)`([^`]*)",
                },
              },
            },
          },
          filetypes = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "vue" },
          root_dir = require("lspconfig.util").root_pattern("tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "postcss.config.ts", "package.json"),
        },
        -- JSON
        jsonls = {
          settings = {
            json = {
              schemas = (function()
                local ok, store = pcall(require, "schemastore")
                local schemas = ok and store.json.schemas() or {}
                table.insert(schemas, { fileMatch = { "*.uproject" }, url = "https://json.schemastore.org/unreal-engine-project.json" })
                table.insert(schemas, { fileMatch = { "*.uplugin" }, url = "https://json.schemastore.org/unreal-engine-plugin.json" })
                return schemas
              end)(),
              validate = { enable = true },
            },
          },
        },
        -- YAML
        yamlls = {
          settings = { yaml = { schemaStore = { enable = false, url = "" }, schemas = require("schemastore").yaml.schemas() } },
        },
        -- Docker
        dockerls = {},
        docker_compose_language_service = {},
        -- Bash
        bashls = {},
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
              },
              diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields" },
              },
              completion = { callSnippet = "Replace" },
              telemetry = { enable = false },
            },
          },
        },
        -- Web
        html = {},
        cssls = {},
        -- Disable ESLint LSP by default on Windows for performance; rely on Biome/Prettier for formatting
        eslint = { enabled = false },
        -- SQL (Node-based: sql-language-server; better Windows support)
        sqlls = {},
        -- Python linting (Ruff)
        ruff = {},
        -- C/C++ with clangd (UE5-aware)
        clangd = {
          cmd = (function()
            local args = {
              "--background-index", "--clang-tidy", "--completion-style=detailed", "--cross-file-rename",
              "--header-insertion=iwyu", "--header-insertion-decorators", "--function-arg-placeholders",
              "--fallback-style=none", "--all-scopes-completion", "--pch-storage=memory", "--malloc-trim",
              "--compile-commands-dir=.",
            }
            if _G.is_ue5_project and _G.is_ue5_project() then
              if vim.g.ue5_project_root then table.insert(args, "--compile-commands-dir=" .. vim.g.ue5_project_root) end
              if vim.g.ue5_engine_path then
                table.insert(args, "-I" .. vim.g.ue5_engine_path .. "/Engine/Source/Runtime/Core/Public")
                table.insert(args, "-I" .. vim.g.ue5_engine_path .. "/Engine/Source/Runtime/CoreUObject/Public")
                table.insert(args, "-I" .. vim.g.ue5_engine_path .. "/Engine/Source/Runtime/Engine/Public")
              end
              table.insert(args, "-DWITH_EDITOR=1")
              table.insert(args, "-DUE_BUILD_DEVELOPMENT=1")
              if vim.fn.has("mac") == 1 then
                table.insert(args, "-DPLATFORM_MAC=1")
              elseif vim.fn.has("win32") == 1 then
                table.insert(args, "-DPLATFORM_WINDOWS=1")
              elseif vim.fn.has("unix") == 1 then
                table.insert(args, "-DPLATFORM_LINUX=1")
              end
            end
            return vim.list_extend({ "clangd" }, args)
          end)(),
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
          init_options = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true },
        },
      }

      for name, conf in pairs(servers) do
        conf.capabilities = vim.tbl_deep_extend("force", {}, capabilities, conf.capabilities or {})
        conf.on_attach = on_attach
        lspconfig[name].setup(conf)
      end

      -- Ensure tools installed
      local ensure = vim.tbl_keys(servers)
      vim.list_extend(ensure, {
        -- Formatters and tools
        "stylua", "biome", "prettier", "prettierd", "clang-format",
        "eslint_d", "flake8", "mypy", "ruff",
      })
      pcall(require("mason-tool-installer").setup, { ensure_installed = ensure, run_on_start = true, auto_update = false })
    end,
  },
}

