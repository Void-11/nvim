# Neovim Config

A unified, batteries-included Neovim configuration for full‑stack development, AI/ML research, native/C++ (including Unreal Engine 5), DevOps, and databases. It is fast, modular, cross‑platform, and project‑aware.

Highlights:
- Plugin manager: lazy.nvim
- Intelligent project detection (web, ML, C++, UE5, Docker, DB, package managers)
- Sensible defaults and performance tuning for large codebases
- Windows support with MSVC environment auto‑import for compilers and Treesitter

## Quick links
- [DOCUMENTATION.md](./DOCUMENTATION.md)
- [KEYMAPS.md](./KEYMAPS.md)
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)

---

## Quick Start

Use a separate Neovim config namespace (recommended) and launch Neovim. First launch will bootstrap plugins and developer tools via Mason.

macOS/Linux (bash/zsh):

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

Then run a quick health check inside Neovim:

```vim
:checkhealth
```

---

## Requirements

- Neovim 0.9+ (0.10 recommended)
- Git
- ripgrep (rg) and fd (for Telescope)
- Node.js LTS, Python 3.11+
- Build tools: CMake and a C/C++ compiler toolchain
  - Windows: Visual Studio Build Tools (C++ workload). This config auto‑imports MSVC (VsDevCmd) into the current session so Treesitter can compile using `cl`.
- Optional: Docker Desktop, pnpm, Pixi

Jupyter provider (optional):

```bash
python3 -m pip install --user pynvim jupyter jupytext
```

---

## Directory Layout

- `init.lua` – bootstraps lazy.nvim, sets runtime paths, loads core and plugins
- `lua/core/`
  - `options.lua` – editor settings, performance, Windows shell defaults
  - `project_detection.lua` – sets `vim.g.unified_project` flags (web, ML, Docker, CMake/Make, UE5, etc.) and UE5 paths
  - `keymaps.lua` – global keymaps; which‑key groups registered in UI plugin
  - `msvc_env.lua` – imports the Visual Studio Developer environment into Neovim on Windows
  - `python_format_toggle.lua` – helper to select Python formatting preferences
- `lua/plugins/`
  - `init.lua` – aggregates all plugin specs
  - UI: `ui.lua` (tokyonight, lualine with navic breadcrumbs, notify, which‑key, indent guides, alpha)
  - Navigation: `telescope.lua` (fzf‑native, ui‑select), `neo_tree.lua`
  - LSP/Completion: `lsp.lua` (mason, mason‑lspconfig, lspconfig, schemastore, navic), `cmp.lua` (nvim‑cmp+LuaSnip)
  - Formatting: `conform.lua`
  - Debugging: `dap.lua` (nvim‑dap, dap‑ui, virtual‑text, mason‑nvim‑dap, dap‑python)
  - Terminals/Tasks: `terminal.lua` (toggleterm), `cmake.lua` (cmake‑tools), `overseer.lua`
  - Source control: `git.lua` (gitsigns), plus `vim‑fugitive` available on demand
  - Productivity: `tools.lua` (Comment.nvim, surround, autopairs, trouble, noice, spectre, todo‑comments, colorizer, flash, aerial)
  - Domain: `ue5.lua` (helpers), `jupyter.lua` (magma/jupytext/quarto), `databases.lua` (vim‑dadbod),
    `project_nvim.lua` (projects), `project_templates.lua` (snippets/templates), `tests.lua` (neotest)

---

## Features by Stack

- Frontend (Next.js/TypeScript/React/Tailwind/shadcn)
  - LSP: vtsls (TypeScript), TailwindCSS, HTML, CSS, Emmet
  - Format: Prettierd/Prettier (fast on‑save)
  - Debug: js‑debug (pwa‑node) with a preconfigured “Launch Next.js (dev)”
  - Terminals: pnpm dev

- Backend (Node.js/Python/APIs)
  - LSP: vtsls, pyright, YAML, JSON, Docker, Bash, SQL
  - Debug: Node (pwa‑node) and Python (dap‑python)
  - Format: Ruff (ruff_fix + ruff_format) for Python; Prettier(d) for JS/TS

- AI/ML (Python, Jupyter, Quarto)
  - Jupyter/Quarto: magma‑nvim, jupytext, quarto‑nvim
  - Terminal preset: Pixi shell

- C++
  - LSP: clangd with rich flags (clang‑tidy, placeholders, cross‑file rename); UE5‑aware includes/defines when applicable
  - Build: cmake‑tools (presets supported), Make
  - Debug: LLDB (non‑Windows) or MSVC cppvsdbg (Windows)

- Unreal Engine 5.6.1
  - Detection via `*.uproject` and heuristic engine paths
  - Helpers: launch editor, build, package (RunUAT), statusline env info

- DevOps (Docker/Compose)
  - LSP: dockerls, docker‑compose language service
  - Terminal preset: docker compose up

- Databases (Convex, Redis, SQL)
  - vim‑dadbod UI + completion; SQL omnifunc configured automatically

- Productivity/UI
  - which‑key, notify/noice, alpha dashboard, trouble, spectre, todo‑comments, colorizer, aerial outline, flash motions

---

## Keybindings Overview

- Leader is Space
- Files & Search
  - `<leader>e` – Toggle explorer (Neo‑tree)
  - `<leader>ff` – Find files, `<leader>fg` – Live grep, `<leader>fb` – Buffers, `<leader>fh` – Help
  - `<leader>fp` – Projects (project.nvim)
