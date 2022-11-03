local Toolbox = require('legendary-v2.toolbox')

local M = {}

local function exec_feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 't', true)
end

---@class Context
---@field buf integer
---@field mode string
---@field cursor_pos integer[] { row, col }
---@field marks integer[]|nil

---Build a Context containing information about the editor
---state *before* triggering the finder so that it can be
---restored before executing the item.
---@return table
function M.build_pre_context()
  return {
    buf = vim.api.nvim_get_current_buf(),
    mode = vim.fn.mode(),
    cursor_pos = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win()),
    marks = Toolbox.get_marks(),
  }
end

---Restore editor state based on context
---@param context Context
function M.restore_context(context, callback)
  Toolbox.set_marks(context.marks)
  if vim.startswith(context.mode, 'n') then
    vim.cmd('stopinsert')
  elseif Toolbox.is_visual_mode(context.mode) then
    vim.cmd('normal! gv')
  elseif vim.startswith(context.mode, 'i') then
    vim.cmd('startinsert')
  else
    vim.notify('Sorry, only normal, insert, and visual mode executions are supported by legendary.nvim.')
    return
  end

  -- For some reason diagnostics says
  --this signature is wrong but it isn't
  ---@diagnostic disable
  vim.defer_fn(function()
    callback()
  end, 1)
  ---@diagnostic enable
end

---Execute an item
---@param item LegendaryItem
---@param context Context
function M.exec_item(item, context)
  vim.schedule(function()
    M.restore_context(context, function()
      if Toolbox.is_function(item) then
        item.implementation()
      elseif Toolbox.is_command(item) then
        local cmd = item:vim_cmd()
        if item.unfinished == true then
          exec_feedkeys(string.format(':%s', cmd))
        else
          vim.cmd(cmd)
        end
      elseif Toolbox.is_keymap(item) then
        exec_feedkeys(item.keys)
      elseif Toolbox.is_autocmd(item) then
        local impl = item.implementation
        if type(impl) == 'function' then
          impl()
        else
          exec_feedkeys(impl)
        end
      end
    end)
  end)
end

return M
