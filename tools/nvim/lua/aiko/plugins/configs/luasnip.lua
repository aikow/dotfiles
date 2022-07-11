local M = {}

M.setup = function()
  local ok_luasnip, ls = pcall(require, "luasnip")
  if not ok_luasnip then
    return
  end

  local types = require("luasnip.util.types")

  local map = vim.keymap.set

  -- --------------
  -- |   Config   |
  -- --------------
  ls.config.set_config({
    enable_autosnippets = true,
    history = true,
    updateevents = "TextChanged,TextChangedI",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { " <- Current Choice", "NonTest" } },
        },
      },
    },
  })

  -- -----------------------
  -- |   Trigger Keymaps   |
  -- -----------------------
  map({ "i" }, "<M-Tab>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    else
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Tab>", true, true, true),
        "n",
        false
      )
    end
  end, {
    silent = true,
    desc = "luasnip jump forward one or expand tab",
  })

  map({ "i" }, "<Tab>", function()
    -- if ls.expand_or_locally_jumpable() then
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    else
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Tab>", true, true, true),
        "n",
        false
      )
    end
  end, {
    silent = true,
    desc = "luasnip expand or jump forward one, or if neither are avialable, expand tab",
  })

  map("s", "<Tab>", function()
    if ls.jumpable() then
      ls.jump(1)
    end
  end, { silent = true, desc = "luasnip jump forward one" })

  map({ "i", "s" }, "<S-Tab>", function()
    if ls.jumpable() then
      ls.jump(-1)
    end
  end, { silent = true, desc = "luasnip jump back one" })

  map({ "i", "s" }, "<C-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, { silent = true, desc = "luasnip next choice" })

  map({ "i", "s" }, "<C-h>", function()
    if ls.choice_active() then
      ls.change_choice(-1)
    end
  end, { silent = true, desc = "luasnip prev choice" })

  map({ "i", "s" }, "<C-u>", function()
    if ls.choice_active() then
      require("luasnip.extras.select_choice")()
    end
  end, { silent = true, desc = "luasnip select choice" })

  -- ----------------------------
  -- |   Convenience Key Maps   |
  -- ----------------------------
  map(
    "n",
    "<leader>ss",
    "<cmd>source ~/.dotfiles/tools/nvim/lua/aiko/snippets/init.lua<CR>",
    { silent = true, desc = "reload snippet configuration" }
  )
  map(
    "n",
    "<leader>se",
    function() require("luasnip.loaders").edit_snippet_files() end,
    { silent = true, desc = "telescope edit snippets" }
  )

  vim.api.nvim_create_user_command(
    "LuaSnipEdit",
    function() require("luasnip.loaders").edit_snippet_files() end,
    { desc = "telescope edit snippets", force = true }
  )

  -- --------------------------
  -- |   Lazy Load Snippets   |
  -- --------------------------
  require("luasnip.loaders.from_vscode").lazy_load({
    exclude = { "tex" },
    default_priority = 100,
  })
  require("luasnip.loaders.from_vscode").lazy_load({
    paths = "~/.dotfiles/snips",
    default_priority = 100,
  })

  require("luasnip.loaders.from_lua").lazy_load({
    paths = "~/.dotfiles/tools/nvim/snippets",
    default_priority = 1000,
  })
end

return M
