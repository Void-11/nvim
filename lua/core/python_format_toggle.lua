local M = { mode = "ruff" }

-- Switch Python formatting between Ruff-only and Black+Isort at runtime.
-- Requires conform.nvim to be loaded.

local function set_python_formatters(list)
  local ok, conform = pcall(require, "conform")
  if not ok then
    vim.notify("conform.nvim not available", vim.log.levels.ERROR)
    return
  end
  conform.setup({
    formatters_by_ft = { python = list },
  })
end

function M.use_ruff()
  set_python_formatters({ "ruff_fix", "ruff_format" })
  M.mode = "ruff"
  vim.notify("Python formatting: Ruff (ruff_fix, ruff_format)", vim.log.levels.INFO)
end


return M
