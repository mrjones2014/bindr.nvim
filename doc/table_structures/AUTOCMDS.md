# Augroups and Autocmds

`augroup` tables are very simple. They have a `name` property, and a `clear` property which defaults to `true`.
This will clear the `augroup` when creating it, equivalent to `au!`. `autocmd` tables nested within `augroup`
tables will automatically be defined in the `augroup`.

```lua
local augroups = {
  {
    name = 'MyAugroupName',
    clear = true,
    -- you autocmd tables here
  },
}
```

`autocmd` tables have an event or list of events, and a handler as the first two elements, respectively.
You can also specify options to be passed to the `autocmd` via the `opts` property. The `opts` property
defaults to `{ pattern = '*', group = nil }`.

```lua
local autocmds = {
  {
    'FileType',
    ':setlocal conceallevel=0',
    opts = {
      pattern = { 'json', 'jsonc' },
    },
  },
  {
    { 'BufRead', 'BufNewFile' },
    ':set filetype=jsonc',
    opts = {
      pattern = { '*.jsonc', 'tsconfig*.json' },
    },
  },
  {
    'BufWritePre',
    vim.lsp.buf.formatting_sync,
    -- include a description to execute it
    -- like a command on-demand from the finder
    description = 'Format on write with LSP',
  },
  {
    'BufWritePre',
    vim.lsp.buf.format_document,
    -- or, if you want to include a description
    description = 'Format on write with LSP',
    -- but still not have it in the finder,
    -- set
    hide = true,
  },
}
```

An example putting both together:

```lua
local augroups = {
  {
    name = 'LspOnAttachAutocmds',
    clear = true,
    {
      'BufWritePre',
      require('lsp.utils').format_document,
    },
    {
      'CursorHold',
      vim.diagnostic.open_float,
    },
  },
  {
    { 'BufRead', 'BufNewFile' },
    ':set filetype=jsonc',
    opts = {
      -- you can also manually add an autocmd
      -- to an existing augroup
      group = 'filetypedetect',
      pattern = { '*.jsonc', 'tsconfig*.json' },
    },
  },
}
```
