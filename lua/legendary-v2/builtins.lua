local M = {}
-- commented out ones need a way to get input after selecting
M.builtin_keymaps = {
  { '<C-o><C-o>', description = 'Reopen last opened file' },
  { 'gx', description = 'Open with external app' },
  { 'ZZ', description = 'Save and quit (window)' },
  { 'ZQ', description = 'Quit without saving' },
  { '<Esc>', description = 'Back to normal mode' },
  { '<C-c>', description = 'Cancel command/operation' },
  { 'i', description = 'Insert at cursor pos.' },
  { 'a', description = 'Append after cursor' },
  { 'I', description = 'Insert at start of line' },
  { 'A', description = 'Append at end of line' },
  { 'o', description = 'Open new line below' },
  { 'O', description = 'Open new line above' },
  -- { 'r{c}', description = 'Replace character with {c}' },
  { 'R', description = 'Replace mode/overwrite' },
  { 'c', description = 'Change' },
  { 'cc', description = 'Replace line' },
  { '.', description = 'Repeat last command' },
  { 'u', description = 'Undo' },
  { '<C-r>', description = 'Redo' },
  { 'g+', description = 'Next text state' },
  { 'g-', description = 'Prev text state' },
  { 'd', description = 'Cut' },
  -- { '"{r}d', description = 'Cut into register {r}' },
  { '"*d', description = 'Cut into OS clipboard' },
  -- { '{n}dd', description = 'Cut {n} lines' },
  { 'D', description = 'Cut until EOL' },
  -- { '{n}X', description = 'Cut {n} characters backwards' },
  { 'y', description = 'Copy' },
  -- { '"{r}y', description = 'Copy into register {r}' },
  { '"*y', description = 'Copy into OS clipboard' },
  { 'yy', description = 'Copy current line' },
  { 'y$', description = 'Copy until EOL' },
  { 'p', description = 'Paste after cursor' },
  { 'P', description = 'Paste before cursor' },
  -- { '"{r}p', description = 'Paste from register {r}' },
  -- { '<C-r>{r}', description = 'Paste from register {r}' },
  { '"*p', description = 'Paste from OS clipboard' },
  { ']p', description = 'Paste after and align' },
  { ']P', description = 'Paste before and align' },
  { 'v', description = 'Visual mode (select)' },
  { 'V', description = 'Linewise visual mode' },
  { '<C-v>', description = 'Block visual mode' },
  -- { '<C-v>{Move}I', description = 'Insert in selected lines' },
  -- { '<C-v>{Move}A', description = 'Append to selected lines' },
  -- { '<C-v>{Move}c', description = 'Change in selected lines' },
  -- { '<C-v>{Move}x', description = 'Delete in selected lines' },
  { 'gv', description = 'Reselect visual' },
  { 'ggVG', description = 'Select all' },
  { '<C-w>', description = 'Delete previous word' },
  { '<C-u>', description = 'Erase line before cursor' },
  -- { 'q{r}', description = 'Record macro into register {r}' },
  { 'q', description = 'Stop recording macro' },
  -- { '@{r}', description = 'Run recorded macro in register {r}' },
  { '@@', description = 'Repeat last macro' },
  { '@:', description = 'Repeat last Ex command' },
  { 'aw', description = 'Around word' },
  { 'iw', description = 'Inside word' },
  { 'aW', description = 'Around WORD' },
  { 'iW', description = 'Inside WORD' },
  { 'as', description = 'Around sentence' },
  { 'is', description = 'Inside sentence' },
  { 'ap', description = 'Around paragraph' },
  { 'ip', description = 'Inside paragraph' },
  { 'a( , ab', description = 'Around parentheses' },
  { 'i( , ib', description = 'Inside parentheses' },
  { 'a[', description = 'Around brackets' },
  { 'i[', description = 'Inside brackets' },
  { 'a{ , zB', description = 'Around braces' },
  { 'i{ , iB', description = 'Inside braces' },
  { 'at', description = 'Around (XML) tags' },
  { 'it', description = 'Inside (XML) tags' },
  { 'a<', description = 'Around < and >' },
  { 'i<', description = 'Inside < and >' },
  { 'a"', description = 'Around double quotes' },
  { 'i"', description = 'Inside double quotes' },
  { "a'", description = 'Around simple quotes' },
  { "i'", description = 'Inside simple quotes' },
  { 'a`', description = 'Around backticks' },
  { 'i`', description = 'Inside backticks' },

  { 'gU', description = 'Change to uppercase' },
  { 'gu', description = 'Change to lowercase' },
  { 'gUU', description = 'Uppercase line' },
  { 'guu', description = 'Lowercase line' },
  { 'U', description = 'Change to uppercase' },
  { 'u', description = 'Change to lowercase' },
  { '~', description = 'Toggle case' },
  { '~', description = 'Toggle case' },
  { '>', description = 'Indent (. to repeat)', mode = 'v' },
  { '<', description = 'Unindent (. to repeat)', mode = 'v' },
  { '=', description = 'Reindent' },
  { '>>', description = 'Indent line (. repeats)' },
  { '<<', description = 'Unindent (. repeats)' },
  { '==', description = 'Reindent line' },
  { '<C-t>', description = 'Indent line (insert mode)', mode = 'i' },
  { '<C-d>', description = 'Unindent line (insert mode)', mode = 'i' },
  { 'gq', description = 'Hard-wrap (cursor moves)' },
  { 'gw', description = 'Hard-wrap (cursor stays)' },
  { 'gww', description = 'Format current line' },
  { 'J', description = 'Join with next line' },
  { 'gJ', description = 'Join next line preserve spaces' },
  { '<C-n>', description = 'Autocomplete (search forward)' },
  { '<C-p>', description = 'Autocomplete (search backwards)' },
  { '<C-x><C-o>', description = 'Omnicomplete' },
  { '<C-x><C-l>', description = 'Line autocomplete' },
  -- { '<C-k>{c}{c}', description = 'Insert digraph' },
  { '<C-r>=', description = 'Insert calculated expr.' },
  { '<C-a>', description = 'Increment number' },
  { '<C-x>', description = 'Decrement number' },

  { ']s', description = 'To next misspelled word' },
  { '[s', description = 'To prev misspelled word' },
  { 'z=', description = 'Suggest corrections (normal mode)' },
  { '<C-x>s', description = 'Suggest corrections (insert mode)', mode = 'i' },
  { 'zg', description = 'Permanently mark as correct' },
  { 'zug', description = 'Undo mark as correct' },
  { 'zG', description = 'Temporarily mark as correct' },
  { 'zw', description = 'Permanently mark as incorrect' },
  { 'zuw', description = 'Undo mark as incorrect' },
  { 'zW', description = 'Temporarily mark as incorrect' },

  { '<C-f>', description = 'Scroll down a page' },
  { '<C-b>', description = 'Scroll up a page' },
  { '<C-d>', description = 'Scroll down half a page' },
  { '<C-u>', description = 'Scroll up half a page' },
  { '<C-e>', description = 'Scroll down a bit' },
  { '<C-y>', description = 'Scroll up a bit' },
  { 'zl', description = 'Scroll horizontally right' },
  { 'zh', description = 'Scroll horizontally left' },
  { 'zL', description = 'Scroll horizontally half a screen' },
  { 'zH', description = 'Scroll horizontally half a screen' },
  { 'zt', description = 'Scroll line to top' },
  { 'zb', description = 'Scroll to bottom' },
  { 'zz', description = 'Scroll to center' },
  { 'zR', description = 'Unfold all' },

  { '<C-^>', description = 'Edit last edited file' },
  { '<C-g>', description = 'Get file info' },
  { 'ga', description = 'Character info' },
  { 'gf', description = 'Go to file under cursor' },
  { 'g<C-g>', description = 'Line/word/char count' },
  { 'g%', description = 'Cycle match groups (eg. if,else,end) ' },
  { '/{P}', description = 'Search forward for {P}', unfinished = true },
  { '?{P}', description = 'Search backward for {P}', unfinished = true },
  { 'n', description = 'Go to next match' },
  { 'N', description = 'Go to previous match' },
  { 'gn', description = 'Select up to next match' },
  { 'gN', description = 'Select up to prev match' },
  { '*', description = 'Search word under cursor backward' },
  { '#', description = 'Search word under cursor forward' },
  { '<C-G>', description = 'Go to next match during search' },
  { '<C-T>', description = 'Go to previous match during search' },
  { '<C-n>', description = 'Next command (command mode)' },
  { '<C-p>', description = 'Prev command (command mode)' },
  { 'q:', description = 'Browse command history' },
  { 'q/', description = 'Browse search patterns' },
  { ']c', description = 'Next difference' },
  { '[c', description = 'Prev difference' },
  { 'dp', description = 'Diff put' },
  { 'do', description = 'Diff obtain' },
  { 'h', description = 'Left' },
  { 'l', description = 'Right' },
  { 'k', description = 'Up' },
  { 'j', description = 'Down' },
  { 'gk', description = 'Up (honor soft-wrapping)' },
  { 'gj', description = 'Down (honor soft-wrapping)' },
  { 'w', description = 'Start of next word' },
  { 'b', description = 'Start of prev word' },
  { 'e', description = 'End of next word' },
  { 'ge', description = 'End of prev word' },
  { 'W', description = 'Start of next WORD' },
  { 'B', description = 'Start of prev WORD' },
  { 'E', description = 'End of next WORD' },
  { 'gE', description = 'End of prev WORD' },
  { '0', description = 'Start of line' },
  { '$', description = 'End of line' },
  { '^', description = 'This line 1st non-blank' },
  { '+', description = 'Next line 1st non-blank' },
  { '-', description = 'Prev line 1st non-blank' },
  { 'gg', description = 'First line' },
  { 'G', description = 'Last line' },
  -- { 'f{c}', description = 'Next {c} in this line' },
  -- { 't{c}', description = 'Just before next {c}' },
  -- { 'F{c}', description = 'Prev {c} in this line' },
  -- { 'T{c}', description = 'Just after prev {c}' },
  { ';', description = 'Repeat f/t/F/T forward' },
  { ',', description = 'Repeat f/t/F/T backward' },
  { 'g;', description = 'Prev pos in change list' },
  { 'g,', description = 'Next pos in change list' },
  -- { '{n}|', description = 'Go to column {n}' },
  -- { '{n}G', description = 'Jump to line {n}' },
  { '}', description = 'Jump to next blank line' },
  { '{', description = 'Jump to prev blank line' },
  { '[{', description = 'Jump to begin of block' },
  { ']}', description = 'Jump to end of block' },
  { ')', description = 'Jump to end of sentence' },
  { '(', description = 'Jump to beg. of sentence' },
  { ']]', description = 'Jump to end of section' },
  { '[[', description = 'Jump to beg. of section' },
  { 'H', description = 'Jump to top of window' },
  { 'M', description = 'Jump to middle' },
  { 'L', description = 'Jump to bottom' },
  { '%', description = 'Jump to matching delim' },
  { '<C-t>', description = 'Jump to older tag' },
  { '<C-]>', description = 'Jump to tag definition' },
  { 'g]', description = 'Jump to tag definition, show choices ' },
  { 'g<C-]>', description = 'Jump or show choices' },
  -- { 'm{c}', description = 'Set mark {c}' },
  -- { '`{c}', description = 'Jump to mark at {c}' },
  { 'gd', description = 'Jump to definition' },
  { '<C-o>', description = 'To prev jump position' },
  { '<C-i>', description = 'To next jump position' },
  { 'gi', description = 'Go to last insertion and INSERT' },

  { 'zj', description = 'Go to start of next fold' },
  { 'zk', description = 'Go to end of previous fold' },
  { 'zo', description = 'Open fold under cursor' },
  { 'zO', description = 'Open all folds under cursor' },
  { 'zc', description = 'Close fold under cursor' },
  { 'zC', description = 'Close all folds under cursor' },
  { 'za', description = 'Toggle fold under cursor' },
  { 'zA', description = 'Toggle all folds under cursor' },
  { 'zv', description = 'Open folds to show cursor line' },
  { 'zM', description = 'Close all folds' },
  { 'zR', description = 'Open all folds' },
  { 'zm', description = 'Fold more' },
  { 'zr', description = 'Fold less' },
  { 'zx', description = 'Update folds' },
  { '<C-w><C-n>', description = 'New horizontal split' },
  { '<C-w>c', description = 'Close window' },
  { '<C-w><C-o>', description = 'Close inactive windows' },
  { '<C-w>s', description = 'Split horizontally' },
  { '<C-w><C-v>', description = 'Split vertically' },
  { '<C-w><C-x>', description = 'Exchange windows' },
  { '<C-w>K', description = 'Move to the very top' },
  { '<C-w>J', description = 'Move to the very bottom' },
  { '<C-w>L', description = 'Move to the far right' },
  { '<C-w>H', description = 'Move to the far left' },
  { '<C-w><C-w>', description = 'Cycle through windows' },
  { '<C-w><C-p>', description = 'Back to previous window' },
  { '<C-w><C-h>', description = 'Edit window to the left' },
  { '<C-w><C-j>', description = 'Edit window below' },
  { '<C-w><C-k>', description = 'Edit window above' },
  { '<C-w><C-l>', description = 'Edit window to the right' },
  { '<C-w><C-t>', description = 'Edit top window' },
  { '<C-w><C-b>', description = 'Edit bottom window' },
  { '<C-w>=', description = 'All windows same size' },
  { '<C-w>_', description = 'Maximize height' },
  { '<C-w>|', description = 'Maximize width' },
  { '<C-w>-', description = 'Decrease height' },
  { '<C-w>+', description = 'Increase height' },
  { '<C-w><', description = 'Decrease width' },
  { '<C-w>>', description = 'Increase width' },
  { 'gt', description = 'Next tab' },
  { 'gT', description = 'Previous tab' },
  -- { '{n}gt', description = 'Go to tab {n}' },
  { '<C-w>T', description = 'Move window to new tab' },
  -- { '%:p', description = 'Full path' },
  -- { '%:~', description = 'Relative to $HOME' },
  -- { '%:.', description = 'Relative to current directory' },
  -- { '%:t', description = 'Filename only (tail)' },
  -- { '%:r', description = 'Remove last extension (get root)' },
  -- { '%:e', description = 'Extension only' },
  -- { '%:S', description = 'Escape special chars (use in shell)' },
  -- { '%:s?pat?sub?', description = 'Substitute first' },
  -- { '%:gs?pat?sub?', description = 'Substitute all' },
  -- { '%:p:h', description = 'Get directory of file' },
}

