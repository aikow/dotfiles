-- Set the leader key to the space key
vim.keymap.set("n", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- Set local leader to the backslash
vim.keymap.set("n", [[\]], "<NOP>")
vim.g.maplocalleader = [[\]]

-- Setup config.
require("user").setup()

-- Source the local config if it exists.
local module_ok, module = pcall(require, "user.local")
if module_ok then
  if type(module) == "table" then
    module.setup()
  else
    vim.notify("Expected the local module to return a table")
  end
end
