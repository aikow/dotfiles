if vim.fn.has("macunix") == 1 then
  vim.opt.guifont = "JetBrainsMono Nerd Font:h13"
else
  vim.opt.guifont = "JetBrains Mono:h11"
end

vim.g.neovide_refresh_rate = 60
vim.g.neovide_refresh_rate_idle = 60
vim.g.neovide_no_idle = false

vim.g.neovide_transparency = 1.0
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

vim.g.neovide_input_use_logo = false
vim.g.neovide_input_macos_option_key_is_meta = "both"

vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_trail_length = 0.5

-- Reorder PATH environment variable so that venv directory is first.
local path = vim.split(vim.env.PATH, ":", { trimempty = true, plain = true })

local newpath = {}
for _, dir in pairs(path) do
  -- If the directory contains a virtual env path, add it to the front.
  if string.find(dir, "/venv/bin") then
    table.insert(newpath, 1, dir)
  else
    table.insert(newpath, dir)
  end
end

vim.env.PATH = table.concat(newpath, ":")

-- Neovide specific keymaps
vim.keymap.set("n", "<D-v>", '"+p')
vim.keymap.set("i", "<D-v>", "<C-r>+")
