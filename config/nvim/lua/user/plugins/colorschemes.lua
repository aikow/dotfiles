MiniDeps.now(function()
  MiniDeps.add({ source = "aikow/base.nvim" })

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
      "plugin.mini",
      "plugin.treesitter",
    },
  })
end)

MiniDeps.now(function()
  MiniDeps.add({ source = "ribru17/bamboo.nvim" })
  MiniDeps.add({ source = "rebelot/kanagawa.nvim" })
  MiniDeps.add({
    source = "catppuccin/nvim",
    name = "catppuccin.nvim",
  })

  require("catppuccin").setup({
    integrations = {
      diffview = true,
    },
  })
end)
