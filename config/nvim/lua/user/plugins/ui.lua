return {
  -- Show indentation.
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        indent = {
          char = "▏",
        },
        exclude = {
          filetypes = {
            "",
            "Outline",
            "TelescopePrompt",
            "TelescopeResults",
            "help",
            "lazy",
            "lspinfo",
            "man",
            "mason",
            "norg",
            "starter",
            "terminal",
          },
          buftypes = {
            "terminal",
          },
        },
      })
    end,
  },
}
