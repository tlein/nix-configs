-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------
-----------------------------------------------------------
-- General
-----------------------------------------------------------
vim.opt.mouse = 'a' -- Enable mouse support
vim.opt.clipboard = 'unnamedplus' -- Copy/paste to system clipboard
vim.opt.swapfile = false -- Don't use swapfile
vim.opt.completeopt = 'menuone,noinsert,noselect' -- Autocomplete options

vim.g.do_filetype_lua = true -- new native filetype, opt-in preview mode currently, so I'm opting-in
vim.g.did_load_filetypes = false -- new native filetype, opt-in preview mode currently, so I'm opting-in

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
vim.opt.number = true -- Show line number
vim.opt.showmatch = true -- Highlight matching parenthesis
vim.opt.foldmethod = 'marker' -- Enable folding (default 'foldmarker')
vim.opt.foldlevel = 20 -- Enable folding (default 'foldmarker')

-- THIS IS ALSO SET IN tjl/core/autocmds.lua!
vim.opt.colorcolumn = '100' -- Line lenght marker at 100 columns

vim.opt.splitright = true -- Vertical split to the right
vim.opt.splitbelow = true -- Horizontal split to the bottom
vim.opt.ignorecase = true -- Ignore case letters when search
vim.opt.smartcase = true -- Ignore lowercase for the whole pattern
vim.opt.linebreak = true -- Wrap on word boundary
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.laststatus = 3 -- Set global statusline
vim.opt.list = true
vim.opt.listchars:append('space:⋅')

-- THIS IS ALSO SET IN tjl/core/autocmds.lua!
vim.wo.wrap = false -- Turn off word wrap

-- Setting vim.diagnostic.config is now controlled by the lsp_lines plugin, but I wanted to leaves
-- this here for historical purposes, however silly that really is to do.
-- vim.diagnostic.config({ virtual_text = true }) -- Change lsp error meta text into fancy "virtual" text so it doesn't occupy same space as normal nvim buffer code

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Shift 4 spaces when tab
vim.opt.tabstop = 2 -- 1 tab == 4 spaces
vim.opt.smartindent = true -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
vim.opt.hidden = true -- Enable background buffers
vim.opt.history = 100 -- Remember N lines in history
-- vim.opt.lazyredraw = true -- Faster scrolling
vim.opt.synmaxcol = 240 -- Max column for syntax highlight
vim.opt.updatetime = 700 -- ms to wait for trigger an event

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
vim.opt.shortmess:append('sI')

-- Disable builtins plugins
local disabled_built_ins = {
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'logipat',
  'rrhelper',
  'spellfile_plugin',
  'matchit',
}

vim.opt.shellcmdflag = '-c'

for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end
