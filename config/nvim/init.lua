-- Set the leader key to the space key
vim.keymap.set("n", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- Set local leader to the backslash
vim.keymap.set("n", [[\]], "<NOP>")
vim.g.maplocalleader = [[\]]

vim.g.localcfg = vim.fs.normalize("~/.local/config/nvim")
vim.g.localrtp = vim.g.localcfg .. "/after"
vim.g.localrc = vim.g.localcfg .. "/local.lua"

-- Setup config.
require("user").setup()

-- All modifications to the runtimepath happen here.
vim.opt.runtimepath:append(vim.fs.normalize("~/.dotfiles/config/snippets"))
vim.opt.runtimepath:append(vim.g.localrtp)
vim.o.exrc = true

-- Manually source the local config file if it exists.
if vim.uv.fs_stat(vim.g.localrc) then vim.cmd.source({ vim.g.localrc }) end
