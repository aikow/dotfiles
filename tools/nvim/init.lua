-- Check the host operating system
local has = require("aiko.fn").has
if has("win64") or has("win32") or has("win16") then
	vim.g.os = "Windows"
else
	vim.g.os = vim.fn.substitute(vim.fn.system("uname"), "\n", "", "")
end

-- Bootstrap stuff if this is the first time loading neovim on a machine.
if require("aiko.first_load")() then
	return
end

-- -----------------------
-- |   Python Provider   |
-- -----------------------
-- Setup python provider
require("aiko.provider").setup_python()

-- ------------------------------
-- |   Leader and Localleader   |
-- ------------------------------
local map = vim.keymap.set
-- Set the leader key to the space key
map("n", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- Set local leader to the backslash
map("n", [[\]], "<NOP>")
vim.g.maplocalleader = [[\]]

-- Setup plugins, options and keymaps
require("aiko.plugins")

-- ---------------------
-- |   Auto Commands   |
-- ---------------------
local autocmd = require("aiko.utils").autocmd

-- Reload files changed outside of Vim not currently modified in Vim
autocmd("general_autoread", {
	event = { "FocusGained", "BufEnter", "WinEnter" },
	callback = function()
		if vim.api.nvim_buf_get_option(0, "buftype") ~= "" then
			return
		end
		vim.api.nvim_command("silent! edit")
	end,
  desc = "perform a read when entering a new buffer"
})
autocmd("general_autowrite", {
	event = { "FocusLost", "WinLeave" },
	callback = function()
		if vim.api.nvim_buf_get_option(0, "buftype") ~= "" then
			return
		end
		vim.api.nvim_command("silent! noautocmd write")
	end,
  desc = "perform a write when leaving the current buffer"
})

-- Prevent accidental writes to buffers that shouldn't be edited
autocmd("unmodifiable", {
	{ event = "FileType", pattern = "help", command = "setlocal readonly" },
	{ event = "BufRead", pattern = "*.orig", command = "setlocal readonly" },
	{ event = "BufRead", pattern = "*.pacnew", command = "setlocal readonly" },
})

-- Jump to last edit position on opening file
-- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
autocmd("buf_read_post", {
	event = "BufReadPost",
	callback = function()
		local regex = vim.regex([[/\.git/]])
		if
			not regex:match_str(vim.fn.expand("%:p"))
			and vim.fn.line([['"]]) > 1
			and vim.fn.line([['"]]) <= vim.fn.line("$")
		then
			vim.cmd([[exe "normal! g'\""]])
		end
	end,
})

-- --------------------------------
-- |   Cargo.toml and crates.io   |
-- --------------------------------
local cargo_group = vim.api.nvim_create_augroup("cargo_keybindings", {})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = cargo_group,
	pattern = { "Cargo.toml" },
	callback = function()
		local opts = function(desc)
			return {
				silent = true,
				buffer = true,
				desc = desc or "",
			}
		end
		map("n", "<localleader>t", crates.toggle, opts("crates toggle menu"))
		map("n", "<localleader>r", crates.reload, opts("crates reload source"))

		map("n", "<localleader>v", crates.show_versions_popup, opts("crates show versions popup"))
		map("n", "<localleader>f", crates.show_features_popup, opts("crates show features popup"))

		-- Update crates
		map("n", "<localleader>u", crates.update_crates, opts("crates update"))
		map("n", "<localleader>U", crates.update_all_crates, opts("crates update all"))
		map("n", "<localleader>g", crates.upgrade_crates, opts("crates upgrade"))
		map("n", "<localleader>G", crates.upgrade_all_crates, opts("crates upgrade all"))
	end,
	desc = [[Create buffer local keymaps for working with Cargo files]],
})
