-- ============================================================================
-- Global Keymaps (Unified)
-- ============================================================================

local map = vim.keymap.set

-- Basic window nav
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Save/Quit
map("n", "<leader>w", ":w<CR>", { desc = "Write" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>xx", vim.diagnostic.open_float, { desc = "Diagnostics float" })

-- which-key groups are registered via plugins/ui.lua opts.spec to avoid early-load issues

