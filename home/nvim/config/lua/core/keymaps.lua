local M = {}

local commander = require('commander')

M.map = function(mode, lhs, rhs, opts)
  local options = { noremap = false, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
local map = M.map

M.commander_map = function(shortcut_mode, shortcut_keybind, command_cmd, command_desc)
  if shortcut_mode then
    commander.add({
      {
        desc = command_desc,
        cmd = command_cmd,
        keys = { { shortcut_mode, shortcut_keybind, { noremap = true } } },
      },
    })
  else
    commander.add({
      {
        desc = command_desc,
        cmd = command_cmd,
      },
    })
  end
end
local commander_map = M.commander_map

-- Change leader to a semi-colon, ALSO SET IN lazy_init.lua FOR LAZY
vim.g.mapleader = ';'
vim.g.maplocaleader = ';'

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Remap Esc
map('i', 'jk', '<Esc>')

-- Clear search highlighting
map('n', '<leader>v', ':nohl<CR>')

-- Create splits
map('n', '<leader>S', ':split<CR>')
map('n', '<leader>s', ':vsplit<CR>')
map('n', '<leader>n', ':vnew<CR>')
map('n', '<leader>N', ':new<CR>')

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<leader>h', '<C-w>h')
map('n', '<leader>j', '<C-w>j')
map('n', '<leader>k', '<C-w>k')
map('n', '<leader>l', '<C-w>l')

-- Resize splits
map('n', '<S-Up>', '10<C-w>+')
map('n', '<S-Right>', '10<C-w>>')
map('n', '<S-Down>', '10<C-w>-')
map('n', '<S-Left>', '10<C-w><')

-- Reload configuration without restart nvim
map('n', '<leader>r', ':Restart<CR>')
commander_map(nil, nil, ':Restart<CR>', "Attempt nvim config reload (probably won't work)")

-- Fast saving with <leader> and s
map('n', '<leader>w', ':w<CR>')

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>aq', ':q<CR>')
map('n', '<leader>aaq', ':qa!<CR>')

map('n', '<leader>ts', ":let &background=(&background == 'light' ? 'dark' : 'light')<CR>")

-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------

-- Telescope Maps
map('n', '<leader>c', ':Telescope commander<CR>')
commander_map('n', '<leader>g', ':Telescope find_files<CR>', 'Telescope (Fuzzy search files)')
commander_map('n', '<leader>tr', ':Telescope resume<CR>', 'Telescope (last search)')
commander_map('n', '<leader>f', '<CMD> lua require("arena").toggle()<CR>', 'Arena Fecency')
commander_map(
  'n',
  '<C-f>',
  ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
  'Telescope (Grep in files)'
)

-- Fterm (floating terminal)
commander_map('n', '<leader>b', '<CMD>lua require("FTerm").toggle()<CR>', 'Open Terminal')
map('t', '<Esc>', '<CMD>lua require("FTerm").toggle()<CR>')
map('t', '<Ctrl-d>', '<CMD>lua require("FTerm").toggle()<CR>')

-- NvimTree
commander_map('n', '<leader>e', ':NvimTreeToggle<CR>', 'Toggle NvimTree')
commander_map('n', '<C-n>', ':NvimTreeRefresh<CR>', 'Refresh NvimTree')
commander_map('n', '<C-t>', ':NvimTreeFindFile<CR>', 'Find current file in NvimTree')

-- Markdown
commander_map('n', '<C-k>', ':MarkdownPreview<CR>', 'Preview Markdown (opens browser)')

-- Lsp stuff like Format, Sort imports, etc...
commander_map(nil, nil, ':lua vim.lsp.buf.format()<CR>', 'Format Entire Document')
commander_map(nil, nil, ':noa w<CR>', 'Save without formatting')

-- Git diffview
commander_map('n', '<C-g>', ':DiffviewOpen<CR>', 'Git Diff (Open)')
commander_map('n', '<C-c>', ':DiffviewClose<CR>', 'Git Diff (Close)')

-- Test the teg_notify stuff
commander_map(
  nil,
  nil,
  ':lua require("core/teg").notify_info("This is the result of calling `require(\'core/teg\').notify_info()`!")<CR>',
  "Test teg's `notify_info`"
)
commander_map(
  nil,
  nil,
  ':lua require("core/teg").notify_error("This is the result of calling `require(\'core/teg\').notify_error()`!")<CR>',
  "Test teg's `notify_error`"
)
commander_map(
  nil,
  nil,
  ':lua require("core/teg").notify_trace("This is the result of calling `require(\'core/teg\').notify_trace()`!")<CR>',
  "Test teg's `notify_trace` (check `:Telescope notify` maybe)"
)
commander_map(nil, nil, ':DiffviewClose<CR>', 'Git Diff (Close)')

-- Spectre (aka Find and Replace)
commander_map(
  'n',
  '<C-j>',
  "<cmd>lua require('spectre').open()<CR>",
  'Find and Replace in Workspace (Spectre)'
)

M.register_zk_keymaps = function()
  -- Don't format on save when dealing with zettelkasten buffers
  map('n', '<leader>w', ':set eventignore+=BufWritePre | w | set eventignore-=BufWritePre<CR>')

  -- Preview a linked note.
  map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  -- Open the link under the caret.
  map('n', '<CR>', '<Cmd>lua vim.lsp.buf.definition()<CR>')

  -- Zellenkasten
  -- Override basic file fuzzy search for "Open Recent Notes"
  map('n', '<leader>g', '<Cmd>ZkRecents<CR>')
  -- Open notes.
  map('n', '<leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>")
  -- Open notes associated with the selected tags.
  map('n', '<leader>zt', '<Cmd>ZkTags<CR>')
  -- Search for the notes matching a given query.
  map(
    'n',
    '<leader>zf',
    "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>"
  )
  -- Search for the notes matching the current visual selection.
  map('v', '<leader>zf', ":'<,'>ZkMatch<CR>")
  -- Create a new note after asking for its title.
  map('n', '<leader>zn', ':lua require("extensions/my_zk").create_zettel_of_type("archive")<CR>')
  map('n', '<leader>zzn', ':lua require("extensions/my_zk").create_zettel()<CR>')
  -- Create a new note in the same directory as the current buffer, using the current selection for title.
  map('v', '<leader>znt', ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>")
  -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
  map(
    'v',
    '<leader>znc',
    ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>"
  )
  -- Open notes linking to the current buffer.
  map('n', '<leader>zb', '<Cmd>ZkBacklinks<CR>')
  -- Open notes linked by the current buffer.
  map('n', '<leader>zl', '<Cmd>ZkLinks<CR>')
  -- Open the code actions for a visual selection.
  map('v', '<leader>zc', ":'<,'>lua vim.lsp.buf.range_code_action()<CR>")
end

return M
