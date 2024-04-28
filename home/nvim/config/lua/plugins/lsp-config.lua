local M = {}

local lspconfig = require('lspconfig')
local cmp = require('cmp')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local null_ls = require('null-ls')
local luasnip = require('luasnip')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(nil),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
})

M.my_on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', {})

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)
  if vim.lsp.inlay_hint then
    vim.keymap.set('n', '<leader>uh', function()
      vim.lsp.inlay_hint(0, nil)
    end, { desc = 'Toggle Inlay Hints' })
  else
  end
end
M.my_capabilities = cmp_nvim_lsp.default_capabilities()

local filetypes_to_ignore_formatting_for = teg.create_set_from_table({
  'vim',
  'gitignore',
  'gitconfig',
  'text',
  'markdown',
  'cmake',
  'gdshader', -- unity's shaders are being categorized as gdshader for some reason, preference for Godot maybe
})

-- Uses `vim.fn.fnamemodify(vim.fn.getcwd(), ':t')` to get the dirname of the cwd (last part of
-- cwd). Then if that dirname is a key in this map, we can try doing code formatting. This is to
-- prevent external projects from being something that neovim would attempt to format.
local projects_to_allow_formatting_for = teg.create_set_from_table({
  'teg',
  'dotfiles',
  'nix-configs',
  'squatbot',
  'ancona',
  'jat', -- rufus game
  'parallel_programming_course',
  'GameJamPrep',
  'UnitySkybox',
  'kibble',
})

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
  },
})

local TjlFormatOnSaveGroup =
  vim.api.nvim_create_augroup('tjl_format_on_save_augroup', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    if filetypes_to_ignore_formatting_for[vim.bo.filetype] ~= nil then
      teg.notify_trace(
        'This filetype (' .. vim.bo.filetype .. ') is explicitly ignored for formatting!'
      )
      return
    end

    local project_dirname = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    if projects_to_allow_formatting_for[project_dirname] == nil then
      teg.notify_trace(
        'This project ('
          .. project_dirname
          .. ') is not included in tjl/plugins/lsp.lua projects_to_allow_formatting_for, so '
          .. 'formatting will not be attempted!'
      )
      return
    end

    teg.notify_trace(
      'Attempting to format in project ' .. project_dirname .. ', filetype: ' .. vim.bo.filetype
    )
    vim.lsp.buf.format()
  end,
  group = TjlFormatOnSaveGroup,
})

lspconfig.rust_analyzer.setup({
  on_attach = M.my_on_attach,
  capabilities = M.my_capabilities,
})

lspconfig.lua_ls.setup({
  on_attach = M.my_on_attach,
  capabilities = M.my_capabilities,
  settings = {
    Lua = {
      hint = { enable = true },
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
          'teg',
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = { enable = false },
      format = { enable = false },
    },
  },
})

lspconfig.nil_ls.setup({
  on_attach = M.my_on_attach,
  capabilities = M.my_capabilities,
})

local pid = vim.fn.getpid()
local omnisharp_bin = 'OmniSharp'
lspconfig.omnisharp.setup({
  on_attach = M.my_on_attach,
  capabilities = M.my_capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) },
})

return M
