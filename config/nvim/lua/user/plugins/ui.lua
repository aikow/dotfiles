MiniDeps.later(function()
  MiniDeps.add({
    source = "lukas-reineke/indent-blankline.nvim",
  })

  require("ibl").setup({
    indent = {
      char = "▏",
    },
    exclude = {
      filetypes = {
        "",
        "help",
        "lspinfo",
        "man",
        "mason",
        "starter",
        "terminal",
      },
      buftypes = {
        "terminal",
      },
    },
  })
end)
