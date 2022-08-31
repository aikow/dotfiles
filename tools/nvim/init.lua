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

-- Source the local before-config file that will get to run in order to set
-- variables for the rest of the config.
local local_config_before = vim.fn.expand([[$LOCAL_CONFIG/nvim-before.lua]])
if vim.fn.filereadable(local_config_before) == 1 then
  vim.cmd.source(local_config_before)
end

-- Setup config.
require("aiko").setup()

-- Source the local config if it exists.
local local_config = vim.fn.expand([[$LOCAL_CONFIG/nvim.lua]])
if vim.fn.filereadable(local_config) == 1 then
  vim.cmd.source(local_config)
end
