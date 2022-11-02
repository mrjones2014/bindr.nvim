local assert = require('luassert')
local ItemList = require('legendary-v2.itemlist')
local Keymap = require('legendary-v2.types.keymap')
local Command = require('legendary-v2.types.command')
local util = require('legendary-v2.util')

describe('ItemList', function()
  describe('add', function()
    it('adds valid items', function()
      local keymap = Keymap:parse({ '<leader><leader>', function() end, description = 'test' })
      local list = ItemList:create()
      list:add({ keymap })
      assert.are.same(keymap, list.items[1])
    end)

    it('excludes items without descriptions', function()
      local keymap = Keymap:parse({ '<leader><leader>', function() end })
      local list = ItemList:create()
      list:add({ keymap })
      assert.are.same(#list.items, 0)
    end)

    it('excludes items already contained in the list', function()
      local keymap = Keymap:parse({ '<leader><leader>', function() end, description = 'test' })
      local list = ItemList:create()
      list:add({ keymap })
      assert.are.same(keymap, list.items[1])
      assert.are.same(#list.items, 1)
    end)
  end)

  describe('filter', function()
    it('filters items with a single filter', function()
      local keymap = Keymap:parse({ '<leader><leader>', function() end, description = 'test func' })
      local command = Command:parse({ ':MyCommand', function() end, description = 'test cmd' })
      local list = ItemList:create()
      list:add({ keymap, command })
      local filtered = list:filter(util.is_keymap)
      assert.are.same(#filtered, 1)
      assert.are.same(filtered[1], keymap)
    end)

    it('filters items with multiple filters', function()
      local keymap = Keymap:parse({ '<leader><leader>', function() end, description = 'test func' })
      local keymap2 = Keymap:parse({ '<leader><leader>', function() end, description = 'test func 2' })
      local command = Command:parse({ ':MyCommand', function() end, description = 'test cmd' })
      local list = ItemList:create()
      list:add({ keymap, keymap2, command })
      local filtered = list:filter({
        util.is_keymap,
        function(item)
          return item.description == keymap.description
        end,
      })
      assert.are.same(#filtered, 1)
      assert.are.same(filtered[1], keymap)
    end)
  end)
end)
