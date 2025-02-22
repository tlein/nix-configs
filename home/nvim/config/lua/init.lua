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
require('plugins/vim-wordmotion')
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
require('plugins/comment')
require('plugins/auto-dark-mode')
require('plugins/nvim-cursorline')
require('plugins/lsp_lines')
require('plugins/indent-blankline')

vim.defer_fn(function()
  local current_background = vim.api.nvim_get_option_value('background', {})
  vim.api.nvim_command('colorscheme catppuccin')
  vim.api.nvim_set_option_value('background', current_background, {})
  teg.notify_info(
    'Performed a post-boot sequence 1.0 seconds after init.lua finished.\nThis is expected (you did this to get the catppuccin colorscheme re-applied after boot).\nThis is needed because of auto-dark-mode screwing up the colors when entering in light mode.'
  )
end, 1000)
