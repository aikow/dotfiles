local M = {}

M.setup = function()
  -- Setup completion framework nvim-cmp.
  local ok_cmp, cmp = pcall(require, "cmp")
  if not ok_cmp then
    return
  end

  -- Setup icons for completion menu depending on the completion source.
  local ok_lspkind, lspkind = pcall(require, "lspkind")
  if not ok_lspkind then
    return
  end

  lspkind.init()

  -- Setup the insert mode completion.
  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<tab>"] = cmp.config.disable,

      -- Select mappings
      ["<C-j>"] = {
        i = cmp.mapping.select_next_item(),
        c = cmp.mapping.select_next_item(),
      },
      ["<C-k>"] = {
        i = cmp.mapping.select_prev_item(),
        c = cmp.mapping.select_prev_item(),
      },
      ["<C-n>"] = {
        i = cmp.mapping.select_next_item(),
      },
      ["<C-p>"] = {
        i = cmp.mapping.select_prev_item(),
      },

      -- Scroll documentation
      ["<C-b>"] = {
        i = cmp.mapping.scroll_docs(-4),
        c = cmp.mapping.scroll_docs(-4),
      },
      ["<C-f>"] = {
        i = cmp.mapping.scroll_docs(4),
        c = cmp.mapping.scroll_docs(4),
      },

      -- Close the completion menu
      ["<C-c>"] = cmp.mapping.abort(),

      -- Confirm completions
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

      -- Open the completion menu.
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
      { name = "gh_issues" },

      { name = "nvim_lua" },

      { name = "nvim_lsp" },

      { name = "path" },
      { name = "luasnip" },
    }, {
      { name = "buffer", keyword_length = 5, max_item_count = 10 },
    }),
    -- completion = {
    --   keyword_length = 1,
    -- },
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        -- Sort entries by their words after the underscore.
        function(entry1, entry2)
          local _, entry1_under = entry1.completion_item.label:find("^_+")
          local _, entry2_under = entry2.completion_item.label:find("^_+")
          entry1_under = entry1_under or 0
          entry2_under = entry2_under or 0
          if entry1_under > entry2_under then
            return false
          elseif entry1_under < entry2_under then
            return true
          end
        end,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    formatting = {
      format = function(_, vim_item)
        local icons = require("aiko.plugins.configs.lspkind").icons
        vim_item.kind =
          string.format("%s %s", icons[vim_item.kind], vim_item.kind)

        return vim_item
      end,
    },
    -- window = {
    --   completion = cmp.config.window.bordered(),
    --   documentation = cmp.config.window.bordered(),
    -- },
    -- experimental = {
    --   native_menu = false,
    -- },
  })

  -- ---------------------------
  -- |   Setup Command Lines   |
  -- ---------------------------
  --
  -- Command mode completions.
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "nvim_lua" },
      { name = "cmdline" },
      { name = "path" },
    }),
  })
end

return M
