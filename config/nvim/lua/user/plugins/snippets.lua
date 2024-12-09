local feedkeys = require("user.util").feedkeys

MiniDeps.later(function()
  MiniDeps.add({
    source = "L3MON4D3/luasnip",
    depends = { "rafamadriz/friendly-snippets" },
    hooks = { post_checkout = function() vim.system({ "make", "install_jsregexp" }) end },
  })

  local types = require("luasnip.util.types")
  local opts = {
    enable_autosnippets = true,
    link_children = true,
    update_events = { "TextChanged", "TextChangedI" },
    delete_check_events = { "TextChanged", "InsertLeave" },
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { " <- Current Choice", "Comment" } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { "●", "Comment" } },
          hl_group = "LuasnipActive",
        },
      },
      [types.snippet] = {
        passive = {
          hl_group = "LuasnipPassive",
        },
      },
    },
  }
  local ls = require("luasnip")

  ls.config.set_config(opts)

  -- -----------------------
  -- |   Trigger Keymaps   |
  -- -----------------------
  vim.keymap.set("i", "<Tab>", function()
    if ls.expand_or_locally_jumpable() then
      ls.expand_or_jump()
    else
      feedkeys("<tab>")
    end
  end, {
    silent = true,
    desc = "luasnip expand or jump forward one, or if neither are avialable, expand tab",
  })

  vim.keymap.set(
    "s",
    "<Tab>",
    function() ls.jump(1) end,
    { silent = true, desc = "luasnip jump forward one" }
  )

  vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    else
      feedkeys("<C-d>")
    end
  end, { silent = true, desc = "luasnip jump back one" })

  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.choice_active() then ls.change_choice(1) end
  end, { silent = true, desc = "luasnip next choice" })

  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.choice_active() then ls.change_choice(-1) end
  end, { silent = true, desc = "luasnip previous choice" })

  vim.api.nvim_create_user_command(
    "LuaSnipEdit",
    function() require("luasnip.loaders").edit_snippet_files({}) end,
    { desc = "telescope edit snippets", force = true }
  )

  ls.filetype_extend("htmldjango", { "html" })

  -- --------------------------
  -- |   Lazy Load Snippets   |
  -- --------------------------
  require("luasnip.loaders.from_vscode").lazy_load({
    exclude = { "tex" },
    default_priority = 100,
  })
  require("luasnip.loaders.from_vscode").lazy_load({
    paths = { "~/.dotfiles/config/snips" },
    default_priority = 100,
  })
  require("luasnip.loaders.from_lua").lazy_load({
    paths = { "./lua/user/luasnip/snips" },
    default_priority = 1000,
  })
end)
