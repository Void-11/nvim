# Neovim Unified IDE — Professional Documentation

This document is the authoritative reference for motions, keymaps, commands, and workflows across the Unified IDE. It’s designed for maximal efficiency whether you’re shipping a Next.js app, iterating on ML research, debugging C++ with LLDB/MSVC, or building an Unreal Engine game.

Leader is Space (`<leader>` = Space).

---

## Table of Contents

- General Editor Motions & Essentials
- File/Project Navigation
- LSP: Code Intelligence
- Completion & Snippets
- Formatting & Linting
- Debugging (DAP)
- Testing (neotest)
- Build Systems & Tasks (CMake, Overseer)
- Integrated Terminals
- Git Integration
- Treesitter Features
- Web Development (Next.js/TS/Tailwind/shadcn)
- Python & AI/ML (Jupyter/Quarto)
- C++ Development
- Unreal Engine 5.6.1
- Docker & DevOps
- Project Detection & Environments
- Windows Notes
- Performance Tips & Large Codebases
- Extending the Configuration

---

## General Editor Motions & Essentials

- Movement
  - h/j/k/l — left/down/up/right
  - w/W, b/B, e/E — word/WORD motions
  - 0/^/$ — line start, first non‑blank, end of line
  - gg/G — go to first/last line
  - { / } — paragraph navigation
  - % — matching pair
- Search
  - / and ? — forward/backward search; n/N — next/previous
  - * / # — search word under cursor (forward/back)
- Windows & Buffers
  - `<C-w>` + h/j/k/l — move between windows
  - `:vsplit`, `:split` — vertical/horizontal splits
  - `:bn` / `:bp` — next/prev buffer; `:bd` — close buffer
- Visual & Text Objects
  - v/V/`<C-v>` — visual char/line/block
  - ciw/diw/yaw — change/delete/yank inner word
  - ci"/ci'/ci) — change inside quotes/parens
- Editing helpers
  - gb — select last pasted text
  - J — join lines; gJ — join without space
  - = — reindent selection or motion
- Which‑key
  - Start with `<leader>`; which‑key shows discoverable groups and mappings

---

## File/Project Navigation

- Neo‑tree (file explorer)
  - `<leader>e` — Toggle explorer (left, shows hidden; filters common noise)
- Telescope (fuzzy finder)
  - `<leader>ff` — Find files (respects .gitignore, includes hidden)
  - `<leader>fg` — Live grep (ripgrep required)
  - `<leader>fb` — Buffers; `<leader>fh` — Help tags
  - `<leader>fs` — LSP document symbols; `<leader>fw` — workspace symbols
  - `<leader>fp` — Projects (project.nvim integration)
- Flash (fast motions)
  - `s` — jump; `S` — treesitter jump; `r` — remote; `R` — TS search
- Aerial (symbols outline)
  - `<leader>sa` — Toggle outline

---

## LSP: Code Intelligence

Powered by mason + mason‑lspconfig + lspconfig; schemastore for JSON/YAML; neodev for Lua.

On attach (buffer‑local):
- `gd` — Definitions (Telescope)
- `gr` — References (Telescope)
- `gI` — Implementations (Telescope)
- `gD` — Declarations
- `K` — Hover docs
- `<leader>rn` — Rename symbol
- `<leader>ca` — Code action (also in Visual mode)
- `<leader>D` — Type definition (Telescope)
- `<leader>ds` — Document symbols; `<leader>ws` — Workspace symbols

Diagnostics:
- `[d` / `]d` — Previous/next diagnostic
- `<leader>xx` — Toggle Trouble diagnostics list
- `<leader>xq` — Toggle quickfix (Trouble)
- `<leader>xr` — References (Trouble)

Servers include: vtsls, pyright, ruff, tailwindcss, html, cssls, dockerls, docker compose, yamlls, jsonls, bashls, lua_ls, sqlls, clangd (UE5‑aware). See README.md for the full list.

Inlay hints are enabled where servers support them.

---

## Completion & Snippets

- Completion: nvim‑cmp
  - `<C-n>/<C-p>` — next/prev item
  - `<C-y>` — confirm; `<C-Space>` — trigger completion
  - `<C-b>/<C-f>` — scroll docs
