local feedkeys = require("user.util").feedkeys

return {
  -- Lua snippet engine.
  {
    "L3MON4D3/luasnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    build = "make install_jsregexp",
    opts = function()
      local types = require("luasnip.util.types")

      return {
        enable_autosnippets = true,
        link_children = true,
        update_events = { "TextChanged", "TextChangedI" },
        region_check_events = { "CursorHold" },
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
    end,
    config = function(_, opts)
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
        exclude = { "tex", "norg" },
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
    end,
  },

  -- ------------------
  -- |   Completion   |
  -- ------------------
  --
  -- These are all loaded dependencies nvim-cmp.
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")

      -- Setup the insert mode completion.
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup({
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = {
          ["<tab>"] = cmp.config.disable,
          ["<S-tab>"] = cmp.config.disable,
          ["<C-n>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
          ["<C-p>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
          }),
          ["<M-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
          ["<C-Space>"] = cmp.mapping.complete(),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer", keyword_length = 5, max_item_count = 10 },
        }),
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = function(_, vim_item)
            local icon = require("mini.icons").get('lsp', vim_item.kind)
            vim_item.kind = string.format("%s %s", icon, vim_item.kind)
            return vim_item
          end,
        },
      })
    end,
  },
}
