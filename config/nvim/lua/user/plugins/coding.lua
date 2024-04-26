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
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
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
          { name = "path" },
          { name = "luasnip" },
          { name = "git" },
        }, {
          { name = "buffer", keyword_length = 5, max_item_count = 10 },
        }),
        ---@diagnostic disable-next-line: missing-fields
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
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline(":", {
        -- mapping = cmp.mapping.preset.cmdline(),
        mapping = {
          ["<Tab>"] = {
            c = function()
              if cmp.visible() then
                cmp.select_next_item()
              else
                cmp.complete()
              end
            end,
          },
          ["<S-Tab>"] = {
            c = function()
              if cmp.visible() then
                cmp.select_prev_item()
              else
                cmp.complete()
              end
            end,
          },
          ["<C-e>"] = { c = cmp.mapping.abort() },
          ["<C-y>"] = { c = cmp.mapping.confirm({ select = false }) },
        },
        sources = cmp.config.sources(
          { { name = "cmdline" } },
          { { name = "path" } }
        ),
      })
    end,
  },

  {
    "echasnovski/mini.ai",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = function()
      local spec_treesitter = require("mini.ai").gen_spec.treesitter
      return {
        custom_textobjects = {
          i = spec_treesitter({
            a = "@conditional.outer",
            i = "@conditional.inner",
          }),
          l = spec_treesitter({ a = "@loop.outer", i = "@loop.inner" }),
          m = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
          o = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
          x = spec_treesitter({ a = "@comment.outer", i = "@comment.inner" }),
        },
      }
    end,
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
      oldfile = { suffix = "" },
      quickfix = { suffix = "q" },
      treesitter = { suffix = "r" },
      undo = { suffix = "" },
      window = { suffix = "w" },
      yank = { suffix = "" },
    },
  },

  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = {
        insert = true,
        command = false,
        terminal = false,
      },
      mappings = {
        -- [["#$%&'()*+,-./:;<=>?@[\]^_`{|}~]]

        ["("] = { action = "open", pair = "()", neigh_pattern = ".[%s)]" },
        ["["] = {
          action = "open",
          pair = "[]",
          neigh_pattern = ".[%s%]]",
        },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = ".[%s}]" },

        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

        ['"'] = {
          action = "closeopen",
          pair = '""',
          neigh_pattern = ".%s",
          register = { cr = false },
        },
        ["'"] = {
          action = "closeopen",
          pair = "''",
          neigh_pattern = "%s%s",
          register = { cr = false },
        },
        ["`"] = {
          action = "closeopen",
          pair = "``",
          neigh_pattern = ".%s",
          register = { cr = false },
        },
      },
    },
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
        update_n_lines = "gsu",

        suffix_last = "",
        suffix_next = "",
      },
      n_lines = 40,
      respect_selection_type = true,
      search_method = "cover_or_next",
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.keymap.set(
        "x",
        "gs",
        [[:<C-u>lua MiniSurround.add('visual')<CR>]],
        { silent = true }
      )
      vim.keymap.set("n", "gss", "gs_", { remap = true })
    end,
  },

  -- Align tabular data.
  {
    "godlygeek/tabular",
    cmd = "Tabularize",
    config = function()
      -- Add tabular pattern to parse latex table with multicolumns
      vim.cmd.AddTabularPattern({
        "latex_table",
        [[/\v(\&)|(\\multicolumn(\{[^}]*\}){3})@=/]],
      })
    end,
  },

  {
    "echasnovski/mini.hipatterns",
    config = function(_, opts)
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup(vim.tbl_deep_extend("force", opts, {
        highlighters = {
          fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
          hack = { pattern = "HACK", group = "MiniHipatternsHack" },
          perf = { pattern = "PERF", group = "MiniHipatternsPerf" },
          todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
          note = { pattern = "NOTE", group = "MiniHipatternsNote" },

          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }))
    end,
    init = function()
      vim.api.nvim_set_hl(
        0,
        "MiniHipatternsPerf",
        { default = true, link = "DiagnosticHint" }
      )
    end,
  },
}
