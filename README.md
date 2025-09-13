# nvim-unified-ide

A single, unified Neovim configuration that supports AI/ML, web development (Next.js 15/TypeScript/React/Tailwind/shadcn), backend development (Node.js/Python/APIs), C++ (with advanced LSP and CMake/Make), Unreal Engine 5.6.1, containers (Docker/Compose), package managers (pnpm, Pixi, npm, pip, Homebrew), and databases (Convex, Redis, SQL).

This config is built from scratch and does not modify your existing configs in `init.lua` (AI/ML) or `nvim-main/` (C++/UE5). It lives entirely in `nvim-unified-ide/`.

---

## Quick Start

1) Set NVIM to use this config (recommended via NVIM_APPNAME) and start Neovim:

macOS/Linux (zsh/bash):

```bash
export NVIM_APPNAME=nvim-unified-ide
nvim
```

Fish:

```bash
set -x NVIM_APPNAME nvim-unified-ide
nvim
```

Windows PowerShell:

```powershell
$env:NVIM_APPNAME = "nvim-unified-ide"
nvim
```

2) On first launch, plugins will be installed automatically via lazy.nvim and Mason.

3) Check basic health:

```bash
:checkhealth
```

---

## Directory Layout

- `init.lua` – entry point that bootstraps lazy.nvim and loads modules
- `lua/core/`
  - `options.lua` – core editor settings and performance tweaks
  - `project_detection.lua` – auto-detects project types (Next.js, Tailwind, Pixi, Python/ML, Docker, CMake/Make, UE5, etc.)
  - `keymaps.lua` – global keybindings and which-key groups
- `lua/plugins/` – modular plugin specs
  - `init.lua` – aggregator that pulls in every module below
  - `ui.lua` – colorscheme, lualine, notifications, which-key, indent guides, dashboard
  - `telescope.lua` – fuzzy finder with fzf-native and ui-select
  - `neo_tree.lua` – file explorer
  - `git.lua` – gitsigns
  - `treesitter.lua` – syntax highlighting and indentation
  - `tools.lua` – utilities (plenary, Comment.nvim, surround, autopairs, schemastore)
  - `lsp.lua` – Mason, LSP servers, UE5-aware clangd
  - `cmp.lua` – autocompletion with LuaSnip
  - `conform.lua` – formatting and linting
  - `dap.lua` – debugging for Python/Node/C++/UE5
  - `terminal.lua` – toggleterm terminals for pnpm/pixi/docker/convex
  - `cmake.lua` – cmake-tools integration and keymaps
  - `overseer.lua` – task runner
  - `ue5.lua` – UE5 helpers (build/launch/package)
  - `gui.lua` – process and GUI app launcher helpers
  - `jupyter.lua` – magma/jupytext/quarto for data science
  - `databases.lua` – vim-dadbod with UI and completion
  - `project_nvim.lua` – project management and telescope integration
  - `project_templates.lua` – snippets/templates for Next.js, Node, Python ML, C++

---

## Features by Stack

- Frontend (Next.js/TS/React/Tailwind/shadcn)
  - LSP: TypeScript (tsserver), TailwindCSS, HTML, CSS
  - DAP: Node.js (Next.js dev)
  - Format: Prettier/Prettierd
  - Terminals: pnpm dev

- Backend (Node.js/Python/APIs/DB)
  - LSP: tsserver, pyright, YAML, JSON, Docker, Bash
  - DAP: Node.js and Python
  - Format: black/isort (Python), Prettier
  - Databases: vim-dadbod + UI

- AI/ML (Python, Jupyter, librosa, PyTorch/TensorFlow)
  - LSP: pyright
  - Jupyter/Quarto: magma-nvim, jupytext, quarto-nvim
  - Terminals: Pixi shell

- C++
  - LSP: clangd with enhanced flags
  - Build: cmake-tools, Make
  - DAP: LLDB (codelldb or system lldb-vscode)
  - GUI launcher helpers for app binaries

- Unreal Engine 5.6.1
  - Project detection: *.uproject
  - Helpers: launch editor, build, package
  - clangd args augmented for UE5 includes and defines

- DevOps (Docker/Compose)
  - LSP: dockerls, docker-compose language service
  - Terminals: docker compose up

