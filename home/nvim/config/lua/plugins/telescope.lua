local telescope = require('telescope')
local telescope_actions = require('telescope.actions')

telescope.setup({
  extensions = {},
  defaults = { mappings = { i = { ['<esc>'] = telescope_actions.close } } },
  pickers = {
    find_files = {
      hidden = true,
      file_ignore_patterns = {
        '.git/',
        '.cache',
        'node_modules/',
        '%.o',
        '%.a',
        '%.out',
        '%.class',
        'build/',
        'install/',
        '.idea/',
        '.DS_Store',
        'zig-out/',
        'zig-cache/',
      },
    },
  },
})

-- telescope.load_extension('recent_files')
telescope.load_extension('notify')
