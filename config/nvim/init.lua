-- Set the leader key to the space key
vim.keymap.set("n", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- Set local leader to the backslash
vim.keymap.set("n", [[\]], "<NOP>")
vim.g.maplocalleader = [[\]]

-- Add local config to the runtimepath.
vim.opt.runtimepath:prepend(vim.fs.normalize("~/.local/config/nvim"))

-- Setup config.
require("aiko").setup()

-- FIXME: Lazy overrides the runtimepath somehow.
vim.opt.runtimepath:prepend(vim.fs.normalize("~/.local/config/nvim"))

-- Source the local config if it exists.
pcall(require, "aiko.local")
