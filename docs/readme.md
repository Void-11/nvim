# Neovim Unified IDE

A world‑class, batteries‑included Neovim configuration for full‑stack development, AI/ML research, and game development with Unreal Engine 5.6.1. Built to be fast, modular, cross‑platform, and intelligent in detecting your project’s tech stack.

- Frontend: Next.js 15, TypeScript, React, Tailwind CSS, shadcn/ui
- Backend: Node.js, Python APIs, Docker, Compose
- AI/ML & Data Science: Python, Jupyter, Quarto, librosa, PyTorch/TensorFlow (environment‑agnostic)
- Native/C++: Advanced clangd, CMake integration, LLDB debugging
- Unreal Engine 5.6.1: Project detection, editor launch, build/package helpers
- Databases: SQL, vim‑dadbod UI and completion
- Package managers: pnpm, npm, pip, Pixi, Homebrew integration

This config lives entirely under nvim-unified-ide and does not modify your existing configurations.

---

## Quick Start

1) Use a separate Neovim config namespace (recommended)

```bash path=null start=null
export NVIM_APPNAME=nvim-unified-ide
nvim
```

PowerShell:

```powershell path=null start=null
$env:NVIM_APPNAME = "nvim-unified-ide"
nvim
```

2) Or run the included installer (macOS/Linux)

```bash path=null start=null
bash /Users/viv/Developer/ML\ and\ AI/nvim-unified-ide/install.sh
```

First launch will bootstrap lazy.nvim, install plugins, LSPs, linters/formatters, and DAP adapters (via Mason).

---

## Requirements

- Neovim 0.9+ (recommended 0.10)
- Git, CMake, Make, ripgrep (rg), fd
- Node.js (LTS), Python 3.11+ (with pip), pnpm
- macOS: Docker Desktop (optional), Homebrew for tooling
- For Jupyter integration: python3 -m pip install --user pynvim jupyter jupytext
- For C++ debugging: system LLDB (/usr/bin/lldb-vscode) or Mason codelldb
- UE5: Engine path resolvable (defaults searched: /Applications/Epic Games/UE_5.6.1, /Users/Shared/Epic Games/UE_5.6.1, /opt/UnrealEngine, C:/Program Files/Epic Games/UE_5.6.1)

---

## Directory Structure

```text path=null start=null
nvim-unified-ide/
  init.lua
  install.sh
  README.md (root quick reference)
  docs/
    readme.md (this file)
    documentation.md (keybindings, motions, workflows)
  lua/
    core/
      options.lua
      keymaps.lua
      project_detection.lua
    plugins/
      init.lua
      ui.lua, telescope.lua, neo_tree.lua, git.lua, treesitter.lua, tools.lua
      lsp.lua, cmp.lua, conform.lua
      dap.lua, terminal.lua, cmake.lua, overseer.lua
      ue5.lua, gui.lua
      jupyter.lua, databases.lua, project_nvim.lua, project_templates.lua
```

---

## Intelligent Project Detection

The detector sets flags in vim.g.unified_project by scanning the project root for common markers:

- Web/Frontend: package.json, next.config.js/ts, tailwind.config.js/ts, components.json (shadcn)
- Package Managers: pnpm-lock.yaml, pnpm-workspace.yaml, pixi.toml, package-lock.json
- Backend/Infra: Dockerfile, docker-compose.yml/compose.yml, prisma/schema.prisma, *.sql, convex/
- Python/ML: pyproject.toml, requirements.txt, any *.ipynb
- C++/Build: CMakeLists.txt, CMakePresets.json, Makefile, compile_commands.json
- UE5: *.uproject

UE5 projects automatically set:
- vim.g.ue5_project_root, vim.g.ue5_project_file, vim.g.ue5_engine_path (heuristic paths)

These flags influence LSP setup (e.g., clangd args for UE5), statusline (Pixi env), and terminal presets.

---

## Major Components

