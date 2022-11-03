local class = require('legendary.api.middleclass')
local util = require('legendary.util')

---@class ModeKeymapOpts
---@field implementation string|function
---@field opts table|nil

---@class ModeKeymap
---@field n ModeKeymapOpts
---@field v ModeKeymapOpts
---@field x ModeKeymapOpts
---@field c ModeKeymapOpts
---@field s ModeKeymapOpts
---@field t ModeKeymapOpts
---@field i ModeKeymapOpts

---@class Keymap
---@field keys string
---@field mode_mappings ModeKeymap
---@field description string
---@field opts table
---@field class Keymap
local Keymap = class('Keymap')

---Parse a new keymap table
---@param tbl table
---@return Keymap
function Keymap:parse(tbl) -- luacheck: no unused
  vim.validate({
    ['1'] = { tbl[1], { 'string' } },
    ['2'] = { tbl[2], { 'string', 'function', 'table' }, true },
    mode = { tbl.mode, { 'string', 'table' }, true },
    opts = { tbl.opts, { 'table' }, true },
    description = { util.get_desc(tbl), { 'string' }, true },
  })

  if type(tbl[2]) == 'table' then
    vim.validate({
      n = { tbl[2].n, { 'string', 'function', 'table' }, true },
      v = { tbl[2].v, { 'string', 'function', 'table' }, true },
      x = { tbl[2].x, { 'string', 'function', 'table' }, true },
      c = { tbl[2].c, { 'string', 'function', 'table' }, true },
      s = { tbl[2].s, { 'string', 'function', 'table' }, true },
      t = { tbl[2].t, { 'string', 'function', 'table' }, true },
      i = { tbl[2].i, { 'string', 'function', 'table' }, true },
    })
  end

  local instance = Keymap()

  instance.keys = tbl[1]
  instance.description = util.get_desc(tbl)
  instance.opts = tbl.opts or {}

  instance.mode_mappings = {}
  if tbl[2] == nil then
    return instance
  end

  if type(tbl[2]) == 'table' then
    for mode, mapping in pairs(tbl[2]) do
      if type(mapping) == 'table' then
        instance.mode_mappings[mode] = { implementation = mapping[1], opts = mapping.opts }
      else
        instance.mode_mappings[mode] = { implementation = mapping }
      end
    end
  else
    if type(tbl.mode) == 'table' then
      for _, mode in ipairs(tbl.mode) do
        instance.mode_mappings[mode] = { implementation = tbl[2] }
      end
    else
      instance.mode_mappings[tbl.mode or 'n'] = { implementation = tbl[2] }
    end
  end

  return instance
end

---Bind the keymap in Neovim
---@return Keymap
function Keymap:apply()
  for mode, mapping in pairs(self.mode_mappings) do
    local opts = vim.tbl_deep_extend('keep', mapping.opts or {}, self.opts or {})
    opts.desc = opts.desc or self.description
    vim.keymap.set(mode, self.keys, mapping.implementation, opts)
  end

  return self
end

function Keymap:id()
  return string.format('%s %s %s', self.keys, self:modes(), self.description)
end

function Keymap:modes()
  local modes = {}
  for mode, mapping in pairs(self.mode_mappings) do
    if mapping then
      table.insert(modes, mode)
    end
  end

  if #modes == 0 then
    return { 'n' }
  end

  return modes
end

return Keymap