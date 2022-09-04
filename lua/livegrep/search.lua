local curl = require("plenary.curl")

local defaults = {
  regex = "true",
  fold_case = "auto",
  url = "https://livegrep.com/api/v1/search/linux",
}

local function make_search_fn(opts)
  local opts = vim.tbl_extend("force", defaults, opts)
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
      command = opts.command,
      accept = "application/json",
      query = query_params,
    })
    local parsed_body = vim.fn.json_decode(response.body)
    return parsed_body.results
  end
end

return make_search_fn
