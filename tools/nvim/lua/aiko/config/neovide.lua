if vim.fn.has("macunix") == 1 then
  vim.opt.guifont = "FiraCode Nerd Font:h13"
else
  vim.opt.guifont = "FiraCode Nerd Font:h11"
end

vim.g.neovide_refresh_rate = 60
vim.g.neovide_refresh_rate_idle = 60
vim.g.neovide_no_idle = false

vim.g.neovide_transparency = 1.0
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

vim.g.neovide_input_use_logo = false
vim.g.neovide_input_macos_alt_is_meta = true

vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_trail_length = 0.5
