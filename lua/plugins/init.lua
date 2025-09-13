-- Aggregate plugin specs from modules
local specs = {}

local function extend(mod)
  local ok, mod_specs = pcall(require, mod)
  if ok then
    local is_list = vim.islist or vim.tbl_islist
    if is_list(mod_specs) then
      vim.list_extend(specs, mod_specs)
    else
      table.insert(specs, mod_specs)
    end
  else
    vim.schedule(function()
      vim.notify("Failed loading plugin module: " .. mod, vim.log.levels.WARN)
    end)
  end
end

extend("plugins.ui")
extend("plugins.telescope")
extend("plugins.neo_tree")
extend("plugins.git")
extend("plugins.treesitter")
extend("plugins.tools")
extend("plugins.lsp")
extend("plugins.cmp")
extend("plugins.conform")
extend("plugins.dap")
extend("plugins.terminal")
extend("plugins.cmake")
extend("plugins.overseer")
extend("plugins.ue5")
extend("plugins.gui")
extend("plugins.jupyter")
extend("plugins.databases")
extend("plugins.project_templates")
extend("plugins.project_nvim")

return specs

