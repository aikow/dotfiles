MiniDeps.later(function()
  -- Connect to databases inside Neovim.
  MiniDeps.add({ source = "tpope/vim-dadbod" })
end)

MiniDeps.now(function()
  -- Pretty view markdown files
  MiniDeps.add({ source = "OXY2DEV/markview.nvim" })
  require("markview").setup({
    preview = { enable = false },
  })
end)

MiniDeps.now(function()
  -- Inline LSP support
  MiniDeps.add({ source = "jmbuhr/otter.nvim" })
end)

MiniDeps.now(function()
  -- Quarto document support
  -- Needs to be loaded now so that it quarto files get probably handled when opening them directly
  -- via a command-line argument to nvim.
  MiniDeps.add({ source = "quarto-dev/quarto-nvim" })
  require("quarto").setup()
end)
