-- Set the leader key to the space key
vim.keymap.set("n", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- Set local leader to the backslash
vim.keymap.set("n", [[\]], "<NOP>")
vim.g.maplocalleader = [[\]]

-- Local configuration files
vim.g.localrtp = vim.fs.normalize("~/.local/config/nvim")
vim.g.localrtp_after = vim.g.localrtp .. "/after"
vim.g.localrc = vim.g.localrtp .. "/local.lua"

-- Setup Globals
_G.gh = function(repo) return "https://github.com/" .. repo end

-- Init mini.deps so that we can use the later() and now() helpers
vim.pack.add({ gh("nvim-mini/mini.nvim") })
require("mini.deps").setup()

-- All modifications to the runtimepath happen here.
vim.opt.runtimepath:append(vim.fs.normalize("~/.dotfiles/config/snippets"))
vim.opt.runtimepath:prepend(vim.g.localrtp)
vim.opt.runtimepath:append(vim.g.localrtp_after)
vim.o.exrc = true

-- Manually source the local config file if it exists.
if vim.uv.fs_stat(vim.g.localrc) then vim.cmd.source({ vim.g.localrc }) end
