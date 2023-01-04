-- Set the leader key to the space key
vim.keymap.set("n", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- Set local leader to the backslash
vim.keymap.set("n", [[\]], "<NOP>")
vim.g.maplocalleader = [[\]]

-- Setup config.
require("aiko").setup()

-- Source the local config if it exists.
local local_config = vim.fn.expand([[$LOCAL_CONFIG/nvim.lua]])
if vim.fn.filereadable(local_config) == 1 then
  vim.cmd.source(local_config)
end
