local notify = require('notify')

vim.notify = notify

notify.setup({
  top_down = false,
  max_width = 120,
  level = 2,
})
