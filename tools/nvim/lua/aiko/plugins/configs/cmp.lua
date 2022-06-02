local M = {}

M.setup = function()
  -- Set completeopt to have a better completion experience
  -- :help completeopt
  -- menuone: popup even when there's only one match
  -- noinsert: Do not insert text until a selection is made
  -- noselect: Do not select, force user to select one from the menu
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  -- Avoid showing extra messages when using completion
  vim.opt.shortmess = "filnxtToOF"
  vim.opt.shortmess:append("c")

  -- Setup completion framework nvim-cmp.
  local cmp = require("cmp")
  local ok, lspkind = pcall(require, "lspkind")
  if not ok then
    return
  end
  lspkind.init()

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),

      -- Scroll documentation
      ["<C-f>"] = cmp.mapping.scroll_docs(-4),
      ["<C-b>"] = cmp.mapping.scroll_docs(4),

      -- Confirm/abort/complete mappings
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
    },
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
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
    }, {
      { name = "buffer", keyword_length = 6 },
    }),
  })

  -- Use cmdline & path source for ":"
  cmp.setup.cmdline(":", {
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          cmp.mapping.complete()
        end
      end, { "c" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          cmp.mapping.complete()
        end
      end, { "c" }),

      ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
      ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),

      -- Unmap so that they can be used to cycle history.
      ["<C-n>"] = nil,
      ["<C-p>"] = nil,

      -- Scroll documentation
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),

      -- Confirm/abort/complete mappings
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "c" }),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }, { "c" }),
    },
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
