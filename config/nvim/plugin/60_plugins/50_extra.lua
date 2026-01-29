MiniDeps.later(function()
  -- Connect to databases inside Neovim.
  vim.pack.add({
    { src = gh("tpope/vim-dadbod") },
  })
end)

MiniDeps.now(function()
  -- Pretty view markdown files
  vim.pack.add({
    { src = gh("OXY2DEV/markview.nvim") },
  })

  require("markview").setup({
    preview = { enable = false },
  })
end)

MiniDeps.now(function()
  -- Quarto document support
  -- Needs to be loaded now so that it quarto files get probably handled when opening them directly
  -- via a command-line argument to nvim.
  vim.pack.add({
    -- Inline LSP support
    { src = gh("jmbuhr/otter.nvim") },
    { src = gh("quarto-dev/quarto-nvim") },
  })
end)
