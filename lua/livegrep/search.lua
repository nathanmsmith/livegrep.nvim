local curl = require("plenary.curl")

local default_url = "https://livegrep.com/api/v1/search/linux"

local function search_livegrep(query, params)
  local params = params or {}

  -- Wait for 2 characters to search
  if string.len(vim.trim(query)) < 2 then
    return {}
  end

  local query_params = {
    q = query,
    fold_case = "auto",
    regex = "true",
  }
  local url = params.url or default_url

  local response = curl.get({
    url = url,
    accept = "application/json",
    query = query_params,
  })
  local parsed_body = vim.fn.json_decode(response.body)
  return parsed_body.results
end

return search_livegrep
