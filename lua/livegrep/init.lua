local sorters = require("telescope.sorters")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local M = {}

local entry_maker = function(entry)
  return {
    value = entry,
    display = vim.trim(entry.line),
    ordinal = vim.trim(entry.line),
    filename = entry.path,
    lnum = entry.lno,
  }
end

M.livegrep = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Livegrep",
      finder = finders.new_dynamic({
        fn = require("livegrep.search"),
        entry_maker = entry_maker,
      }),
      sorter = sorters.highlighter_only(opts),
      previewer = conf.grep_previewer(opts),
    })
    :find()
end

return M
