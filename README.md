# livegrep.nvim

[Livegrep](https://github.com/livegrep/livegrep), directly inside of Neovim.

## Installation

livegrep.nvim depends upon plenary.nvim and telescope.nvim. It also assumes that you have a recent version of curl installed.

Using packer.nvim:

```lua
use({
  "nathanmsmith/livegrep.nvim",
  requires = { { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" } },
})
```

Then set up livegrep.nvim as a telescope extension.

```lua
require("telescope").setup({
  -- ...
})
require("telescope").load_extension("livegrep")
```

You'll also probably want to setup a keybinding to trigger livegrep. I use `<leader>f` (for "find").

```lua
vim.keymap.set("n", "<leader>f", function()
  require("telescope").extensions.livegrep.livegrep()
end, { silent = true })
```

## Configuration

Configuration can either be set for the entire extension or individual calls. Examples:

```lua
-- Set default url for all calls
require("telescope").setup({
  extensions = {
    livegrep = {
      url = "https://my-custom-livegrep-instance.com/api/v1/search"
    }
  }
})

-- Set custom regex behavior for a single call
vim.keymap.set("n", "<leader>g", function()
  require("telescope").extensions.livegrep.livegrep({fold_case = "false"})
end, { silent = true })
```

All of the options are as follows:

- `url` (default: `"https://livegrep.com/api/v1/search/linux"`): The url of the API to search against.
- `fold_case` (default: `"auto"`): Should the query be case-sensitive? `"true"` means case-insensitive, `"false"` means case-sensitive, `"auto"` is case-insensitive unless an uppercase character is given (similar to Vim's `smartcase`)
- `regex` (default: `"true"`): Should the query be parsed as a regex or literally? `"true"` parses as a regex, `"false"` performs a literal string search.
- `raw_curl_opts` (default: `nil`): A table of extra arguments to pass to the `curl` call to the API.
