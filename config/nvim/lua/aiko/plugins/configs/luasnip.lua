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
    update_events = "TextChanged,TextChangedI",
    region_check_events = "CursorHold",
    delete_check_events = "TextChanged,InsertLeave",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { " <- Current Choice", "NonTest" } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { "●", "Comment" } },
        },
      },
    },
  })

  -- -----------------------
  -- |   Trigger Keymaps   |
  -- -----------------------
  local feedkeys = function(keys)
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(keys, true, true, true),
      "n",
      false
    )
  end

  map({ "i" }, "<M-Tab>", function()
    if ls.jumpable() then
      ls.jump(1)
    else
      feedkeys("<tab>")
    end
  end, {
    silent = true,
    desc = "luasnip jump forward one or expand tab",
  })

  map({ "i" }, "<Tab>", function()
    if ls.expand_or_locally_jumpable() then
      if ls.expandable() then
        -- Set an undo breakpoint
        feedkeys("<c-g>u")
      end

      ls.expand_or_jump()
    else
      feedkeys("<tab>")
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
    "<cmd>source ~/.dotfiles/config/nvim/lua/aiko/snippets/init.lua<CR>",
    { silent = true, desc = "reload snippet configuration" }
  )
  map("n", "<leader>se", function()
    require("luasnip.loaders").edit_snippet_files({})
  end, { silent = true, desc = "telescope edit snippets" })

  vim.api.nvim_create_user_command("LuasnipEdit", function()
    require("luasnip.loaders").edit_snippet_files({})
  end, { desc = "telescope edit snippets", force = true })

  -- --------------------------
  -- |   Lazy Load Snippets   |
  -- --------------------------
  require("luasnip.loaders.from_vscode").lazy_load({
    exclude = { "tex", "norg" },
    default_priority = 100,
  })
  require("luasnip.loaders.from_vscode").lazy_load({
    paths = "~/.dotfiles/snips",
    default_priority = 100,
  })

  require("luasnip.loaders.from_lua").lazy_load({
    paths = "~/.dotfiles/config/nvim/lua/aiko/luasnip/snips",
    default_priority = 1000,
  })
end

return M
