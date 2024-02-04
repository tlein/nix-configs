local zk = require('zk')
local zk_commands = require('zk.commands')
local lspconfig_util = require('lspconfig.util')
local lsp = require('plugins/lsp-config')

zk.setup({
  -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
  -- it's recommended to use "telescope" or "fzf"
  picker = 'telescope',

  lsp = {
    -- `config` is passed to `vim.lsp.start_client(config)`
    config = {
      cmd = { 'zk', 'lsp' },
      name = 'zk',
      single_file_support = false,
      on_attach = lsp.my_on_attach,
      capabilities = lsp.my_capabilities,
      -- on_attach = ...
      -- etc, see `:h vim.lsp.start_client()`
    },

    -- automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {
      enabled = true,
      filetypes = { 'markdown' },
      root_dir = function()
        return lspconfig_util.root_pattern('.zk')
      end,
    },
  },
})

local function make_edit_fn(defaults, picker_options)
  return function(options)
    options = vim.tbl_extend('force', defaults, options or {})
    zk.edit(options, picker_options)
  end
end

zk_commands.add('ZkOrphans', make_edit_fn({ orphan = true }, { title = 'Zk Orphans' }))
zk_commands.add(
  'ZkRecents',
  make_edit_fn({ createdAfter = '2 weeks ago', sort = { 'modified' } }, { title = 'Zk Recents' })
)
