MiniDeps.now(function()
  vim.pack.add({
    { src = gh("aikow/base.nvim") },
    { src = gh("ribru17/bamboo.nvim") },
    { src = gh("catppuccin/nvim"), name = "catppuccin.nvim" },
    { src = gh("rebelot/kanagawa.nvim") },
    { src = gh("EdenEast/nightfox.nvim") },
    { src = gh("rose-pine/neovim"), name = "rose-pine" },
  })

  require("base").setup({
    integrations = {
      "builtin.defaults",
      "builtin.git",
      "builtin.lsp",
      "builtin.semantic",
      "builtin.syntax",
      "builtin.terminal",
      "builtin.treesitter",
      "plugin.indent-blankline",
      "plugin.mason",
      "plugin.mini",
      "plugin.treesitter",
    },
  })

  require("catppuccin").setup({
    integrations = {
      diffview = true,
      mason = true,
    },
  })
end)
