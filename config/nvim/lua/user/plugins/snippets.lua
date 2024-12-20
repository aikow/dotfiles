local feedkeys = require("user.util").feedkeys

MiniDeps.now(function()
  MiniDeps.add({
    source = "L3MON4D3/luasnip",
    hooks = {
      post_checkout = function(params)
        vim.system({ "make", "install_jsregexp" }, { cwd = params.path }):wait()
      end,
    },
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

  require("luasnip").config.set_config(opts)
end)

MiniDeps.later(function()
  local ls = require("luasnip")

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
    desc = "luasnip expand or jump forward",
  })

  vim.keymap.set("s", "<Tab>", function() ls.jump(1) end, { desc = "luasnip jump forward" })

  vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    else
      feedkeys("<C-d>")
    end
  end, { desc = "luasnip jump back" })

  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.choice_active() then ls.change_choice(1) end
  end, { desc = "luasnip next choice" })

  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.choice_active() then ls.change_choice(-1) end
  end, { desc = "luasnip previous choice" })

  vim.api.nvim_create_user_command(
    "LuaSnipEdit",
    require("luasnip.loaders").edit_snippet_files,
    { desc = "luasnip edit snippets" }
  )

  -- --------------------------
  -- |   Lazy Load Snippets   |
  -- --------------------------
  ls.filetype_extend("htmldjango", { "html" })

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
