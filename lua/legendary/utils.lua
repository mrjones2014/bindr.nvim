local M = {}

--- Check if opts lists contain the same opts.
---@param item1 LegendaryItem
---@param item2 LegendaryItem
---@return boolean
function M.tbl_deep_eq(item1, item2)
  local tbl1 = item1 or {}
  local tbl2 = item2 or {}
  return vim.inspect(tbl1) == vim.inspect(tbl2)
end

--- Join two list-like tables together
---@param tbl1 any[]
---@param tbl2 any[]
---@return any[]
function M.concat_lists(tbl1, tbl2)
  local result = vim.deepcopy(tbl1)
  vim.tbl_map(function(item)
    result[#result + 1] = item
  end, tbl2)
  return result
end

--- Check if a list-like table of items already contains an item
---@param items LegendaryItem[]
---@param new_item LegendaryItem
---@return boolean
function M.list_contains(items, new_item)
  for _, item in pairs(items) do
    if
      item[1] == new_item[1]
      and item[2] == new_item[2]
      and (item.mode or 'n') == (new_item.mode or 'n')
      and item.description == new_item.description
      and M.tbl_deep_eq(item.opts, new_item.opts)
    then
      return true
    end
  end

  return false
end

function M.setup_lazy_load(item, group)
  local types = require('legendary.types')
  types.LegendaryItem.validate(item)
  types.LegendaryLazy.validate(item.lazy)
  require('legendary').bind_autocmds({
    item.lazy.event,
    function()
      item.lazy = nil
      if vim.startswith(item.kind, 'legendary.keymap') then
        require('legendary').bind_keymap(item)
      elseif vim.startswith(item.kind, 'legendary.command') then
        require('legendary').bind_command(item)
      elseif vim.startswith(item.kind, 'legendary.autocmd') then
        require('legendary').bind_autocmd(item, group)
      end
    end,
    opts = {
      pattern = item.lazy.pattern,
      once = true,
    },
  })
end

--- Check if given item is a user-defined keymap
---@param keymap any
---@return boolean
function M.is_user_keymap(keymap)
  return not not (
      keymap ~= nil
      and type(keymap) == 'table'
      and type(keymap[1]) == 'string'
      and (type(keymap[2]) == 'string' or type(keymap[2]) == 'function')
    )
end

--- Set the given keymap
---@param keymap LegendaryItem
function M.set_keymap(keymap)
  if not M.is_user_keymap(keymap) then
    return
  end

  -- if not a keymap the user wants us to bind, bail
  if type(keymap[2]) ~= 'string' and type(keymap[2]) ~= 'function' then
    return
  end

  local opts = vim.deepcopy(keymap.opts or {})
  -- set default options
  if opts.silent == nil then
    opts.silent = true
  end

  -- map description to neovim's internal `desc` field
  opts.desc = opts.desc or keymap.description

  if
    type(keymap[2]) == 'function'
    and (keymap.mode == 'v' or (type(keymap.mode) == 'table' and vim.tbl_contains(keymap.mode, 'v')))
  then
    local orig = keymap[2]
    keymap[2] = function(visual_selection)
      local current_mode = vim.fn.mode()
      if current_mode and current_mode:sub(1, 1):lower() == 'v' then
        -- ensure marks are set
        local marks = visual_selection or M.get_marks()
        M.set_marks(marks)
        orig(marks)
      else
        orig()
      end
    end
  end

  vim.keymap.set(keymap.mode or 'n', keymap[1], keymap[2], opts)
end

function M.get_marks()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cline, ccol = cursor[1], cursor[2]
  local vline, vcol = vim.fn.line('v'), vim.fn.col('v')
  return { cline, ccol, vline, vcol }
end

function M.set_marks(visual_selection)
  vim.fn.setpos("'<", { 0, visual_selection[1], visual_selection[2], 0 })
  vim.fn.setpos("'>", { 0, visual_selection[3], visual_selection[4], 0 })
end

--- Strip a leading `:` or `<cmd>` if there is one
---@param cmd_str string
---@return string
function M.strip_leading_cmd_char(cmd_str)
  if type(cmd_str) ~= 'string' then
    return cmd_str
  end

  if cmd_str:sub(1, 5):lower() == '<cmd>' then
    return cmd_str:sub(6)
  elseif cmd_str:sub(1, 1) == ':' then
    return cmd_str:sub(2)
  end

  return cmd_str
end

function M.strip_trailing_cr(cmd_str)
  local cmd = vim.deepcopy(cmd_str)
  if cmd:sub(#cmd - 3):lower() == '<cr>' then
    cmd = cmd:sub(1, #cmd - 4)
  elseif cmd:sub(#cmd - 1):lower() == '\r' then
    cmd = cmd:sub(1, #cmd - 2)
  end
  return cmd
end

function M.append_trailing_cr(cmd_str)
  local cmd = vim.deepcopy(cmd_str)
  if #cmd == #(M.strip_trailing_cr(cmd)) then
    cmd = string.format('%s<CR>', cmd)
  end
  return cmd
end

--- Check if given item is a user-defined command
---@param cmd any
---@return boolean
function M.is_user_command(cmd)
  return not not (
      cmd ~= nil
      and type(cmd) == 'table'
      and type(cmd[1]) == 'string'
      and (type(cmd[2]) == 'string' or type(cmd[2]) == 'function')
    )
end

--- Set up the given command
---@param cmd LegendaryItem
function M.set_command(cmd)
  if not M.is_user_command(cmd) then
    return
  end

  local opts = vim.deepcopy(cmd.opts or {})
  opts.desc = opts.desc or cmd.description

  if opts.buffer ~= nil then
    local buffer = opts.buffer
    opts.buffer = nil
    vim.api.nvim_buf_add_user_command(buffer, M.strip_leading_cmd_char(cmd[1]), cmd[2], opts)
  else
    vim.api.nvim_add_user_command(M.strip_leading_cmd_char(cmd[1]), cmd[2], opts)
  end
end

--- Check if the given item is a user autocmd
---@param autocmd any
---@return boolean
function M.is_user_autocmd(autocmd)
  local first_el_is_autocmd_event = type(autocmd) == 'table'
    and type(autocmd[1]) == 'string'
    and #autocmd[1] == #M.strip_leading_cmd_char(autocmd[1])

  return not not (
      autocmd ~= nil
      and type(autocmd) == 'table'
      and (first_el_is_autocmd_event or type(autocmd[1]) == 'table')
      and (type(autocmd[2]) == 'string' or type(autocmd[2]) == 'function')
    )
end

--- Set an autocmd
---@param autocmd LegendaryItem the autocmd definition to set
---@param group string override autocmd.opts.group with this value
function M.set_autocmd(autocmd, group)
  if not M.is_user_autocmd(autocmd) then
    return
  end

  local opts = vim.deepcopy(autocmd.opts or {})
  if type(autocmd[2]) == 'function' then
    opts.callback = autocmd[2]
  else
    opts.command = autocmd[2]
  end

  if opts.description then
    opts.desc = opts.description
    opts.description = nil
  end

  opts.group = group or opts.group
  vim.api.nvim_create_autocmd(autocmd[1], opts)
end

--- Check if the given item is an augroup
---@param augroup any
---@return boolean
function M.is_user_augroup(augroup)
  return not not (type(augroup) == 'table' and augroup.name and #augroup > 0 and M.is_user_autocmd(augroup[1]))
end

--- Get the implementation of an item
---@param item LegendaryItem
---@return string | function
function M.get_definition(item)
  if M.is_user_keymap(item) or M.is_user_autocmd(item) then
    return item[2]
  end

  return item[1]
end

--- Helper function to send <ESC> properly
function M.send_escape_key()
  vim.api.nvim_feedkeys(vim.api.nvim_eval('"\\<esc>"'), 'n', true)
end

function M.notify(msg, level, title)
  level = level or vim.log.levels.ERROR
  title = title or 'legendary.nvim'
  vim.notify(msg, level, { title = title })
end

return M
