local curl = require("plenary.curl")

--

local url = "https://livegrep.com/api/v1/search/linux"
local query = {
  q = "hello",
  fold_case = "auto",
  regex = "true",
}

local response = curl.get({
  url = url,
  accept = "application/json",
  query = query,
})
local parsed_body = vim.fn.json_decode(response.body)

-- Results

print(vim.inspect(parsed_body))
