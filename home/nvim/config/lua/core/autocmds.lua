-- Because we turn on vim.wo.wrap using the following BufEnter autocmd for certain filetypes (.md),
-- and because vim.wo.wrap applies to the window, and not per-buffer, we need to constantly set it
-- back to ours "default" value whenever we leave a buffer in case the buffer we were leaving was a
-- filetype that turned it on. We don't want to target a specific filetype in the BufLeave
-- autocmd's `pattern` however, because more ftplugins might be added in the future which also want
-- to turn on vim.wo.wrap
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.md',
  group = vim.api.nvim_create_augroup('TJL_TURN_ON_WORDWRAP_FOR_CERTAIN_FILES', {}),
  callback = function()
    vim.wo.wrap = true
    vim.opt.colorcolumn = nil
  end,
})
vim.api.nvim_create_autocmd('BufLeave', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('TJL_TURN_OFF_WORDWRAP_BY_DEFAULT', {}),
  callback = function()
    vim.wo.wrap = false
    vim.opt.colorcolumn = '100'
  end,
})