- Snippets: LuaSnip
  - `<C-l>` — expand or jump forward; `<C-h>` — jump backward
  - Friendly‑snippets preloaded; project_templates.lua adds custom templates:
    - TSX: nextpage; JS: express; Python: mlscript; C++: main; UE5 C++: uclass/ustruct/uenum/uprop/ufunc

---

## Formatting & Linting

- Conform.nvim orchestrates formatters
  - `<leader>F` — Format buffer (non‑blocking)
  - On‑save formatting is enabled for most filetypes
  - vtsls LSP formatting is disabled to avoid conflicts with Prettier
- Defaults:
  - Python: Ruff (ruff_fix, ruff_format)
  - Web: Prettierd/Prettier (js/ts/jsx/tsx/json/yaml/markdown/css/html)
  - Lua: stylua
- Python preference:
  - `:PythonFormatUseRuff` — select Ruff

---

## Debugging (DAP)

Core stack: nvim‑dap, dap‑ui, virtual‑text, mason‑nvim‑dap; plus nvim‑dap‑python.

Keymaps:
- `<F5>` — Continue/Start
- `<F10>` — Step Over
- `<F11>` — Step Into
- `<F12>` — Step Out
- `<leader>b` — Toggle breakpoint
- `<leader>B` — Conditional breakpoint
- `<leader>du` — Toggle DAP UI
- Windows C++: `<leader>dm` — run first cppvsdbg config

Adapters/Configs:
- Python: nvim‑dap‑python (uses `python`, virtualenv aware)
- Node.js: js‑debug (pwa‑node), preconfigured “Launch Next.js (dev)”
- C/C++:
  - Windows: MSVC `cppvsdbg` (via Mason cpptools)
  - macOS/Linux: LLDB (system or codelldb if you add it)

Tips:
- Use dap‑ui for scopes, watches, threads, REPL
- Use attach‑to‑process for native processes where applicable

---

## Testing (neotest)

- `<leader>tt` — Run nearest test
- `<leader>tT` — Run current file
- `<leader>to` — Open output (enter)
- `<leader>ts` — Toggle summary panel

Adapters: Python, Jest, Vitest, GoogleTest.

---

## Build Systems & Tasks

CMake (cmake‑tools):
- `<leader>cg` — Generate
- `<leader>cb` — Build
- `<leader>cr` — Run
- `<leader>cd` — Debug
- `<leader>cc` — Clean
- `<leader>ct` — Run tests
- `<leader>cs` — Select build type
- `<leader>cT` — Select build target

Overseer:
- `<leader>oo` — Open task list
- `<leader>ot` — Toggle task list
- `<leader>or` — Run task

The toggleterm strategy is used for integrated terminals.

---

## Integrated Terminals (toggleterm)

- `<C-\>` — Toggle terminal overlay (float)
- `<leader>tf` — Float; `<leader>th` — Horizontal; `<leader>tv` — Vertical

Project Presets:
- `<leader>td` — pnpm dev (web)
- `<leader>tp` — pixi shell (ML)
- `<leader>tc` — docker compose up (compose)
- `<leader>tx` — npx convex dev (Convex)

---

## Git Integration

In a Git‑tracked buffer (gitsigns):
- `]c` / `[c` — Next/previous hunk
- `<leader>hs` — Stage hunk; `<leader>hr` — Reset hunk; `<leader>hp` — Preview hunk
- `<leader>hb` — Blame line (full)

Also available: vim‑fugitive (`:Git`).

---

## Treesitter Features

- Highlighting and indentation for a broad set of languages (TS/TSX, Python, C/C++, SQL, YAML, JSON, Dockerfile, etc.)
- Textobjects:
  - `af/if` — a function / inner function; `ac/ic` — a class / inner class
  - Movements: `]m`/`[m` functions; `]c`/`[c` classes
- Auto‑install missing parsers when compilers are available (MSVC, Zig, Clang, GCC)

---

## Web Development (Next.js/TS/Tailwind/shadcn)

- LSP: vtsls, tailwindcss, html, cssls, jsonls, yamlls, emmet
- Formatting: Prettierd/Prettier
- Debugging: js‑debug (Launch Next.js dev)
- Terminals: `<leader>td` (pnpm dev); `<leader>tc` (docker compose)
- Tailwind: `classRegex` configured to support common patterns and `tw\`...\`` usage

---

## Python & AI/ML (Jupyter/Quarto)