- UI/UX: tokyonight theme, lualine, which-key, notify, indent guides, alpha dashboard
- Navigation: Telescope (fzf-native, ui-select), Neo-tree
- Treesitter: rich syntax tree highlighting and indentation for all relevant languages
- LSP: mason + mason-lspconfig + lspconfig; neodev; schemastore for JSON/YAML
- Completion: nvim-cmp + LuaSnip + friendly-snippets
- Formatting/Linting: conform.nvim with stylua, black/isort, prettierd/prettier, sqlfluff, taplo
- Debugging: nvim-dap + dap-ui + virtual-text + mason-nvim-dap; Python, Node, C++/LLDB, UE5 editor
- Build/Tasks: cmake-tools, overseer (toggleterm strategy)
- Terminals: toggleterm with project presets (pnpm dev, pixi shell, docker compose, convex dev)
- Data Science: magma-nvim, jupytext, quarto-nvim
- Databases: vim-dadbod + UI + completion
- UE5 Utilities: launch editor, build, package (RunUAT); UE‑aware clangd configuration

---

## LSP Servers and Tools (ensured via Mason)

- TypeScript/JavaScript: tsserver, tailwindcss, html, cssls
- Python: pyright
- Infra: dockerls, docker_compose_language_service, yamlls, jsonls, bashls
- Lua: lua_ls
- SQL: sqls
- C/C++: clangd (UE5‑aware flags)

Tools/formatters auto‑installed where possible: stylua, black, isort, prettier/prettierd, eslint_d, flake8, mypy, sqlfluff.

---

## Debugging

- Python: nvim-dap-python (auto wires to python)
- Node.js: node-debug2 adapter; preconfigured “Launch Next.js (dev)” configuration
- C/C++: LLDB (system lldb-vscode or codelldb)
- UE5: Additional dap configuration to start UnrealEditor with the current .uproject if detected

Keymaps (see docs/documentation.md for full list):
- F5/10/11/12 to Continue/Step Over/Into/Out
- <leader>b to toggle breakpoints, <leader>B for conditionals
- <leader>du to toggle dap-ui

---

## Build & Tasks

- CMake: cmake-tools with horizontal toggleterm executor and runner
- Overseer: generic task runner integrated with toggleterm; includes default templates

Keymaps:
- <leader>cg/cb/cr/cd/cc/ct/cs/cT for Generate/Build/Run/Debug/Clean/Run Tests/Build Type/Build Target
- Overseer: <leader>oo (Open), <leader>ot (Toggle), <leader>or (Run)

---

## Project Terminals

- <leader>td: pnpm dev (web projects)
- <leader>tp: pixi shell (ML workflows)
- <leader>tc: docker compose up (compose projects)
- <leader>tx: npx convex dev (Convex backend)
- <leader>tf/th/tv: floating/horizontal/vertical terminals

---

## UE5 Helpers

- <leader>ule: Launch Unreal Editor with the project
- <leader>ubd: Build Development
- <leader>upm: Package for Mac (example target)

Notes:
- Engine path detection is heuristic—adjust in lua/core/project_detection.lua if needed
- clangd is initialized with UE5 include paths and preprocessor defines

---

## Performance & Large Codebases

- Editor tuned for responsiveness: lazyredraw, synmaxcol limit, diagnostic configuration
- Treesitter auto-installs parsers as needed
- Large files (>1MB) reduce heavy features automatically

---

## Updating & Maintenance

- Plugin management: :Lazy, :Lazy update
- LSP/DAP/formatter tools: :Mason, :MasonUpdate
- Health checks: :checkhealth

To extend:
- Add your own plugin spec under lua/unified/plugins/<your>.lua and append require in lua/unified/plugins/init.lua

---

## Troubleshooting

- Missing servers/adapters: open :Mason and install
- Node.js debug: ensure node-debug2 adapter present (Mason), Next.js scripts available
- UE5: make sure a *.uproject exists in your root; verify engine path; generate compile_commands.json if needed
- Python/Jupyter: ensure pynvim is installed for the Python provider

---

## License

MIT
