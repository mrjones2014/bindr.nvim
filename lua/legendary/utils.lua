local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local pairs = _tl_compat and _tl_compat.pairs or pairs; local string = _tl_compat and _tl_compat.string or string; local table = _tl_compat and _tl_compat.table or table; require('legendary.types')
local M = {}

function M.notify(msg, level, title)
   level = level or vim.log.levels.ERROR
   title = title or 'legendary.nvim'
   vim.notify(msg, level, { title = title })
end



function M.get_marks()
   local cursor = vim.api.nvim_win_get_cursor(0)
   local cline, ccol = cursor[1], cursor[2]
   local vline, vcol = vim.fn.line('v'), vim.fn.col('v')
   return { cline, ccol, vline, vcol }
end






function M.resolve_description(item, fallback)
   if not item or type(item) ~= 'table' then
      return item
   end

   if (item).description and #((item).description) > 0 then
      return item
   end

   if (item).opts and ((item).opts).desc and #(((item).opts).desc) > 0 then
      (item).description = ((item).opts).desc
   end

   if #(((item).description or '')) == 0 then
      (item).description = fallback
   end

   return item
end




function M.has_per_mode_description(keymap)
   if not keymap then
      return false
   end

   if type(keymap[2]) ~= 'table' then
      return false
   end

   for _, impl in pairs(keymap[2]) do
      impl = M.resolve_description(impl)
      if #((((impl).description)) or '') > 0 then
         return true
      end
   end
   return false
end




function M.resolve_with_per_mode_description(keymap)
   if not keymap or type(keymap[2]) ~= 'table' or not M.has_per_mode_description(keymap) then
      return { keymap }
   end

   keymap = M.resolve_description(keymap)

   local resolved_tbls = {}
   for mode, impl in pairs(keymap[2]) do
      local resolved_keymap = { keymap[1], kind = 'legendary.keymap' }
      if type(impl) == 'table' then
         resolved_keymap.opts = vim.tbl_deep_extend(
         'keep',
         ((impl).opts or {}),
         keymap.opts or {})

         resolved_keymap.mode = mode
         resolved_keymap.description = (impl).description
      else
         resolved_keymap.mode = mode
         resolved_keymap.opts = keymap.opts
         resolved_keymap.description = keymap.description
      end

      local fallback_desc = keymap.description or ''
      if #fallback_desc == 0 then
         fallback_desc = (keymap.opts and keymap.opts.desc) or nil
      end
      resolved_keymap = M.resolve_description(resolved_keymap, fallback_desc)
      table.insert(resolved_tbls, resolved_keymap)
   end

   return resolved_tbls
end



function M.set_marks(visual_selection)
   vim.fn.setpos("'<", { 0, visual_selection[1], visual_selection[2], 0 })
   vim.fn.setpos("'>", { 0, visual_selection[3], visual_selection[4], 0 })
end





function M.tbl_deep_eq(item1, item2)
   local tbl1 = item1 or {}
   local tbl2 = item2 or {}
   return vim.inspect(tbl1) == vim.inspect(tbl2)
end





function M.list_contains(items, new_item)
   for _, item in ipairs(items) do
      if
(item)[1] == (new_item)[1] and
         (item)[2] == (new_item)[2] and
         ((item).mode or 'n') == ((new_item).mode or 'n') and
         (item).description == (new_item).description and
         M.tbl_deep_eq((item).opts, (new_item).opts) then

         return true
      end
   end

   return false
end




function M.is_user_keymap(keymap)
   return not not (
   keymap ~= nil and
   type(keymap) == 'table' and
   type(keymap[1]) == 'string' and
   (type(keymap[2]) == 'string' or type(keymap[2]) == 'function' or type(keymap[2]) == 'table'))

end




function M.is_visual_mode(mode_str)
   mode_str = mode_str or ''
   if mode_str == 'nov' or mode_str == 'noV' or mode_str == 'no' then
      return false
   end

   return not not (string.find(mode_str:lower(), 'v') or string.find(mode_str:lower(), '') or mode_str == 'x')
end




function M.has_visual_mode(item)
   if type(item.mode) == 'string' then
      return M.is_visual_mode(item.mode)
   end

   for _, mode in ipairs((item.mode) or {}) do
      if M.is_visual_mode(mode) then
         return true
      end
   end

   return false
end





