local curl = require("plenary.curl")

local default_url = "https://livegrep.com/api/v1/search/linux"

-- opts
--   url
--   proxy
--   local_repo_only
local function search_livegrep(query, opts)
  local opts = opts or {}

  -- Wait for 2 characters to search
  if string.len(vim.trim(query)) < 2 then
    return {}
  end

  local query_params = {
    q = query,
    fold_case = "auto",
    regex = "true",
  }
  local url = opts.url or default_url

  local response = curl.get({
    url = url,
    accept = "application/json",
    query = query_params,
  })
  local parsed_body = vim.fn.json_decode(response.body)
  return parsed_body.results
end

return search_livegrep
