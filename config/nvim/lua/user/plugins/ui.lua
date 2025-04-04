MiniDeps.later(function()
  MiniDeps.add({
    source = "lukas-reineke/indent-blankline.nvim",
  })

  require("ibl").setup({
    indent = {
      char = "▏",
    },
  })
end)
