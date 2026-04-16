require('nvim-treesitter').setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {
      'markdown',
    },
  },
})

local ensureInstalled = {
  'rust',
  'lua',
  'nix',
}
local alreadyInstalled = require('nvim-treesitter.config').get_installed()
local parsersToInstall = vim
  .iter(ensureInstalled)
  :filter(function(parser)
    return not vim.tbl_contains(alreadyInstalled, parser)
  end)
  :totable()
require('nvim-treesitter').install(parsersToInstall)
