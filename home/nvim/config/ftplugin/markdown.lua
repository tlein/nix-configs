local my_zk = require('extensions/my_zk')

my_zk.register_zk_keymaps_if_in_notebook()

vim.wo.wrap = true -- Turn on word wrap
vim.opt.colorcolumn = nil -- remove color column indicating 120 length lines.