- LSP
  - `gd`, `gr`, `gI`, `gD`, `K`, `<leader>rn`, `<leader>ca`, `<leader>D`, `<leader>ds`, `<leader>ws`
  - Diagnostics: `[d` / `]d` (prev/next), `<leader>xx` (Trouble diagnostics toggle), `<leader>xq` (Quickfix list), `<leader>xr` (References)
- Completion & Snippets (insert mode)
  - `<C-n>/<C-p>` – next/prev
  - `<C-y>` – confirm, `<C-Space>` – trigger
  - `<C-l>/<C-h>` – LuaSnip jump forward/back
- Formatting
  - `<leader>F` – Format buffer (Conform)
  - `:PythonFormatUseRuff` – prefer Ruff for Python
- Debugging (DAP)
  - `<F5>/<F10>/<F11>/<F12>` – Continue/Step Over/Into/Out
  - `<leader>b` – Toggle breakpoint, `<leader>B` – Conditional breakpoint
  - `<leader>du` – Toggle DAP UI
  - Windows C++ convenience: `<leader>dm` – run first cppvsdbg config
- Terminals
  - `<C-\>` – Toggle floating terminal
  - `<leader>tf`/`th`/`tv` – float/horizontal/vertical terminals
  - Presets: `<leader>td` pnpm dev, `<leader>tp` Pixi, `<leader>tc` docker compose, `<leader>tx` convex dev
- CMake
  - `<leader>cg`/`cb`/`cr`/`cd`/`cc`/`ct`/`cs`/`cT` – Generate/Build/Run/Debug/Clean/Tests/BuildType/Target
- UE5
  - `<leader>ule` – Launch Editor, `<leader>ubd` – Build (Development), `<leader>upm` – Package
- Databases
  - `<leader>dbu` – Open DB UI, `<leader>dbc` – Toggle DB UI
- Outline & Motions
  - `<leader>sa` – Toggle Aerial symbols outline
  - `s`/`S` – Flash jump/treesitter, `r`/`R` – Remote/TS search (operator‑pending)

For an exhaustive reference, see DOCUMENTATION.md.

---

## Language Servers & Tools

Managed via mason + mason‑lspconfig. Servers configured include:
- TypeScript/JavaScript: vtsls, emmet_language_server, eslint, html, cssls, tailwindcss
- Python: pyright, ruff
- Infra: dockerls, docker_compose_language_service, yamlls, jsonls, bashls
- Lua: lua_ls (with neodev)
- SQL: sqlls
- C/C++: clangd (UE5‑aware when detected)

Diagnostics are configured with virtual text, signs, rounded floating windows, and inlay hints (where supported).

Tools ensured (via mason‑tool‑installer): stylua, prettier/prettierd, eslint_d, flake8, mypy, ruff, and more where applicable.

---

## Formatting

Conform.nvim orchestrates formatters:
- Python: Ruff (ruff_fix + ruff_format)
- Web: Prettierd/Prettier (js, ts, jsx/tsx, json, yaml, markdown, css, html)
- Lua: stylua

On‑save formatting is enabled for most filetypes. LSP formatting is disabled for vtsls to avoid conflicts with Prettier.

Python preference can be set at runtime:

```vim
:PythonFormatUseRuff
```

---

## Debugging

- Python: nvim‑dap‑python (auto wires to your `python`)
- Node.js/TS: js‑debug (pwa‑node) with a Next.js “dev” launch configuration
- C/C++:
  - Windows: MSVC `cppvsdbg` (auto‑installed via Mason cpptools); `<leader>dm` launches the first cppvsdbg config
  - macOS/Linux: use system LLDB or Mason codelldb if you add it

DAP UI opens automatically on start and closes when a session ends.

---

## Testing (neotest)

- `<leader>tt` – Run nearest test
- `<leader>tT` – Run current file
- `<leader>to` – Open output (enter)
- `<leader>ts` – Toggle summary

Adapters: Python, Jest, Vitest, and GoogleTest.

---

## Project Detection

`lua/core/project_detection.lua` scans the working directory to set flags in `vim.g.unified_project`, such as:
- Web: has_package_json, is_nextjs, has_ts, has_tailwind, has_shadcn
- Managers: has_pnpm, has_npm, has_pixi, has_pip, has_brew
- Backend/DB: has_prisma, has_sql, has_redis, has_convex
- Containers: has_docker, has_docker_compose
- Python/ML: has_notebooks, has_ml
- C++/Build: has_cmake, has_make, has_compile_commands
- UE5: is_ue5, plus ue5_project_root/file/engine_path

These flags influence LSP options (e.g., UE5 clangd args), statusline (Pixi env), and terminal presets.

---

## Windows Notes

- Shell: defaults to PowerShell in Neovim for better compatibility
- MSVC environment: auto‑imported via `lua/core/msvc_env.lua` so `cl` is available for Treesitter and native builds
- Telescope fzf‑native: built via CMake on Windows (requires CMake)
- C++ debugging: uses MSVC cppvsdbg (via Mason cpptools)

---

## Using This Config Alongside Others

This config is self‑contained. To switch between configs, set NVIM_APPNAME before launching Neovim:

```bash
export NVIM_APPNAME=nvim-main && nvim   # your other config
export NVIM_APPNAME=nvim-unified-ide && nvim   # this config
```

---

## Troubleshooting

- Missing servers/adapters/formatters: `:Mason` and ensure packages are installed; `:MasonUpdate` to refresh indexes
- Treesitter parser build issues on Windows: install Visual Studio Build Tools (C++ workload); this config auto‑imports the MSVC env
- UE5: ensure a `*.uproject` exists at the repo root and engine path is correct; generate `compile_commands.json` for better clangd indexing
- Next.js debug: ensure Node and js‑debug are installed (Mason handles js‑debug); use the provided launch config

---
