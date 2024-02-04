local M = {}

local keymaps = require('core/keymaps')
local teg = require('core/teg')
local zk = require('zk')

local zk_error = function(msg, opts)
  if opts == nil then
    opts = {}
  end

  opts.title = 'Zettelkasten'
  teg.notify_error(msg, { title = 'Zettelkasten' })
end

local zk_trace = function(msg, opts)
  if opts == nil then
    opts = {}
  end

  opts.title = 'Zettelkasten'
  teg.notify_trace(msg, { title = 'Zettelkasten' })
end

M.note_types = {
  'archive',
  'reference',
  'child_reference',
  'definition',
  'blob',
  'todo',
}

M.days_of_week = {
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
}

function M.create_zettel()
  vim.ui.select(M.note_types, { prompt = 'Type?' }, M.create_zettel_of_type)
end

function M.create_zettel_of_type(zettel_type)
  local is_int = function(n)
    return (type(n) == 'number') and (math.floor(n) == n)
  end

  if zettel_type == nil then
    return
  end

  if zettel_type == 'todo' then
    vim.ui.input({ prompt = 'Year? (number) | todo: YYYY_MM_DD {day_of_week}' }, function(year_str)
      -- if !is_int(year_str) then
      --   teg.notify_error('Year needs to be a number!')
      --   return
      -- end

      vim.ui.input(
        { prompt = 'Month? (number) | todo: ' .. year_str .. '_MM_DD {day_of_week}' },
        function(month_str)
          -- if !is_int(month_str) then
          --   teg.notify_error('Month needs to be a number!')
          --   return
          -- end

          vim.ui.input({
            prompt = 'Day? (number) | todo: '
              .. year_str
              .. '_'
              .. month_str
              .. '_DD {day_of_week}',
          }, function(day_str)
            -- if !is_int(day_str) then
            --   teg.notify_error('Day needs to be a number!')
            --   return
            -- end

            vim.ui.select(M.days_of_week, {
              prompt = 'Day of week? | todo: '
                .. year_str
                .. '_'
                .. month_str
                .. '_'
                .. day_str
                .. ' {day_of_week}',
            }, function(day_of_week)
              local title = year_str .. '_' .. month_str .. '_' .. day_str .. ' ' .. day_of_week
              M.create_zettel_of_type_and_title(zettel_type, title)
            end)
          end)
        end
      )
    end)
    return
  end

  vim.ui.input({ prompt = 'What is the _title_ of this new Zettel?: ' }, function(zettel_title)
    M.create_zettel_of_type_and_title(zettel_type, zettel_title)
  end)
end

-- IDEA:
-- Future improvement could pull up a vim.ui.select window of all the base_reference zettels when making a
-- child_reference
function M.create_zettel_of_type_and_title(zettel_type, zettel_title)
  if zettel_title == nil or zettel_type == nil then
    return
  end

  if zettel_title == '' then
    zk_error('Error: Zettel title was empty!')
    return
  end

  local zk_new_opts = {
    group = zettel_type,
    title = zettel_title,
  }
  if zettel_type == 'archive' then
    zk_new_opts.dir = 'archive'
  elseif zettel_type == 'reference' then
    zk_new_opts.dir = 'reference'
  elseif zettel_type == 'child_reference' then
    zk_new_opts.dir = 'reference'
  elseif zettel_type == 'definition' then
    zk_new_opts.dir = 'definition'
  elseif zettel_type == 'blob' then
    zk_new_opts.dir = 'blob'
  elseif zettel_type == 'todo' then
    zk_new_opts.dir = 'archive'
  else
    zk_error('Error: Zettel type value was unexpected it was: ' .. zettel_type)
  end

  zk_trace(
    'Creating a new zettel of type `'
      .. zettel_type
      .. '`, and with the title: '
      .. zettel_title
      .. '\nopts into zk.new:\n'
      .. vim.inspect(zk_new_opts)
  )
  zk.new(zk_new_opts)
end

M.is_in_zk_notebook_dir = function()
  if vim.loop.os_uname().sysname == 'Windows_NT' then
    -- Windows specific solution to detecting zk notebook because Windows is special like that.
    return teg.string_starts_with(
      vim.fn.expand('%:p'),
      'C:\\Users\\tucker\\Dropbox\\zettelkasten_tjl'
    )
  else
    return require('zk.util').notebook_root(vim.fn.expand('%:p')) ~= nil
  end
end

M.register_zk_keymaps_if_in_notebook = function()
  -- Add the key mappings only for Markdown files in a zk notebook.
  if M.is_in_zk_notebook_dir() then
    keymaps.register_zk_keymaps()
  end
end

return M
