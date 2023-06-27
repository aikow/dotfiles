local feedkeys = require("user.util").feedkeys

return {
  -- Lua snippet engine.
  {
    "L3MON4D3/luasnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    build = "make install_jsregexp",
    config = function()
      local ls = require("luasnip")
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
      })

      -- -----------------------
      -- |   Trigger Keymaps   |
      -- -----------------------

      map("i", "<M-Tab>", function()
        if ls.jumpable() then
          ls.jump(1)
        else
          feedkeys("<tab>")
        end
      end, {
        silent = true,
        desc = "luasnip jump forward one or expand tab",
      })

      map("i", "<Tab>", function()
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

      map({ "i", "s" }, "<C-j>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true, desc = "luasnip next choice" })

      map({ "i", "s" }, "<C-k>", function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end, { silent = true, desc = "luasnip previous choice" })

      map({ "i", "s" }, "<C-u>", function()
        if ls.choice_active() then
          require("luasnip.extras.select_choice")()
        end
      end, { silent = true, desc = "luasnip select choice" })

      vim.api.nvim_create_user_command("LuaSnipEdit", function()
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
        paths = "~/.dotfiles/config/snips",
        default_priority = 100,
      })

      require("luasnip.loaders.from_lua").lazy_load({
        paths = "~/.dotfiles/config/nvim/lua/aiko/luasnip/snips",
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
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-omni",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")

      -- Setup the insert mode completion.
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<tab>"] = cmp.config.disable,
          ["<C-n>"] = {
            i = cmp.mapping.select_next_item({
              behavior = cmp.SelectBehavior.Insert,
            }),
            c = cmp.mapping.select_next_item({
              behavior = cmp.SelectBehavior.Insert,
            }),
          },
          ["<C-p>"] = {
            i = cmp.mapping.select_prev_item({
              behavior = cmp.SelectBehavior.Insert,
            }),
            c = cmp.mapping.select_prev_item({
              behavior = cmp.SelectBehavior.Insert,
            }),
          },
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = {
            i = cmp.mapping.abort(),
            c = cmp.mapping.abort(),
          },
          ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
          ["<CR>"] = {
            i = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = false,
            }),
          },
          ["<M-CR>"] = {
            i = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }),
          },
          ["<C-Space>"] = cmp.mapping({
            i = cmp.mapping.complete(),
            c = function()
              if cmp.visible() then
                if not cmp.confirm({ select = true }) then
                  return
                end
              else
                cmp.complete()
              end
            end,
          }),
        },
        sources = cmp.config.sources({
          { name = "crates" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
        }, {
          { name = "buffer", keyword_length = 5, max_item_count = 10 },
        }),
        completion = {
          --   keyword_length = 1,
        },
        formatting = {
          format = function(_, vim_item)
            local icons = require("user.ui.icons").lsp.kinds
            vim_item.kind =
              string.format("%s %s", icons[vim_item.kind], vim_item.kind)
            return vim_item
          end,
        },
      })

      -- ---------------------------
      -- |   Setup Command Lines   |
      -- ---------------------------
      --
      -- Command mode completions.
      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path" },
        }),
      })
    end,
  },

  {
    "echasnovski/mini.ai",
    opts = {},
  },

  {
    "echasnovski/mini.align",
    keys = { "ga" },
    opts = {},
  },

  {
    "echasnovski/mini.bracketed",
    opts = {
      buffer = { suffix = "b" },
      comment = { suffix = "x" },
      conflict = { suffix = "c" },
      diagnostic = { suffix = "" },
      file = { suffix = "f" },
      indent = { suffix = "" },
      jump = { suffix = "" },
      location = { suffix = "l" },
      oldfile = { suffix = "o" },
      quickfix = { suffix = "q" },
      treesitter = { suffix = "t" },
      undo = { suffix = "" },
      window = { suffix = "w" },
      yank = { suffix = "" },
    },
  },

  {
    "echasnovski/mini.comment",
    keys = {
      { "gc", mode = { "n", "v" } },
      { "gcc" },
    },
    opts = {},
  },

  {
    "echasnovski/mini.pairs",
    enabled = false,
    event = "VeryLazy",
    opts = {},
  },

  {
    "echasnovski/mini.splitjoin",
    keys = { "gz" },
    opts = {
      mappings = {
        toggle = "gz",
      },
    },
  },

  {
    "echasnovski/mini.surround",
    keys = { "gs", "ds", "gsh", "cs" },
    opts = {
      mappings = {
        add = "gs",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "gsh",
        replace = "cs",
        update_n_lines = "",

        suffix_last = "l",
        suffix_next = "n",
      },
      n_lines = 40,
      respect_selection_type = true,
      search_method = "cover_or_next",
    },
  },

  -- Align tabular data.
  {
    "godlygeek/tabular",
    cmd = "Tabularize",
    config = function()
      -- Add tabular pattern to parse latex table with multicolumns
      vim.cmd.AddTabularPattern(
        [[latex_table /\v(\&)|(\\multicolumn(\{[^}]*\}){3})@=/]]
      )
    end,
  },

  -- Highlight todo, fixme, note, perf, etc. comments in buffers.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" },
    event = "BufReadPost",
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    },
    config = function()
      require("todo-comments").setup({
        signs = true,
        sign_priority = 1,
      })
    end,
  },
}
