local curl = require("plenary.curl")
local sorters = require("telescope.sorters")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

-- All options:
-- url:
-- regex: "true" or "false"
-- fold_case: "auto"
-- raw_curl_opts: nil
local livegrep_defaults = {
  regex = "true",
  fold_case = "auto",
  url = "https://livegrep.com/api/v1/search/linux",
}

-- Create a search function for use by Livegrep picker
local function make_search_fn(opts)
  local opts = vim.tbl_extend("force", livegrep_defaults, opts)
  return function(prompt)
    -- Wait for 2 characters to search
    if string.len(vim.trim(prompt)) < 2 then
      return {}
    end

    local query_params = vim.tbl_extend("keep", {
      q = prompt,
      -- We don't need context since we use local previews
      context = "false",
    }, {
      regex = opts.regex,
      fold_case = opts.fold_case,
      repo = opts.repo,
    })

    local response = curl.get({
      url = opts.url,
      accept = "application/json",
      query = query_params,
      raw = opts.raw_curl_opts,
    })
    local parsed_body = vim.fn.json_decode(response.body)
    return parsed_body.results
  end
end

local function entry_display(entry)
  local value = entry.value
  local file = value.path
  local column_no = value.bounds[1]
  local line_no = value.lno
  local line = vim.trim(value.line)

  return string.format("%s:%d:%d:%s", file, line_no, column_no, line)
end

-- Entry maker for picker
local function entry_maker(entry)
  return {
    value = entry,
    display = entry_display,
    ordinal = vim.trim(entry.line),
    filename = entry.path,
    lnum = entry.lno,
    col = entry.bounds[1],
  }
end

-- Create a new Livgrep picker
local function livegrep(opts)
  opts = opts or {}

  pickers
    .new(opts, {
      prompt_title = "Livegrep",
      finder = finders.new_dynamic({
        fn = make_search_fn(opts),
        entry_maker = entry_maker,
      }),
      sorter = sorters.highlighter_only(opts),
      previewer = conf.grep_previewer(opts),
    })
    :find()
end

return require("telescope").register_extension({
  setup = function(ext_config, config)
    livegrep_defaults = vim.tbl_extend("force", livegrep_defaults, ext_config or {})
  end,
  exports = {
    livegrep = livegrep,
  },
})
