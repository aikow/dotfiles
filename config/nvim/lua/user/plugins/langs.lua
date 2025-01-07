MiniDeps.later(function()
  vim.g.tex_flavor = "latex"

  vim.g.vimtex_view_method = "zathura"

  vim.g.vimtex_quickfix_mode = 0
  vim.g.vimtex_compiler_method = "latexmk"
  vim.g.vimtex_compiler_latexmk = {
    out_dir = "build",
    callback = 1,
    continuous = 1,
    executable = "latexmk",
    hooks = {},
    options = {
      "-verbose",
      "-file-line-error",
      "-synctex=1",
      "-interaction=nonstopmode",
    },
  }
  MiniDeps.add({
    source = "lervag/vimtex",
  })
end)

MiniDeps.later(function()
  -- Connect to databases inside Neovim.
  MiniDeps.add({ source = "tpope/vim-dadbod" })
end)
