local M = {}

M.setup = function()
  -- Setup completion framework nvim-cmp.
  local ok_cmp, cmp = pcall(require, "cmp")
  if not ok_cmp then
    return
  end
  local compare = require("cmp.config.compare")

  local ok_lspkind, lspkind = pcall(require, "lspkind")
  if not ok_lspkind then
    return
  end

  lspkind.init()

  -- Insert and command mappings.
  local mappings = {
    ["<C-j>"] = {
      i = cmp.mapping.select_next_item(),
      c = cmp.mapping.select_next_item(),
    },
    ["<C-k>"] = {
      i = cmp.mapping.select_prev_item(),
      c = cmp.mapping.select_prev_item(),
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

    -- Confirm/abort/complete mappings
    ["<C-Space>"] = {
      i = cmp.mapping.complete(),
      c = cmp.mapping.complete(),
    },
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<C-y>"] = {
      i = cmp.mapping.confirm({ select = false }),
      c = cmp.mapping.confirm({ select = false }),
    },
    ["<CR>"] = {
      i = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }),
    },
    ["<M-CR>"] = {
      i = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
    },
  }

  -- Setup the insert mode completion.
  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = mappings,
    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1 },
      { name = "crates", priority = 2 },
      { name = "luasnip", priority = 2 },
      { name = "path", priority = 2 },
    }, {
      { name = "buffer", keyword_length = 6, max_item_count = 10 },
    }),
    completion = {
      -- keyword_length = 1,
    },
    sorting = {
      priority_weight = 1.2,
      comparators = {
        compare.locality,
        compare.recently_used,
        compare.score,
        compare.offset,
        compare.length,
        compare.order,
        -- compare.scopes,
        -- compare.sort_text,
        -- compare.exact,
        -- compare.kind,
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
  })

  -- ---------------------------
  -- |   Setup Command Lines   |
  -- ---------------------------
  --
  -- Command mode completions.
  cmp.setup.cmdline(":", {
    mapping = mappings,
    sources = cmp.config.sources({
      { name = "nvim_lua" },
      { name = "cmdline" },
      { name = "path" },
    }),
  })
end

return M
