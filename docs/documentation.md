# Neovim Unified IDE — Professional Documentation

This document is the authoritative reference for motions, keymaps, commands, and workflows across the Unified IDE. It is designed for maximal efficiency whether you’re shipping a Next.js app, iterating on ML research, debugging C++ with LLDB, or building an Unreal Engine game.

All leader mappings use the Space key as <leader>.

---

## Table of Contents

- General Editor Motions & Essentials
- File/Project Navigation
- LSP: Code Intelligence
- Completion & Snippets
- Formatting & Linting
- Debugging (DAP)
- Build Systems & Tasks (CMake, Overseer)
- Integrated Terminals
- Git Integration
- Treesitter Features
- Databases (vim-dadbod)
- Web Development (Next.js/TS/Tailwind/shadcn)
- Python & AI/ML (Jupyter/Quarto)
- C++ Development
- Unreal Engine 5.6.1
- Docker & DevOps
- Project Detection & Environments
- Performance Tips & Large Codebases
- Extending the Configuration

---

## General Editor Motions & Essentials

Navigating efficiently in Neovim is foundational. Below are the essential motions and the most useful quality-of-life tweaks provided by this configuration.

- Movement
  - h/j/k/l — left/down/up/right
  - w/W, b/B, e/E — word and WORD motions
  - 0/^/$ — line start (column 0), first non-blank, end of line
  - gg/G — go to first/last line
  - { / } — paragraph navigation
  - % — jump to matching pair ((), {}, [])
- Search
  - /, ? — forward/backward search
  - n, N — next/prev match
  - * — search word under cursor forward; # backward
- Windows & Buffers
  - <C-w> + h/j/k/l — move between windows
  - :vsplit, :split — vertical/horizontal splits
  - :bnext (:bn), :bprev (:bp) — next/prev buffer
  - :bd — close buffer
- Visual & Object
  - v/V/<C-v> — visual char/line/block
  - ciw/diw/yaw — change/delete/yank inner word
  - ci"/ci'/ci) — change inside quotes/parens (similarly for other text objects)
- Editing helpers
  - gb — select last pasted text (useful with P)
  - J — join lines; gJ — join without space
  - = — reindent selection or motion

Which-key
- This config enables which-key to display leader mappings dynamically as you type. Start with <leader> and explore.

---

## File/Project Navigation

- Neo-tree (file explorer)
  - <leader>e — Toggle file explorer
  - Opens on the left, shows hidden, ignores common noise (node_modules, .git, caches)

- Telescope (fuzzy finder)
  - <leader>ff — Find files (respects .gitignore, includes hidden)
  - <leader>fg — Live grep (ripgrep required)
  - <leader>fb — Buffers
  - <leader>fh — Help tags
  - <leader>fs — LSP document symbols
  - <leader>fw — LSP workspace symbols
  - <leader>fp — Projects (project.nvim integration)

---

## LSP: Code Intelligence

Provided via mason + mason-lspconfig + lspconfig; schemastore for JSON/YAML; neodev for Lua.

On attach (buffer-local):
- gd — Go to definition (Telescope)
- gr — References (Telescope)
- gI — Implementations (Telescope)
- gD — Go to declaration
- K — Hover docs
- <leader>rn — Rename symbol
- <leader>ca — Code action (also works in Visual mode)
- <leader>D — Type definition (Telescope)
- <leader>ds — Document symbols
- <leader>ws — Workspace symbols

Diagnostics:
- [d / ]d — Previous/next diagnostic
- <leader>e — Show diagnostics in a floating window

Servers include: tsserver, pyright, tailwindcss, html, cssls, dockerls, docker compose, yamlls, jsonls, bashls, lua_ls, sqls, clangd (UE5-aware). See docs/readme.md for the full list.

---

## Completion & Snippets

- Completion: nvim-cmp
  - <C-n>/<C-p> — next/prev item
  - <C-y> — confirm
  - <C-Space> — trigger completion menu
  - <C-b>/<C-f> — scroll docs
