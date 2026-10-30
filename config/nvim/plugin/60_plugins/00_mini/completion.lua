-- ------------------------------------------------------------------------
-- | mini.completion
-- ------------------------------------------------------------------------
safely("later", function()
  require("mini.completion").setup({ lsp_completion = { auto_setup = false } })

  -- Disable MiniCompletion for some filetypes
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user.pack.mini_completion.disable", {}),
    pattern = { "minifiles" },
    desc = "Disable completion for file explorers",
    callback = function() vim.b.minicompletion_disable = true end,
  })
end)

-- ------------------------------------------------------------------------
-- | mini.keymap
-- ------------------------------------------------------------------------
safely("later", function()
  local minikeymap = require("mini.keymap")
  minikeymap.map_multistep("i", "<CR>", { "pmenu_accept" }, { desc = "Accept the completion menu" })
end)

-- ------------------------------------------------------------------------
-- | mini.snippets
-- ------------------------------------------------------------------------
safely("later", function()
  vim.pack.add({
    { src = gh("rafamadriz/friendly-snippets") },
  })

  local minisnippets = require("mini.snippets")

  local langs = {
    latex = { "latex.{json,lua}", "latex/**/*.{json,lua}" },
    -- Add quarto to markdown snippets
    markdown = { "markdown.{json,lua}", "markdown/**/*.{json,lua}" },
  }
  vim.g.minisnippets_lang_patterns = langs

  minisnippets.setup({
    snippets = {
      -- Load custom file with global snippets first
      minisnippets.gen_loader.from_runtime("global.{json,lua}"),
      minisnippets.gen_loader.from_lang({
        lang_patterns = {
          markdown = langs.markdown,
          markdown_inline = langs.markdown,
          plaintext = langs.latex,
          tex = langs.latex,
        },
      }),
    },
  })

  local expand_all = function() minisnippets.expand({ match = false }) end
  vim.keymap.set("i", "<C-g><C-j>", expand_all, { desc = "Expand all snippets" })
end)
