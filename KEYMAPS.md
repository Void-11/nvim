# KEYMAPS — Quick Reference

Leader is Space. Modes: [n] normal, [v] visual, [x] visual/select, [i] insert, [o] operator-pending.
Some mappings are buffer-local (e.g., LSP) and only active when the feature is available.

- Basics
  - [n] Window navigation: <C-h> / <C-j> / <C-k> / <C-l>
  - [n] Save / Quit: <leader>w / <leader>q
  - [n] Diagnostics (Trouble):
    - <leader>xx — Diagnostics list toggle
    - <leader>xq — Quickfix list toggle
    - <leader>xr — References list toggle
  - [n] Diagnostics navigation: [d (previous) / ]d (next)

- Explorer & Fuzzy Find (Neo-tree + Telescope)
  - [n] <leader>e — Toggle file explorer (Neo-tree)
  - [n] <leader>ff — Find files
  - [n] <leader>fg — Live grep
  - [n] <leader>fb — Buffers
  - [n] <leader>fh — Help tags
  - [n] <leader>fs — LSP document symbols
  - [n] <leader>fw — LSP workspace symbols
  - [n] <leader>fp — Projects (project.nvim + telescope)

- LSP (buffer-local)
  - [n] gd — Go to definition (Telescope)
  - [n] gr — References (Telescope)
  - [n] gI — Implementations (Telescope)
  - [n] gD — Go to declaration
  - [n] K — Hover
  - [n] <leader>rn — Rename symbol
  - [n/v] <leader>ca — Code action
  - [n] <leader>D — Type definition (Telescope)
  - [n] <leader>ds — Document symbols
  - [n] <leader>ws — Workspace symbols

- Completion & Snippets (nvim-cmp + LuaSnip)
  - [i] <C-n>/<C-p> — Next/previous item
  - [i] <C-y> — Confirm
  - [i] <C-Space> — Trigger completion menu
  - [i] <C-b>/<C-f> — Scroll documentation
  - [i/s] <C-l> — LuaSnip expand / jump forward
  - [i/s] <C-h> — LuaSnip jump backward

- Formatting (conform.nvim)
  - [n/v] <leader>F — Format buffer/selection
  - Command: :PythonFormatUseRuff — prefer Ruff for Python formatting (ruff_fix + ruff_format)

- Debugging (nvim-dap + dap-ui)
  - [n] <F5> / <F10> / <F11> / <F12> — Continue / Step Over / Step Into / Step Out
  - [n] <leader>b — Toggle breakpoint
  - [n] <leader>B — Conditional breakpoint (prompts)
  - [n] <leader>du — Toggle DAP UI
  - [n] <leader>dm — Windows: run first MSVC cppvsdbg launch config

- Terminals (toggleterm)
  - [n] <C-\> — Toggle floating terminal
  - [n] <leader>tf — Floating terminal
  - [n] <leader>th — Horizontal terminal
  - [n] <leader>tv — Vertical terminal
  - Project presets:
    - [n] <leader>td — pnpm dev
    - [n] <leader>tp — Pixi shell
    - [n] <leader>tc — docker compose up
    - [n] <leader>tx — npx convex dev

- Build & Tasks
  - CMake (cmake-tools):
    - [n] <leader>cg / cb / cr / cd / cc / ct / cs / cT — Generate / Build / Run / Debug / Clean / Test / BuildType / Target
  - Overseer (task runner):
    - [n] <leader>oo — Open tasks list
    - [n] <leader>ot — Toggle tasks list
    - [n] <leader>or — Run task

- Git (gitsigns + fugitive)
  - [n] ]c / [c — Next / previous hunk
  - [n] <leader>hs — Stage hunk
  - [n] <leader>hr — Reset hunk
  - [n] <leader>hp — Preview hunk
  - [n] <leader>hb — Blame line (full)
  - Command: :Git — full git interface (fugitive)

- Search & Refactor Utilities
  - Spectre: [n] <leader>sr — Project-wide find/replace UI
  - Trouble: see Diagnostics above

- Motions & Outline
  - Flash (fast motions):
    - [n/x/o] s — Jump
    - [n/x/o] S — Treesitter jump
    - [o] r — Remote jump
    - [o/x] R — Treesitter search
  - Aerial (symbols outline):
    - [n] <leader>sa — Toggle outline panel

- Databases (vim-dadbod)
  - [n] <leader>dbu — Open DB UI
  - [n] <leader>dbc — Toggle DB UI

- Jupyter / Data Science
  - Magma (inline cells):
    - [n] <leader>mi — Init
    - [n] <leader>mr — Evaluate operator
    - [n] <leader>ml — Evaluate line
    - [x] <leader>mv — Evaluate visual
    - [n] <leader>mc — Re-evaluate cell
    - [n] <leader>md — Delete cell

- Testing (neotest)
  - [n] <leader>tt — Run nearest test
  - [n] <leader>tT — Run current file
  - [n] <leader>to — Open output (enter)
  - [n] <leader>ts — Toggle summary

- UE5 Helpers (active when a *.uproject is detected)
  - [n] <leader>ule — Launch Unreal Editor
  - [n] <leader>ubd — Build Development
  - [n] <leader>upm — Package (example target)

- GUI helpers
  - [n] <leader>gk — Kill all running background processes launched from Neovim

Tip: which-key shows all available mappings incrementally as you press <leader>. Some groups (f, g, l, d, t, c, u, p, o, db) are pre-registered for discoverability.
