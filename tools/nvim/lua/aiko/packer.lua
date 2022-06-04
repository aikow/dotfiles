local M = {}

M.bootstrap = function()
	-- Convenience definitions.
	local fn = vim.fn

	-- For bootstrapping packer local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		vim.notify("Bootstrapping packer")
		fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})

		vim.cmd("packadd packer.nvim")
		require("plugins")
		vim.cmd("PackerSync ")
	end
end

M.run = function()
	local present, packer = pcall(require, "packer")

	if not present then
		return
	end

	local plugins = require("aiko.plugins").plugins

	packer.init({
		auto_clean = true,
		compile_on_sync = true,
		git = { clone_timeout = 10 },
		display = {
			open_cmd = "80vnew \\[packer\\]",
		},
	})
	packer.startup(plugins)
end

return M
