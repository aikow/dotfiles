local M = {}

M.setup = function()
  local map = vim.keymap.set
  local luasnip = require("luasnip")

  -- --------------
  -- |   Config   |
  -- --------------
  luasnip.config.set_config({
    autotrigger = true,
    history = true,
    updateevents = "TextChanged,TextChangedI",
  })

  -- -----------------------
  -- |   Trigger Keymaps   |
  -- -----------------------
  map(
    { "i" },
    "<Tab>",
    "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'",
    { silent = true, expr = true, desc = "luasnip jump forward one or insert tab" }
  )
  map("s", "<Tab>", function()
    require("luasnip").jump(1)
  end, { silent = true, desc = "luasnip jump forward one" })
  map("i", "<S-Tab>", function()
    require("luasnip").jump(-1)
  end, { silent = true, desc = "luasnip jump back one" })
  map("s", "<S-Tab>", function()
    require("luasnip").jump(-1)
  end, { silent = true, desc = "luasnip jump back one" })

  map(
    { "i", "s" },
    "<C-s>",
    [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']],
    { silent = true, expr = true, desc = "luasnip next choice" }
  )

  -- ----------------------------
  -- |   Convenience Key Maps   |
  -- ----------------------------
  map(
    "n",
    "<leader>ss",
    "<cmd>source ~/.dotfiles/tools/nvim/lua/aiko/snippets/init.lua<CR>",
    { silent = true, desc = "reload snippet configuration" }
  )
  map("n", "<leader>se", function()
    require("luasnip.loaders").edit_snippet_files()
  end, { silent = true, desc = "telescope edit snippets" })

  vim.api.nvim_create_user_command("LuaSnipEdit", function()
    require("luasnip.loaders").edit_snippet_files()
  end, { desc = "telescope edit snippets", force = true })

  -- --------------------------
  -- |   Lazy Load Snippets   |
  -- --------------------------
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load({
    paths = "~/.dotfiles/snips",
  })

  require("luasnip.loaders.from_lua").lazy_load({
    paths = "~/.dotfiles/tools/nvim/lua/aiko/snippets",
  })
end

return M
