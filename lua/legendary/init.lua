---@mod legendary

local Config = require('legendary.config')
local State = require('legendary.data.state')
local Ui = require('legendary.ui')
local Keymap = require('legendary.data.keymap')
local Command = require('legendary.data.command')
local Augroup = require('legendary.data.augroup')
local Autocmd = require('legendary.data.autocmd')
local Function = require('legendary.data.function')
local LegendaryWhichKey = require('legendary.integrations.which-key')
local Deprecate = require('legendary.deprecate')

---@param parser LegendaryItem
---@return fun(items:table[])
local function build_parser_func(parser)
  return function(items)
    if not vim.tbl_islist(items) then
      error(string.format('Expected list, got ', type(items)))
      return
    end

    State.items:add(vim.tbl_map(function(item)
      return parser:parse(item):apply()
    end, items))
  end
end

local M = {}

function M.setup(cfg)
  Config.setup(cfg)

  if Config.which_key.auto_register then
    LegendaryWhichKey.whichkey_listen()
  end

  if #Config.which_key.mappings > 0 then
    LegendaryWhichKey.bind_whichkey(Config.which_key.mappings, Config.which_key.opts, Config.which_key.do_binding)
  end

  M.keymaps(Config.keymaps)
  M.commands(Config.commands)
  M.funcs(Config.functions)
  M.autocmds(Config.autocmds)

  -- apply items
  vim.tbl_map(function(item)
    item:apply()
  end, State.items.items)

  -- Add builtins after apply since they don't need applied
  if Config.include_builtin then
    -- inline require to avoid the cost of importing
    -- this somewhat large data file if not needed
    local Builtins = require('legendary.data.builtins')

    State.items:add(vim.tbl_map(function(keymap)
      return Keymap:parse(keymap)
    end, Builtins.builtin_keymaps))

    State.items:add(vim.tbl_map(function(command)
      return Command:parse(command)
    end, Builtins.builtin_commands))
  end

  if Config.include_legendary_cmds then
    State.items:add(require('legendary.api.cmds').cmds)
  end
end

---Find items using vim.ui.select()
---@param opts LegendaryFindOpts
---@overload fun()
function M.find(opts)
  Ui.select(opts)
end

---@diagnostic disable: undefined-doc-param
-- disable undefined-doc-param since we're dynamically generating these functions
-- but I still want them to be annotated

---Bind a *list of keymaps*
---@param keymaps table[]
M.keymaps = build_parser_func(Keymap)

---Bind a *single keymap*
---@param keymap table
function M.keymap(keymap)
  M.keymaps({ keymap })
end

---Bind a *list of commands*
---@param commands table[]
M.commands = build_parser_func(Command)

---Bind a *single command*
---@param command table
function M.command(command)
  M.commands({ command })
end

---Bind a *list of functions*
---@param functions table[]
M.funcs = build_parser_func(Function)

---Bind a *single function*
---@param function table
function M.func(func)
  M.funcs({ func })
end

---@diagnostic enable: undefined-doc-param

---Bind a *list of* autocmds and/or augroups
---@param aus (Autocmd|Augroup)[]
function M.autocmds(aus)
  if not vim.tbl_islist(aus) then
    vim.notify(string.format('Expected list, got %s.\n    %s', type(aus), vim.inspect(aus)))
    return
  end

  for _, augroup_or_autocmd in ipairs(aus) do
    if type(augroup_or_autocmd.name) == 'string' and #augroup_or_autocmd.name > 0 then
      local autocmds = Augroup:parse(augroup_or_autocmd --[[@as Augroup]]):apply().autocmds
      State.items:add(autocmds)
    else
      -- Only add Autocmds to the list since Augroups can't be executed
      State.items:add({ Autocmd:parse(augroup_or_autocmd):apply() })
    end
  end
end

---Bind a *single autocmd/augroup*
---@param au Autocmd|Augroup
function M.autocmd(au)
  M.autocmds({ au })
end

-- TODO remove deprecated methods

---@deprecated
function M.bind_keymap(keymap)
  Deprecate.write(
    { "require('legendary').bind_keymap()", 'WarningMsg' },
    'has been replaced by',
    { "require('legendary').keymap()", 'WarningMsg' }
  ).flush_if_vimenter()
  M.keymap(keymap)
end

---@deprecated
function M.bind_keymaps(keymaps)
  Deprecate.write(
    { "require('legendary').bind_keymaps()", 'WarningMsg' },
    'has been replaced by',
    { "require('legendary').keymaps()", 'WarningMsg' }
  ).flush_if_vimenter()
  M.keymaps(keymaps)
end

---@deprecated
function M.bind_command(command)
  Deprecate.write(
    { "require('legendary').bind_command()", 'WarningMsg' },
    'has been replaced by',
    { "require('legendary').command()", 'WarningMsg' }
  ).flush_if_vimenter()
  M.command(command)
end

---@deprecated
function M.bind_commands(commands)
  Deprecate.write(
    { "require('legendary').bind_commands()", 'WarningMsg' },
    'has been replaced by',
    { "require('legendary').commands()", 'WarningMsg' }
  ).flush_if_vimenter()
  M.commands(commands)
end

---@deprecated
function M.bind_function(func)
  Deprecate.write(
    { "require('legendary').bind_function()", 'WarningMsg' },
    'has been replaced by',
    { "require('legendary').func()", 'WarningMsg' }
  ).flush_if_vimenter()
  M.func(func)
end

---@deprecated
function M.bind_functions(funcs)
  Deprecate.write(
    { "require('legendary').bind_functions()", 'WarningMsg' },
    'has been replaced by',
    { "require('legendary').funcs()", 'WarningMsg' }
  ).flush_if_vimenter()
  M.funcs(funcs)
end

---@deprecated
function M.bind_autocmds(funcs)
  Deprecate.write(
    { "require('legendary').bind_functions()", 'WarningMsg' },
    'has been replaced by',
    { "require('legendary').funcs()", 'WarningMsg' }
  ).flush_if_vimenter()
  M.autocmds(funcs)
end

---@deprecated
function M.bind_whichkey(wk_tbls, wk_opts, do_binding)
  Deprecate.write(
    { "require('legendary').bind_whichkey()", 'WarningMsg' },
    'has been replaced by',
    { "require('legendary.integrations.which-key').bind_whichkey()", 'WarningMsg' }
  ).flush_if_vimenter()
  LegendaryWhichKey.bind_whichkey(wk_tbls, wk_opts, do_binding)
end

---@deprecated
function M.parse_whichkey(wk_tbls, wk_opts, do_binding)
  Deprecate.write(
    { "require('legendary').parse_whichkey()", 'WarningMsg' },
    'has been replaced by',
    { "require('legendary.integrations.which-key').parse_whichkey()", 'WarningMsg' }
  ).flush_if_vimenter()
  LegendaryWhichKey.parse_whichkey(wk_tbls, wk_opts, do_binding)
end

---@deprecated
function M.whichkey_listen()
  Deprecate.write(
    { "require('legendary').whichkey_listen()", 'WarningMsg' },
    'has been replaced by',
    { "require('legendary.integrations.which-key').whichkey_listen()", 'WarningMsg' }
  ).write_if_vimenter()
  LegendaryWhichKey.whichkey_listen()
end

return M
