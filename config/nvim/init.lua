-- Set the leader key to the space key
vim.keymap.set("n", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- Set local leader to the backslash
vim.keymap.set("n", [[\]], "<NOP>")
vim.g.maplocalleader = [[\]]

-- Setup config.
require("aiko").setup()

-- Source the local config, if it exists.
local ok_local, local_config = pcall(require, "aiko.local")
if ok_local then
  local_config.setup()
end
