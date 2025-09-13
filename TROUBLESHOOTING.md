# TROUBLESHOOTING — Unified IDE

Use this guide when something doesn’t work as expected. Start with:
- :checkhealth — verify core environment
- :Lazy — check plugin status; :Lazy log for errors
- :Mason — install/update LSPs/formatters/debuggers; :MasonUpdate to refresh indices

If a keymap doesn’t respond, confirm the plugin providing it is loaded (VeryLazy events can delay loading) and that you pressed Space as <leader>.

---

## Windows: Compilers and MSVC Environment

Symptoms:
- Treesitter parser compile fails; `cl` not found
- C/C++ builds fail from inside Neovim

Fix:
- Install Visual Studio Build Tools with the C++ workload.
- The config auto-imports the Visual Studio Developer environment (VsDevCmd.bat) at startup (see lua/core/msvc_env.lua). If VsDevCmd isn’t found, install VS Build Tools or adjust the fallback path in that file.
- Validate from Neovim terminal: run `cl /?` to confirm MSVC is available in PATH.

Notes:
- On Windows, Telescope’s fzf-native is built with CMake; ensure CMake is installed and on PATH.

---

## Treesitter Parser Build Issues

Symptoms:
- :checkhealth reports missing compilers or parser build failures

Fix:
- Ensure a working C/C++ toolchain:
  - Windows: MSVC (auto-imported). Alternatives: Zig/Clang/GCC if installed.
  - macOS/Linux: Clang or GCC
- Re-run parser install/update: `:TSUpdate`
- The config honors $CC; you can set it before launching Neovim if you need a specific compiler.

---

## Telescope fzf-native Fails To Build (Windows)

Symptoms:
- Telescope works, but fzf-native complains during build

Fix:
- Install CMake and ensure it’s on PATH
- Rebuild the extension with `:Lazy build telescope-fzf-native.nvim` or reinstall the plugin

---

## LSP Servers Don’t Start

Symptoms:
- No diagnostics/hover/rename; :LspInfo shows no attached clients

Fix:
- Open :Mason and ensure servers are installed (pyright, vtsls, tailwindcss, jsonls, yamlls, dockerls, bashls, lua_ls, sqlls, clangd, ruff)
- Restart Neovim after installations
- For JSON/YAML, schemas come from schemastore.nvim; ensure the plugin is installed (it is a dependency in lsp.lua)

---

## Formatting Doesn’t Run

Symptoms:
- <leader>F does nothing; on-save formatting not happening

Fix:
- Ensure formatters are installed via :Mason (stylua, prettierd/prettier, ruff)
- For JS/TS, vtsls LSP formatting is intentionally disabled to avoid conflicts; Prettierd/Prettier is used via conform.nvim
- For Python, this config prefers Ruff (ruff_fix + ruff_format). You can reassert preference at any time: `:PythonFormatUseRuff`

---

## Node/Next.js Debugging Doesn’t Work

Symptoms:
- Breakpoints not hit when running the Next.js dev config

Fix:
- Ensure `js-debug-adapter` is installed in :Mason
- Ensure Node.js LTS is installed and `node` is on PATH
- Verify `node_modules/.bin/next` exists and `pnpm dev` (or your dev script) starts the app in the workspace folder
- Try the debug config again: `Telescope` > DAP configurations, or start from the preconfigured DAP menu

---

## C/C++ Debugging on Windows (cppvsdbg)

Symptoms:
- No C++ debug adapter available

Fix:
- Ensure `cpptools` is installed in :Mason; the config sets the adapter to OpenDebugAD7.exe and adds a convenient launch entry
- Use `<leader>dm` to run the first cppvsdbg configuration quickly

---

## clangd Indexing / Wrong Includes

Symptoms:
- Missing symbols, incorrect diagnostics, slow cross-file navigation

Fix:
- Generate `compile_commands.json` (preferred):
  - CMake: `cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=1` then build
  - Enable the CMake preset and use the keymaps: `<leader>cg` (generate), `<leader>cb` (build)
- UE5 projects: engine include paths and defines are added automatically when a `*.uproject` is detected; still, having a `compile_commands.json` in the project root improves accuracy

---

## UE5 Engine Path Not Detected

Symptoms:
- UE5 helpers not available; clangd not UE5-aware

Fix:
- Edit `lua/core/project_detection.lua` and adjust the `possible_paths` list to match your engine install path
- Ensure the project root contains a `*.uproject`

---

## Python Provider / Jupyter / Magma Issues

Symptoms:
- `:MagmaInit` fails, or Jupyter integration doesn’t work

Fix:
- Ensure Python provider is installed: `python -m pip install --user pynvim`
- For Jupyter tooling: `pip install jupyter jupytext`
- Magma is a remote plugin; if it fails after plugin updates, run `:UpdateRemotePlugins`

---

## Database UI (vim-dadbod) Doesn’t Show Connections

Symptoms:
- Empty DB UI or connection errors

Fix:
- Configure your DB connections via environment variables or add connections from `:DBUI`
- Security note: connection strings are not stored in the repo

---

## Terminals Don’t Open / Wrong Shell on Windows

Symptoms:
- ToggleTerm fails to open or behaves unexpectedly on Windows

Fix:
- This config defaults Neovim’s shell to PowerShell with sane flags (see `lua/core/options.lua`)
- If you prefer `pwsh`, set your shell accordingly in your environment or update the options to point at `pwsh`

---

## General Checklist

- Verify prerequisites are installed (Git, Node, Python, CMake, ripgrep, fd)
- Open `:Lazy` and ensure no plugin errors
- Open `:Mason` and ensure all servers/formatters/adapters you need are installed
- Run `:checkhealth` for system diagnostics
- For Windows C++/Treesitter issues, confirm `cl` is available (`cl /?`)

If problems persist, capture logs from `:Lazy log` and list your OS, Neovim version, and a minimal reproduction if possible.
