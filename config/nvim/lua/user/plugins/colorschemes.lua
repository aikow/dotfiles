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
      "plugin.mason",
      "plugin.mini",
      "plugin.treesitter",
    },
  })
end)

MiniDeps.now(function()
  MiniDeps.add({ source = "ribru17/bamboo.nvim" })
  MiniDeps.add({ source = "catppuccin/nvim", name = "catppuccin.nvim" })
  MiniDeps.add({ source = "rebelot/kanagawa.nvim" })
  MiniDeps.add({ source = "EdenEast/nightfox.nvim" })
  MiniDeps.add({ source = "rose-pine/neovim", name = "rose-pine" })

  require("catppuccin").setup({
    integrations = {
      diffview = true,
      mason = true,
    },
  })
end)
