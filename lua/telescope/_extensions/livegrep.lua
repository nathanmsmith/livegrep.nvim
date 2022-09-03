local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local curl = require("plenary.curl")
local async = require("plenary.async_lib").async

local url = "https://livegrep.com/api/v1/search/linux"

local livegrep_search = function(query)
  -- Wait for 2 characters to search
  if string.len(vim.trim(query)) < 2 then
    return {}
  end

  local query_params = {
    q = query,
    fold_case = "auto",
    regex = "true",
  }

  local response = curl.get({
    url = url,
    accept = "application/json",
    query = query,
  })
  local parsed_body = vim.fn.json_decode(response.body)
  return parsed_body.results
end

local entry_maker = function(entry)
  return {
    value = entry,
    display = entry.line,
    ordinal = entry.line,
    filename = entry.path,
    lnum = entry.lno,
  }
end

local livegrep = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Livegrep",
      finder = finders.new_dynamic({
        fn = livegrep_search,
        entry_maker = entry_maker,
      }),
      sorter = conf.file_sorter(opts),
      previewer = conf.file_previewer(opts),
    })
    :find()
end

-- to execute the function
livegrep()