- Snippets: LuaSnip
  - <C-l> — expand or jump forward
  - <C-h> — jump backward
  - Friendly-snippets preloaded; project_templates.lua adds custom templates:
    - TSX: nextpage
    - JS: express
    - Python: mlscript
    - C++: main
    - UE5 (C++): uclass, ustruct, uenum, uprop, ufunc

---

## Formatting & Linting

- conform.nvim orchestrates formatters
  - <leader>F — Format buffer (non-blocking)
  - On-save formatting for most filetypes; C/C++ falls back to LSP disabled by default to avoid clangd conflicts (can be changed in conform.lua)
- Installed tools include stylua, black/isort, prettierd/prettier, sqlfluff, etc.

---

## Debugging (DAP)

Core stack: nvim-dap, dap-ui, virtual-text, mason-nvim-dap; plus nvim-dap-python.

Keymaps:
- <F5> — Continue/Start
- <F10> — Step Over
- <F11> — Step Into
- <F12> — Step Out
- <leader>b — Toggle breakpoint
- <leader>B — Conditional breakpoint (prompts)
- <leader>du — Toggle DAP UI

Adapters/Configs:
- Python: nvim-dap-python (uses python, virtualenv aware)
- Node.js: node-debug2 (Launch Next.js dev)
- C/C++: LLDB (system /usr/bin/lldb-vscode or Mason codelldb)
- UE5: Optional config to launch UnrealEditor with -debug and the active .uproject

Tips:
- Use dapui for scopes, watches, stacks, and repl/console
- Use “Attach to Process” for native processes (dap.utils.pick_process)

---

## Build Systems & Tasks

CMake (cmake-tools):
- <leader>cg — Generate
- <leader>cb — Build
- <leader>cr — Run
- <leader>cd — Debug
- <leader>cc — Clean
- <leader>ct — Run tests
- <leader>cs — Select build type
- <leader>cT — Select build target

Overseer:
- <leader>oo — Open task list
- <leader>ot — Toggle task list
- <leader>or — Run task

Configuration uses toggleterm strategy for integrated terminals.

---

## Integrated Terminals (toggleterm)

- <C-\> — Toggle terminal overlay (float)
- <leader>tf — Toggle float terminal
- <leader>th — Toggle horizontal terminal
- <leader>tv — Toggle vertical terminal

Project Presets:
- <leader>td — pnpm dev (web)
- <leader>tp — pixi shell (ML)
- <leader>tc — docker compose up (compose)
- <leader>tx — npx convex dev (Convex)

---

## Git Integration (gitsigns)

