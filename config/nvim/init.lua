-- Set the leader key to the space key
vim.keymap.set("n", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- Set local leader to the backslash
vim.keymap.set("n", [[\]], "<NOP>")
vim.g.maplocalleader = [[\]]

-- Setup config.
require("user").setup()

-- Add the local plugins path to the runtime path.
vim.opt.runtimepath:prepend(vim.fs.normalize("~/.local/config/nvim"))

-- Source the local config if it exists.
local module_ok, module = pcall(require, "local")
if module_ok then
  if type(module) == "table" then
    module.setup()
  else
    vim.notify("Expected the local module to return a table")
  end
end
