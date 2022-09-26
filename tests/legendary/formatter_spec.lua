local assert = require('luassert')
local formatter = require('legendary.formatter')

describe('formatter', function()
  describe('format(item, mode, formatter)', function()
    it('formats properly with default formatter', function()
      -- ensure using default function
      require('legendary.config').formatter = nil
      local item = { '<leader>c', ':CommentToggle<CR>', description = 'Toggle comment', mode = { 'n', 'v' } }
      local padding = formatter.compute_padding({ item }, 'n')
      local formatted = formatter.format(item, 'n', padding)
      assert.are.same(formatted, 'n, v │ <leader>c │ Toggle comment')
    end)

    it('formats properly with custom formatter function', function()
      require('legendary.config').formatter = function(item)
        return {
          item[1],
          item[2],
          table.concat(item.mode, '│'),
        }
      end
      local item = { '<leader>c', ':CommentToggle<CR>', description = 'Toggle comment', mode = { 'n', 'v' } }
      local padding = formatter.compute_padding({ item }, 'n')
      local formatted = formatter.format(item, 'n', padding)
      assert.are.same(formatted, '<leader>c │ :CommentToggle<CR> │ n│v')
    end)

    it('formats properly with a different number of columns', function()
      require('legendary.config').formatter = function(item)
        return {
          item[1],
          item[2],
          table.concat(item.mode, '│'),
          item.description,
        }
      end
      local item = { '<leader>c', ':CommentToggle<CR>', description = 'Toggle comment', mode = { 'n', 'v' } }
      local padding = formatter.compute_padding({ item }, 'n')
      local formatted = formatter.format(item, 'n', padding)
      assert.are.same(formatted, '<leader>c │ :CommentToggle<CR> │ n│v │ Toggle comment')
    end)

    it('uses one-shot formatter when provided', function()
      -- ensure using default function
      require('legendary.config').formatter = nil
      local item = { '<leader>c', ':CommentToggle<CR>', description = 'Toggle comment', mode = { 'n', 'v', 'x' } }
      local oneshot_formatter = function(item_to_format, mode)
        return { item_to_format[1], item_to_format[2], mode, 'this is a custom format' }
      end
      local padding = formatter.compute_padding({ item }, 'n')
      local formatted = formatter.format(item, 'n', padding, oneshot_formatter)
      assert.are.same(formatted, '<leader>c │ :CommentToggle<CR> │ n              │ this is a custom format')
    end)
  end)

  describe('lpad(str)', function()
    it(
      'padds all strings to have the same length based on the padding table, accounting for unicode characters',
      function()
        require('legendary.config').formatter = function(item)
          return {
            item[1],
            item[2],
            item.description,
          }
        end

        local items = {
          { '<leader>c', ':CommentToggle<CR>', description = 'Toggle comment' },
          { '<leader>s', ':wa<CR>', description = 'Write all buffers' },
          { 'gd', 'lua vim.lsp.buf.definition', description = 'Go to definition with LSP' },
          { '∆', ':echo "test"<CR>', description = 'Contains a triangle' },
          { '˚', ':lua print("test")<CR>', description = 'Contains a unicode dot' },
          { 'ݑ', ':e<CR>', description = 'Contains a unicode character' },
        }

        local padded = {}
        local padding = formatter.compute_padding(items, 'n')
        vim.tbl_map(function(item)
          table.insert(padded, {
            formatter.rpad(item[1], padding[1]),
            formatter.rpad(item[2], padding[2]),
            formatter.rpad(item[3], padding[3]),
          })
        end, items)

        for i, _ in pairs(padded) do
          if i < #padded then
            assert.are.same(vim.fn.strdisplaywidth(padded[i][1]), vim.fn.strdisplaywidth(padded[i + 1][1]))
            assert.are.same(vim.fn.strdisplaywidth(padded[i][2]), vim.fn.strdisplaywidth(padded[i + 1][2]))
            assert.are.same(vim.fn.strdisplaywidth(padded[i][3]), vim.fn.strdisplaywidth(padded[i + 1][3]))
          end
        end
      end
    )
  end)
end)
