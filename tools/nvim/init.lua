local ok_impatient, impatient = pcall(require, "impatient")
if ok_impatient then
  impatient.enable_profile()
end

-- Set the leader key to the space key
vim.keymap.set("n", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- Set local leader to the backslash
vim.keymap.set("n", [[\]], "<NOP>")
vim.g.maplocalleader = [[\]]

-- Setup config.
require("aiko").setup()
