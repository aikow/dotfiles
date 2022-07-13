local M = {}

M.setup = function()
  vim.g.tex_flavor = "latex"

  vim.g.vimtex_view_method = "zathura"

  vim.g.vimtex_quickfix_mode = 0
  vim.g.vimtex_compiler_method = "latexmk"
  vim.g.vimtex_compiler_latexmk = {
    build_dir = "build",
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

  vim.api.nvim_create_user_command("LatexSurround", function()
    vim.b["surround" .. vim.fn.char2nr("e")] =
      [[\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}]]
    vim.b["surround" .. vim.fn.char2nr("c")] = [[\\\1command: \1{\r}]]
  end, { nargs = 0 })
end

return M
