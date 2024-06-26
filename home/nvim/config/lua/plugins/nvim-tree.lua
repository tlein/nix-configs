-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- OR setup with some options
require('nvim-tree').setup({
  sort_by = 'case_sensitive',
  view = {
    width = 50,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
    custom = {
      '*.meta',
    },
  },
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')
    api.config.mappings.default_on_attach(bufnr)
    local opts = { buffer = bufnr }

    -- Ok, you're unsetting the bookmark-related functionality of nvim-tree here. I don't
    -- really remember *why* I did this, but I'm leaving it because it was probably enough
    -- of a pain-in-the-ass to hunt down before and frustrating enough to want me to hunt
    -- it down.
    vim.keymap.set('n', 'bd', '', opts)
    vim.keymap.del('n', 'bd', opts)
    vim.keymap.set('n', 'bt', '', opts)
    vim.keymap.del('n', 'bt', opts)
    vim.keymap.set('n', 'bmv', '', opts)
    vim.keymap.del('n', 'bmv', opts)
  end,
})

local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- create a new, empty buffer
  vim.cmd.enew()

  -- wipe the directory buffer
  vim.cmd.bw(data.buf)

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require('nvim-tree.api').tree.open()
end
vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })
