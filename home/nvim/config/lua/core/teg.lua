local M = {}

-- String utils
M.string_starts_with = function(string_to_check, with_string)
  return string.sub(string_to_check, 1, string.len(with_string)) == with_string
end

-- Table utils
M.merge_tables = function(table1, table2)
  return vim.tbl_extend('keep', table1 or {}, table2 or {})
end

M.create_set_from_table = function(table)
  local set = {}
  for _, l in ipairs(table) do
    set[l] = true
  end
  return set
end

-- Notify utils
M.notify_info = function(msg, opts)
  if opts == nil then
    opts = {}
  end

  vim.notify(msg, vim.log.levels.INFO, opts)
end

M.notify_error = function(msg, opts)
  if opts == nil then
    opts = {}
  end

  vim.notify(msg, vim.log.levels.ERROR, opts)
end

M.notify_trace = function(msg, opts)
  if opts == nil then
    opts = {}
  end

  vim.notify(msg, vim.log.levels.TRACE, opts)
end

-- UI Module
M.ui = {}

return M
