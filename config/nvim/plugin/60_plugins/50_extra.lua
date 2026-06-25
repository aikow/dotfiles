local on_update = require("user").on_update

safely("later", function()
  -- Connect to databases inside Neovim.
  vim.pack.add({
    { src = gh("tpope/vim-dadbod") },
  })
end)

safely("now", function()
  -- Pretty view markdown files within Neovim.
  vim.pack.add({
    { src = gh("OXY2DEV/markview.nvim") },
  })

  require("markview").setup({
    preview = { enable = false },
  })
end)

safely("later", function()
  -- Live-preview markdown files in the browser.
  on_update('markdown-preview.nvim', function() vim.fn["mkdp#util#install"]() end)

  vim.pack.add({
    { src = gh("iamcco/markdown-preview.nvim") },
  })
end)

safely("now", function()
  -- Quarto document support
  -- Needs to be loaded now so that it quarto files get probably handled when opening them directly
  -- via a command-line argument to nvim.
  vim.pack.add({
    -- Inline LSP support
    { src = gh("jmbuhr/otter.nvim") },
    { src = gh("quarto-dev/quarto-nvim") },
  })
end)
