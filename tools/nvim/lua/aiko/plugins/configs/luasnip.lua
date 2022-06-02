local M = {}

M.setup = function()
	local map = vim.keymap.set
	local luasnip = require("luasnip")

	luasnip.config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
	})

	map({ "i" }, "<Tab>", "<Plug>luasnip-expand-or-jump", { silent = true, expr = true })
	map("s", "<Tab>", function()
		require("luasnip").jump(1)
	end, { silent = true })
	map("i", "<S-Tab>", function()
		require("luasnip").jump(-1)
	end, { silent = true })
	map("s", "<S-Tab>", function()
		require("luasnip").jump(-1)
	end, { silent = true })

	map(
		{ "i", "s" },
		"<C-s>",
		[[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']],
		{ silent = true, expr = true }
	)

	require("luasnip.loaders.from_vscode").lazy_load()
end

return M
