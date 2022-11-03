local Toolbox = require('legendary-v2.toolbox')

local M = {}

--- Return a `LegendaryItemFilter` that filters items
--- by the specified mode
---@param mode string
---@return ItemFilter
function M.mode(mode)
  return function(item)
    -- include everything that isn't a keymap since they aren't tied to a mode
    if not Toolbox.is_keymap(item) then
      return true
    end

    local keymap = item
    local keymap_mode = keymap.mode or { 'n' }
    if type(keymap_mode) == 'string' then
      keymap_mode = { keymap_mode }
    end

    return vim.tbl_contains(keymap_mode, mode)
  end
end

--- Return a `LegendaryItemFilter` that filters items
--- by the current mode
---@return ItemFilter
function M.current_mode()
  return M.mode((vim.fn.mode() or 'n'))
end

---Filter to only show keymaps
---@return ItemFilter
function M.keymaps()
  return Toolbox.is_keymap
end

---Filter to only show commands
---@return ItemFilter
function M.commands()
  return Toolbox.is_command
end

---Filter to only show autocmds
---@return ItemFilter
function M.autocmds()
  return Toolbox.is_autocmd
end

---Filter to only show functions
---@return ItemFilter
function M.funcs()
  return Toolbox.is_function
end

return M
