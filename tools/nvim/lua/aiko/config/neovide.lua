if vim.fn.has("macunix") == 1 then
  vim.opt.guifont = "FiraCode Nerd Font:h13"
  vim.g.neovide_input_macos_alt_is_meta = true
else
  vim.opt.guifont = "FiraCode Nerd Font:h11"
end