M.builtin_commands = {
  { ':enew', description = 'New untitled document' },
  { ':sp', description = 'Split open (horizontal)' },
  { ':vs', description = 'Split open (vertical)' },
  { ':bd', description = 'Close file' },
  { ':%bd', description = 'Close all' },
  { ':w', description = 'Save' },
  { ':up', description = 'Save (only if modified)' },
  { ':sav {filename}', description = 'Save as', unfinished = true },
  { ':wa', description = 'Save all' },
  { ':w!', description = 'Save read-only file' },
  { ':mks', description = 'Save session' },
  { ':so Session.vim', description = 'Restore session' },
  { ':e', description = 'Reload file from disk' },
  { ':e!', description = 'Revert to last saved' },
  { ':TOhtml', description = 'Convert buffer to HTML' },
  { ':hardcopy', description = 'Print document' },
  { ':q', description = 'Quit (window)' },
  { ':x', description = 'Save and quit (window)' },
  { ':q!', description = 'Quit without saving' },
  { ':xa', description = 'Save all and exit Neovim' },
  { ':qa', description = 'Exit Neovim' },
  { ':qa!', description = 'Exit Neovim without saving' },
  { ':%d', description = 'Cut all' },
  { ':%y', description = 'Copy all' },
  { ':bufdo {Cmd}', description = 'Run {Cmd} in all buffers', unfinished = true },
  { ':set noet', description = 'Use hard tabs' },
  { ':set et', description = 'Use soft tabs (spaces)' },
  { ':retab', description = "Detab (needs 'et' on)" },
  { ':retab!', description = "Entab (needs 'et' off)" },
  { ':set tw={n}', description = 'Set text width to {n}', unfinished = true },
  { ':sort', description = 'Sort selected lines' },
  { ':sort u', description = 'Sort+remove duplicates' },
  { ':norm @{r}', description = 'Run macro in reg {r} for each line', unfinished = true },
  -- { ':g/{P}/{Cmd}', description = 'Run {Cmd} on lines matching {P}' },
  { ':setl spell!', description = 'Toggle spell checking' },

  { ':setl wrap!', description = 'Toggle soft-wrapping' },
  { ':setl cc={n}', description = 'Page guide at column {n}', unfinished = true },
  { ':setl cc=', description = 'No page guide' },
  { ':setl nu!', description = 'Toggle line numbers' },
  { ':setl rnu!', description = 'Toggle relative line numbers' },
  { ':setl list!', description = 'Toggle invisibles' },
  { ':ls', description = 'Show files' },
  { ':b <Tab>', description = 'Edit buffer (autocomplete)' },
  { ':b{n}', description = 'Edit buffer {n}', unfinished = true },
  { ':bn', description = 'Edit next buffer' },
  { ':bp', description = 'Edit prev buffer' },
  { ':prev', description = 'Edir prev in arg list' },
  { ':next', description = 'Edir next in arg list' },

  { ':setl cul!', description = 'Toggle cursorline' },
  { ':setl hls!', description = 'Toggle search highlight' },

  { ':set ic!', description = 'Toggle ignore case' },

  -- { ':s/{P}/{P}/g', description = 'Find and replace' },
  -- { ':s/{P}/{P}/gc', description = 'Find and replace confirm' },
  -- { ':%s/{P}/{P}/g', description = 'Find and replace all' },
  { ':copen', description = 'Open quickfix' },
  { ':cp', description = 'Prev in quickfix list' },
  { ':cn', description = 'Next in quickfix list' },
  { ':cclose', description = 'Close quickfix' },
  { ':lopen', description = 'Open location list' },
  { ':lp', description = 'Prev in location list' },
  { ':lne', description = 'Next in location list' },
  { ':lclose', description = 'Close location list' },

  { ':diffthis', description = 'Use this file for diff' },
  { ':diffoff!', description = 'Exit diff mode' },
  { ':diffupdate', description = 'Re-scan files for diffs' },

  { ':diffget', description = 'Get differences' },
  { ':diffput', description = 'Put differences' },

  { ':{n}', description = 'Go to line {n}', unfinished = true },
  { ':tag [tagname]', description = 'Jump to specified tag', unfinished = true },

  { ':tn', description = 'To next matching tag' },
  { ':tp', description = 'To prev matching tag' },

  { ':marks', description = 'View all marks' },
  { ':delmarks {mark}', description = 'Remove marks', unfinished = true },
  { ':new', description = 'New horizontal split' },
  { ':vnew', description = 'New vertical split' },

  { ':ball', description = 'One window per file' },

  { ':windo {Cmd}', description = 'Execute {Cmd} in all windows', unfinished = true },

  { ':tabnew', description = 'New untitled tab' },
  { ':tabe [file]', description = 'New/open in tab', unfinished = true },

  { ':tabc', description = 'Close tab' },
  { ':tabo', description = 'Close all other tabs' },
  { ':tabs', description = 'List tabs' },
  { ':tab ball', description = 'Open one tab per buffer' },
  { ':tabdo {Cmd}', description = 'Execute {Cmd} in all tabs', unfinished = true },

  { ':h [helptag]', description = 'Help', unfinished = true },
  { ':helpg {search}', description = 'Help search' },
  { ':h hitest.vim', description = 'Help on highlight test' },
  { ':map [mapping]', description = 'View mappings', unfinished = true },
  { ':imap [mapping]', description = 'View Insert mode mappings', unfinished = true },
  { ':reg', description = 'View registers' },
  { ':scr', description = 'List of sourced files' },
  { ':digraphs', description = 'List of digraphs' },
  { ':syn', description = 'List all syntax items' },

  { ':pwd', description = 'Show current directory' },
  { ':cd {dir}', description = 'Change directory', unfinished = true },
  { ':cd', description = 'Change to home directory' },
  { ':echo {Var}', description = 'Show value of {Var}', unfinished = true },
  -- for this one we'd need to somehow put the cursor before the ? in the cmdline
  -- { ':set {Opt}?', description = 'Show value of option' },
  { ':noh', description = "Clear 'hlsearch' highlights" },
  { ':only', description = 'Make the current window the only one on the screen' },
}

return M