In a Git-tracked buffer:
- ]c / [c — Next/previous hunk
- <leader>hs — Stage hunk
- <leader>hr — Reset hunk
- <leader>hp — Preview hunk
- <leader>hb — Blame line (full popup)

Tip: Use :Git (vim-fugitive) for advanced operations if you prefer command-line-like UX inside Neovim.

---

## Treesitter Features

- Highlighting, indentation for a broad set of languages (TS, React/TSX, Python, C/C++, SQL, YAML, JSON, Dockerfile, etc.)
- Auto-install missing parsers on open

---

## Databases (vim-dadbod)

- <leader>dbu — Open DB UI
- <leader>dbc — Toggle DB UI
- SQL buffers use vim-dadbod-completion (omnifunc) for database-aware completion

You can configure connections via environment variables or local configuration depending on your preferences (db connection strings are not stored in the repo).

---

## Web Development (Next.js/TS/Tailwind/shadcn)

- LSP: tsserver, tailwindcss, html, cssls, jsonls, yamlls
- Formatting: Prettierd/Prettier
- Debugging: Node.js (Launch Next.js dev)
- Terminals: <leader>td (pnpm dev); <leader>tc (docker compose)
- Tailwind: classRegex configured for typical patterns and tw`…` usage

Shadcn:
- The detector looks for components.json; completion, linting, and formatting just work with tsserver + Prettier.

---

## Python & AI/ML (Jupyter/Quarto)

- LSP: pyright
- Jupyter toolchain:
  - magma-nvim — Inline cell evaluation and outputs
    - :MagmaInit, :MagmaEvaluateLine, :MagmaEvaluateVisual
    - Keymaps provided: <leader>mi, <leader>ml, <leader>mv, <leader>mc, <leader>md
  - jupytext.nvim — Transparent pairing between .ipynb and .md/.py
  - quarto-nvim — Literate programming docs/reports with Python code chunks
- Terminal: <leader>tp (pixi shell) for environment-managed workflows

Audio/ML libs:
- The config doesn’t enforce an environment manager; you can use Pixi/Conda/venv as preferred. Ensure pynvim installed in the runtime environment.

---

## C++ Development

- LSP: clangd with beefed-up flags (completion-style=detailed, clang-tidy, placeholders, cross-file rename)
- File associations: .h treated as C++ header by default
- Build: cmake-tools with “build” (or UE5’s Intermediate) directory; compile_commands soft-linking
- DAP: LLDB (launch executable, attach to process)
- GUI helper: Launch arbitrary C++ executables with permissions ensured (chmod +x) using the GUI helper module

Recommended pattern:
- Use cmake presets or generate build directory via <leader>cg
- Build via <leader>cb, run via <leader>cr, debug via <leader>cd
- Use dap for breakpoints and stepping

---

## Unreal Engine 5.6.1

Detection:
- Any *.uproject at repo root marks a UE5 project
- Engine path detection checks common macOS/Linux/Windows paths; tune in lua/core/project_detection.lua

Helpers (keymaps):
- <leader>ule — Launch Unreal Editor for the project
- <leader>ubd — Build project (Development)
- <leader>upm — Package project for Mac (Shipping example)

clangd for UE5:
- Adds UE5 include paths and preprocessor defines (WITH_EDITOR=1, UE_BUILD_DEVELOPMENT=1, and platform define)
- Uses project root compile_commands.json when present; encourages generating compile_commands for improved indexing

Snippets for UE5 (C++): uclass, ustruct, uenum, uprop, ufunc.

---

## Docker & DevOps

- LSP: dockerls and docker-compose language service
- Terminals: <leader>tc to run docker compose up (floating terminal)
- YAML/JSON schemas provided by schemastore (K8s or other infra YAMLs benefit from rich validation)

---

## Project Detection & Environments

Flags (vim.g.unified_project):
- Web: has_package_json, is_nextjs, has_ts, has_tailwind, has_shadcn
- Managers: has_pnpm, has_npm, has_pixi, has_pip, has_brew
- Backend/DB: has_prisma, has_sql, has_redis, has_convex
- Containers: has_docker, has_docker_compose
- Python/ML: has_notebooks, has_ml
- C++/Build: has_cmake, has_make, has_compile_commands
- UE5: is_ue5

These influence LSP and terminal presets. If you need custom behavior per project, extend lua/core/project_detection.lua or add a per-project .nvimrc (local vim options) with modeline safeguards.

---

## Performance Tips & Large Codebases

- Large files (>1MB) automatically disable heavy features (syntax, swap, undo) for speed
- Reduce indexing pressure by excluding massive folders (node_modules, .git, build, dist, .next) — already set in Telescope/Neo-tree
- Adjust diagnostics/virtual text if needed via vim.diagnostic.config in lsp.lua
- Consider CMake’s compile_commands.json for accurate clangd indexing (UE5 project files or cmake-tools preset)

---

## Extending the Configuration

- Add a new plugin file to lua/plugins/your_module.lua and then require it inside lua/plugins/init.lua
- For language-specific tweaks, extend lsp.lua with per-server settings
- For project workflows, add Overseer templates or more toggleterm presets
- For custom snippets, expand lua/plugins/project_templates.lua or add VSCode-style snippets via friendly-snippets format

---

## Appendix: Command Cheatsheet

- :Lazy — Manage plugins
- :Mason — Manage LSPs/formatters/debuggers
- :CheckHealth — Verify environment
- :CMakeGenerate / :CMakeBuild / :CMakeRun / :CMakeDebug
- :OverseerOpen / :OverseerRun
- :MagmaInit / :MagmaEvaluateLine / :MagmaEvaluateVisual
- :DBUI / :DBUIToggle

Happy hacking — ship confidently across web, ML, C++, and UE5.
