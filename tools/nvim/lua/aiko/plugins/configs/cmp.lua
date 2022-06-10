local M = {}

M.setup = function()
  -- menuone: popup even when there's only one match
  -- noinsert: Do not insert text until a selection is made
  -- noselect: Do not select, force user to select one from the menu
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  -- Avoid showing extra messages when using completion
  vim.opt.shortmess = "filnxtToOFc"

  -- Setup completion framework nvim-cmp.
  local ok_cmp, cmp = pcall(require, "cmp")
  if not ok_cmp then
    return
  end

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
    ["<C-f>"] = {
      i = cmp.mapping.scroll_docs(-4),
      c = cmp.mapping.scroll_docs(-4),
    },
    ["<C-b>"] = {
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
        select = true,
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
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      { name = "crates" },
      { name = "luasnip" },
      { name = "omni" },
    }, {
      { name = "path" },
    }, {
      { name = "buffer", keyword_length = 6 },
    }),
    formatting = {
      format = function(_, vim_item)
        local icons = require("aiko.plugins.configs.lspkind").icons
        vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)

        return vim_item
      end,
    },
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline("@", {
    mapping = mappings,
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
    }, {
      { name = "buffer", keyword_length = 6 },
    }),
  })

  -- Use cmdline & path source for ":"
  cmp.setup.cmdline(":", {
    mapping = mappings,
    sources = cmp.config.sources({
      { name = "cmdline" },
    }, {
      { name = "path" },
    }, {
      { name = "buffer", keyword_length = 6 },
    }),
  })
end

return M
