-- Bootstrap stuff if this is the first time loading neovim on a machine.
if require("aiko.first_load")() then
	return
end

-- Check the host operating system
local has = require("aiko.fn").has
if has("win64") or has("win32") or has("win16") then
	vim.g.os = "Windows"
else
	vim.g.os = vim.fn.substitute(vim.fn.system("uname"), "\n", "", "")
end

require("aiko.plugins")
require("aiko.options")
require("aiko.mappings")

-- ---------------------
-- |   Auto Commands   |
-- ---------------------

local autocmd = require("aiko.utils").autocmd

-- Reload files changed outside of Vim not currently modified in Vim
autocmd("general_autoread", [[FocusGained,BufEnter,WinEnter * silent! edit]], true)
autocmd("general_autowrite", [[FocusLost,WinLeave * silent! noautocmd write]], true)

-- Prevent accidental writes to buffers that shouldn't be edited
autocmd("unmodifiable", {
	[[FileType help set readonly]],
	[[BufRead *.orig set readonly]],
	[[BufRead *.pacnew set readonly]],
})

-- Jump to last edit position on opening file
-- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
autocmd(
	"buf_read_post",
	[[BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
)
-- ===================
-- |=================|
-- ||               ||
-- ||   Functions   ||
-- ||               ||
-- |=================|
-- ===================
--
-- Show the cargo.toml documentation.
vim.api.nvim_create_user_command("ShowDocumentation", function()
	local ft = bo.filetype
	if ft == "vim" or ft == "help" then
		vim.api.nvim_command("help " .. vim.fn.expand("<cword>"))
	elseif ft == "man" then
		vim.api.nvim_command("Man " .. vim.fn.expand("<cword>"))
	elseif vim.fn.expand("%:t") == "Cargo.toml" then
		require("crates").show_popup()
	else
		vim.lsp.buf.hover()
	end
end, { nargs = 0 })

-- --------------------------------
-- |   Cargo.toml and crates.io   |
-- --------------------------------
local cargo_group = vim.api.nvim_create_augroup("cargo_keybindings", {})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = cargo_group,
	pattern = { "Cargo.toml" },
	callback = function()
		local nmap = require("aiko.keymap").nmap
		local opts = {
			silent = true,
			buffer = true,
		}
		nmap("<localleader>t", [[<cmd>lua require("crates").toggle()<CR>]], opts)
		nmap("<localleader>r", [[<cmd>lua require("crates").reload()<CR>]], opts)

		nmap("<localleader>v", [[<cmd>lua require("crates").show_versions_popup()<CR>]], opts)
		nmap("<localleader>f", [[<cmd>lua require("crates").show_features_popup()<CR>]], opts)

		-- Update crates
		nmap("<localleader>u", [[<cmd>lua require("crates").update_crates()<CR>]], opts)
		nmap("<localleader>U", [[<cmd>lua require("crates").update_all_crates()<CR>]], opts)
		nmap("<localleader>g", [[<cmd>lua require("crates").upgrade_crates()<CR>]], opts)
		nmap("<localleader>G", [[<cmd>lua require("crates").upgrade_all_crates()<CR>]], opts)
	end,
	desc = [[Create buffer local keymaps for working with Cargo files]],
})
