-- Set the leader key to the space key
vim.keymap.set("n", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- Set local leader to the backslash
vim.keymap.set("n", [[\]], "<NOP>")
vim.g.maplocalleader = [[\]]

-- Setup config.
require("user").setup()

-- Add the local plugins path to the runtime path.
vim.opt.runtimepath:append(vim.fs.normalize("~/.local/config/nvim/after"))
