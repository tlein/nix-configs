--------------------------------------------
-- Tucker Lein's Neovim config
--
-- Based On: https://github.com/brainfucksec/neovim-lua
--------------------------------------------
teg = require('core/teg')

------------------------------------------
-- Load core vim settings
require('core/options')
require('core/keymaps')
require('core/colors')
require('core/autocmds')

------------------------------------------
-- Load plugin settings
require('plugins/lsp-config')
require('plugins/nvim-treesitter')
require('plugins/nvim-tree')
require('plugins/telescope')
require('plugins/fidget')
require('plugins/commander')
require('plugins/catppuccin')
require('plugins/lualine')
require('plugins/nvim-notify')
require('plugins/FTerm')
require('plugins/zk')
require('plugins/dressing')
