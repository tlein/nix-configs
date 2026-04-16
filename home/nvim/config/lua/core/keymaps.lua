local M = {}

M.map = function(mode, lhs, rhs, opts)
  local options = { noremap = false, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
local map = M.map

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

map('n', '<leader>tl', "mA<bar><leader>l<bar>'A")
map('n', '<leader>th', "mA<bar><leader>h<bar>'A")

-- Resize splits
map('n', '<S-Up>', '10<C-w>+')
map('n', '<S-Right>', '10<C-w>>')
map('n', '<S-Down>', '10<C-w>-')
map('n', '<S-Left>', '10<C-w><')

-- Reload configuration without restart nvim
map('n', '<leader>r', ':Restart<CR>')

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
map('n', '<leader>g', ':Telescope find_files<CR>')
map('n', '<leader>tr', ':Telescope resume<CR>')
map('n', '<leader>f', '<CMD> lua require("arena").toggle()<CR>')
map('n', '<C-f>', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")

-- Fterm (floating terminal)
map('n', '<leader>b', '<CMD>lua require("FTerm").toggle()<CR>')
map('t', '<Esc>', '<CMD>lua require("FTerm").toggle()<CR>')
map('t', '<Ctrl-d>', '<CMD>lua require("FTerm").toggle()<CR>')

-- NvimTree
map('n', '<leader>e', ':NvimTreeToggle<CR>')
map('n', '<C-n>', ':NvimTreeRefresh<CR>')
map('n', '<C-t>', ':NvimTreeFindFile<CR>')

-- Markdown
map('n', '<C-k>', ':MarkdownPreview<CR>')

-- Git diffview
map('n', '<C-g>', ':DiffviewOpen<CR>')
map('n', '<C-c>', ':DiffviewClose<CR>')

-- Test the teg_notify stuff

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