- LSP: pyright; Ruff linting server available
- Jupyter toolchain:
  - magma‑nvim — inline cell evaluation and outputs
    - `:MagmaInit`, `:MagmaEvaluateLine`, `:MagmaEvaluateVisual`
    - Keymaps: `<leader>mi`, `<leader>ml`, `<leader>mv`, `<leader>mc`, `<leader>md`
  - jupytext.nvim — transparent pairing between .ipynb and .md/.py
  - quarto‑nvim — literate programming and reports
- Terminal: `<leader>tp` (pixi shell)

---

## C++ Development

- LSP: clangd with enhanced flags (completion‑style=detailed, clang‑tidy, placeholders, cross‑file rename)
- File associations: `.h` treated as C++ header
- Build: cmake‑tools (uses `build/` or UE5 Intermediate), soft‑links compile_commands.json
- DAP: LLDB (macOS/Linux) or MSVC cppvsdbg (Windows)

Recommended pattern:
- Use CMake presets or generate with `<leader>cg`
- Build via `<leader>cb`, run via `<leader>cr`, debug via `<leader>cd`

---

## Unreal Engine 5.6.1

Detection:
- Any `*.uproject` at repo root marks a UE5 project
- Engine path detection checks common macOS/Linux/Windows paths; tune in `lua/core/project_detection.lua`

Helpers (keymaps):
- `<leader>ule` — Launch Unreal Editor for the project
- `<leader>ubd` — Build project (Development)
- `<leader>upm` — Package project (example target)

clangd for UE5:
- Adds include paths and defines (WITH_EDITOR=1, UE_BUILD_DEVELOPMENT=1, platform define)
- Uses project `compile_commands.json` when present; recommended for better indexing

Snippets for UE5 (C++): uclass, ustruct, uenum, uprop, ufunc.

---

## Docker & DevOps

- LSP: dockerls and docker‑compose language service
- Terminal: `<leader>tc` to run docker compose up
- YAML/JSON schemas via schemastore (great for infra configs, including K8s)

---

## Project Detection & Environments

Flags (`vim.g.unified_project`):
- Web: has_package_json, is_nextjs, has_ts, has_tailwind, has_shadcn
- Managers: has_pnpm, has_npm, has_pixi, has_pip, has_brew
- Backend/DB: has_prisma, has_sql, has_redis, has_convex
- Containers: has_docker, has_docker_compose
- Python/ML: has_notebooks, has_ml
- C++/Build: has_cmake, has_make, has_compile_commands
- UE5: is_ue5

These influence LSP and terminal presets. Customize in `lua/core/project_detection.lua` if needed.

---

## Windows Notes

- Shell defaults to PowerShell inside Neovim
- MSVC environment is auto‑imported (VsDevCmd) so `cl` is available for Treesitter and native builds
- Telescope fzf‑native builds via CMake (requires CMake on PATH)
- C++ debugging uses MSVC cppvsdbg (installed via Mason cpptools)

---

## Performance Tips & Large Codebases

- Large files (>1MB) automatically disable heavy features for speed
- Telescope and Neo‑tree ignore big folders (node_modules, .git, build, dist, .next) by default
- Tune diagnostics/virtual text in `lsp.lua` if needed
- Prefer `compile_commands.json` for precise clangd indexing (CMake or UE5 tools)

---

## Extending the Configuration

- Add a new plugin spec to `lua/plugins/your_module.lua` and `require` it in `lua/plugins/init.lua`
- Extend `lsp.lua` with per‑server settings, and `conform.lua` for formatters
- Add Overseer templates or more toggleterm presets for project workflows
- Add snippets in `project_templates.lua` or VSCode‑style JSON via friendly‑snippets

---

## Appendix: Command Cheatsheet

- `:Lazy` — Manage plugins
- `:Mason` — Manage LSPs/formatters/debuggers
- `:CheckHealth` — Verify environment
- `:CMakeGenerate` / `:CMakeBuild` / `:CMakeRun` / `:CMakeDebug`
- `:OverseerOpen` / `:OverseerRun`
- `:MagmaInit` / `:MagmaEvaluateLine` / `:MagmaEvaluateVisual`
- `:DBUI` / `:DBUIToggle`

Happy hacking — ship confidently across web, ML, C++, and UE5.