- Package Managers (pnpm, Pixi, npm, pip, Homebrew)
  - Terminals and detection toggles (pnpm, pixi)

- Databases (Convex, Redis, SQL)
  - DB UI and completion; terminals for convex

---

## Keybindings Overview

- Space is leader
- Files/Navigation
  - `<leader>e` – Toggle explorer (neo-tree)
  - `<leader>ff` – Find files
  - `<leader>fg` – Live grep
  - `<leader>fb` – Buffers
  - `<leader>fh` – Help tags
  - `<leader>fp` – Projects (project.nvim + telescope)
- LSP
  - `gd`, `gr`, `gI`, `K`, `<leader>rn`, `<leader>ca`, `<leader>D`, `<leader>ds`, `<leader>ws`
- Format
  - `<leader>F` – Format buffer
- Debugging
  - `<F5>/<F10>/<F11>/<F12>` – Continue/Step Over/Into/Out
  - `<leader>b` – Toggle breakpoint, `<leader>B` – Conditional breakpoint
  - `<leader>du` – Toggle DAP UI
- Terminals
  - `<C-\>` – Toggle main terminal
  - `<leader>td` – pnpm dev
  - `<leader>tp` – Pixi shell
  - `<leader>tc` – docker compose up
  - `<leader>tx` – convex dev
  - `<leader>tf|th|tv` – float/horizontal/vertical terminals
- CMake
  - `<leader>cg|cb|cr|cd|cc|ct|cs|cT` – Generate/Build/Run/Debug/Clean/Tests/BuildType/Target
- UE5
  - `<leader>ule` – Launch Editor
  - `<leader>ubd` – Build Development
  - `<leader>upm` – Package for Mac (example)
- Databases
  - `<leader>dbu` – Open DB UI, `<leader>dbc` – Toggle DB UI

---

## Project Detection

`lua/core/project_detection.lua` sets flags in `vim.g.unified_project`, including:

- Web: `has_package_json`, `is_nextjs`, `has_ts`, `has_tailwind`, `has_shadcn`
- Package managers: `has_pnpm`, `has_npm`, `has_pixi`, `has_pip`, `has_brew`
- Backend/DB: `has_prisma`, `has_sql`, `has_redis`, `has_convex`
- Containers: `has_docker`, `has_docker_compose`
- Python/ML: `has_notebooks`, `has_ml`
- C++/Build: `has_cmake`, `has_make`, `has_compile_commands`
- UE5: `is_ue5` and globals `ue5_project_root`, `ue5_project_file`, `ue5_engine_path`

These are used to adjust behavior (e.g., clangd args for UE5, showing Pixi env in statusline, terminal commands).

---

## Installation Notes

- Core tools (macOS via Homebrew suggested):

```bash
brew install node python@3.11 pnpm cmake ninja make git ripgrep fd neovim
brew install --cask docker
pipx install ruff pylint
# Optional DAP tools are managed by Mason, but you may install codelldb system-wide if desired.
```

- Language servers and formatters are auto-installed by Mason/Mason Tool Installer when possible. For JS/TS formatting, Prettierd provides best performance.

- Jupyter tooling:

```bash
pip install jupyter jupytext
# For magma-nvim, ensure Neovim Python provider is set up:
python3 -m pip install --user pynvim
```

- UE5: ensure your Engine path matches one of:
  - `/Applications/Epic Games/UE_5.6.1` (macOS)
  - `/Users/Shared/Epic Games/UE_5.6.1`
  - `/opt/UnrealEngine` (Linux)
  - `C:/Program Files/Epic Games/UE_5.6.1` (Windows)

Edit `lua/core/project_detection.lua` if your engine path differs.

---

## Using This Config Alongside Others

This config is self-contained and won’t touch your other configs. To switch between configs, change NVIM_APPNAME before launching Neovim.

```bash
export NVIM_APPNAME=nvim-main && nvim   # your C++/UE5 config
export NVIM_APPNAME=nvim-unified-ide && nvim   # unified config
```

---

## Troubleshooting

- If some LSP/DAP adapters don’t start: `:Mason` and ensure packages are installed.
- For UE5 projects, ensure `*.uproject` exists in the project root and engine path detection succeeds.
- For Next.js debugging, make sure Node and the node-debug2 adapter are installed (Mason handles this).

---

## License

MIT