function M.resolve_keymap(keymap)
   local resolved_keymaps = {}
   if type(keymap[2]) == 'table' then
      for mode, impl in pairs(keymap[2]) do
         local inner_map = { keymap[1], impl, mode = mode, opts = keymap.opts, description = keymap.description }
         if type(impl) == 'table' then

            local inner_opts = vim.tbl_deep_extend('keep', (impl).opts or {}, keymap.opts or {})


            if inner_opts.silent == nil then
               inner_opts.silent = true
            end


            inner_opts.desc = keymap.description

            inner_map[2] = (impl)[1]
            inner_map.opts = inner_opts
         else
            local inner_opts = vim.deepcopy(keymap.opts or {})

            if inner_opts.silent == nil then
               inner_opts.silent = true
            end

            inner_opts.desc = keymap.description
            inner_map.opts = inner_opts
         end
         table.insert(resolved_keymaps, { mode or 'n', inner_map[1], inner_map[2], inner_map.opts })
      end


      return resolved_keymaps
   end

   if type(keymap[2]) == 'function' and M.has_visual_mode(keymap) then
      local orig = keymap[2]
      keymap[2] = function(visual_selection)
         local current_mode = (vim.fn.mode() or '')
         if M.is_visual_mode(current_mode) then

            local marks = visual_selection or M.get_marks()
            M.set_marks(marks)
            orig(marks)
         else
            orig()
         end
      end
   end

   local opts = vim.deepcopy(keymap.opts or {})

   if opts.silent == nil then
      opts.silent = true
   end


   opts.desc = opts.desc or keymap.description

   table.insert(resolved_keymaps, { keymap.mode or 'n', keymap[1], keymap[2], opts })
   return resolved_keymaps
end



function M.set_keymap(keymap)
   if not M.is_user_keymap(keymap) then
      return
   end


   if type(keymap[2]) ~= 'string' and type(keymap[2]) ~= 'function' and type(keymap[2]) ~= 'table' then
      return
   end

   if not vim.keymap or not vim.keymap.set then
      M.notify('Sorry, binding keymaps with legendary.nvim requires Neovim 0.7.0 or higher!')
      return
   end

   for _, args_tbl in pairs(M.resolve_keymap(keymap)) do
      local args = args_tbl
      vim.keymap.set(args[1], args[2], args[3], args[4])
   end
end




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





function M.is_user_function(cmd)
   return not not (
   cmd ~= nil and
   type(cmd) == 'table' and
   type(cmd[1]) == 'function' and
   type(cmd.description) == 'string' and
   cmd.description ~= '')

end




function M.is_user_command(cmd)
   return not not (
   cmd ~= nil and
   type(cmd) == 'table' and
   type(cmd[1]) == 'string' and
   (type(cmd[2]) == 'string' or type(cmd[2]) == 'function'))

end



function M.set_command(cmd)
   if not M.is_user_command(cmd) then
      return
   end

   local opts = vim.deepcopy(cmd.opts or {})
   opts.desc = opts.desc or cmd.description

   if opts.buffer ~= nil then
      local buffer = opts.buffer
      opts.buffer = nil
      vim.api.nvim_buf_create_user_command(buffer, M.strip_leading_cmd_char(cmd[1]), cmd[2], opts)
   else
      vim.api.nvim_create_user_command(M.strip_leading_cmd_char(cmd[1]), cmd[2], opts)
   end
end




function M.is_user_autocmd(autocmd)
   local first_el_is_autocmd_event = type(autocmd[1]) == 'string' and
   #(autocmd[1]) == #M.strip_leading_cmd_char(autocmd[1])

   return not not (
   autocmd ~= nil and
   type(autocmd) == 'table' and
   (first_el_is_autocmd_event or type(autocmd[1]) == 'table') and
   (type(autocmd[2]) == 'string' or type(autocmd[2]) == 'function'))

end




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

   opts.group = group or opts.group
   vim.api.nvim_create_autocmd(autocmd[1], opts)
end




function M.is_user_augroup(augroup)
   return not not (augroup and augroup.name and #augroup > 0 and M.is_user_autocmd(augroup[1]))
end




function M.get_definition(item, mode)
   mode = mode or vim.fn.mode()
   if M.is_user_function(item) then
      return item[1]
   end

   if M.is_user_keymap(item) or M.is_user_autocmd(item) then
      local def = (item)[2]



      if type(def) == 'table' then
         def = ((item)[2])[mode]
         if def == nil and M.is_visual_mode(mode) then
            def = ((item)[2])['x']
         end



         if type(def) == 'table' then
            def = (def)[1]
         end
      end

      return def
   end

   return (item)[1]
end




function M.resolve_opts(item, mode)
   if not vim.startswith(item.kind, 'legendary.keymap') then
      return ((item).opts) or {}
   end

   local params = M.resolve_keymap(item)
   local keymap_params = (vim.tbl_filter(function(param_list)
      if type((param_list)[1]) == 'string' then
         return (param_list)[1] == mode or (param_list)[1] == 'x' and M.is_visual_mode(mode)
      else
         return vim.tbl_contains((param_list)[1], mode) or (vim.tbl_contains((param_list)[1], 'x') and M.is_visual_mode(mode))
      end
   end, params))[1]
   if keymap_params then
      local keymap_params_array = keymap_params
      return keymap_params_array[#keymap_params_array] or {}
   end

   return {}
end


function M.send_escape_key()
   vim.api.nvim_feedkeys(vim.api.nvim_eval('"\\<esc>"'), 'n', true)
end

return M
