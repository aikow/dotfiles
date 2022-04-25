local function setup()
	local actions = require("telescope.actions")
	local actions_layout = require("telescope.actions.layout")
	local telescope = require("telescope")

	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,

					["<C-c>"] = actions.close,

					-- Open selected.
					["<CR>"] = actions.select_default,
					["<C-x>"] = actions.select_horizontal,
					["<C-v>"] = actions.select_vertical,
					["<C-t>"] = actions.select_tab,

					-- Scroll through buffer and results.
					["<C-u>"] = actions.preview_scrolling_up,
					["<C-d>"] = actions.preview_scrolling_down,

					["<C-b>"] = actions.results_scrolling_up,
					["<C-f>"] = actions.results_scrolling_down,

					-- Toggle selection without moving up or down.
					["<C-space>"] = actions.toggle_selection,
					["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
					["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,

					["<C-l>"] = actions.complete_tag,
					["<C-w>"] = { "<c-s-w>", type = "command" },

					-- Cycle through history.
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,

					-- Toggle the preview window.
					["<C-_>"] = actions_layout.toggle_preview,

					-- Show keybindings.
					["<C-h>"] = actions.which_key,

					-- Smart add or send to quick fix list.
					["<C-q><C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					["<C-q>q"] = actions.smart_add_to_qflist + actions.open_qflist,

					-- Smart add or send to location list.
					["<C-l><C-l>"] = actions.smart_send_to_loclist + actions.open_loclist,
					["<C-l>l"] = actions.smart_add_to_loclist + actions.open_loclist,
				},
				n = {
					-- TODO: This would be weird if we switch the ordering.
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["j"] = actions.move_selection_next,
					["k"] = actions.move_selection_previous,

					["H"] = actions.move_to_top,
					["M"] = actions.move_to_middle,
					["L"] = actions.move_to_bottom,
					["gg"] = actions.move_to_top,
					["G"] = actions.move_to_bottom,

					["<esc>"] = actions.close,

					["<CR>"] = actions.select_default,
					["<C-x>"] = actions.select_horizontal,
					["<C-v>"] = actions.select_vertical,
					["<C-t>"] = actions.select_tab,

					-- Toggle selection without moving up or down.
					["<C-space>"] = actions.toggle_selection,
					["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
					["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,

					["<C-u>"] = actions.preview_scrolling_up,
					["<C-d>"] = actions.preview_scrolling_down,

					["<C-b>"] = actions.results_scrolling_up,
					["<C-f>"] = actions.results_scrolling_down,

					["<C-_>"] = actions_layout.toggle_preview,

					-- Show keybindings.
					["<C-h>"] = actions.which_key,

					-- Smart add or send to quick fix list.
					["<C-q><C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					["<C-q>q"] = actions.smart_add_to_qflist + actions.open_qflist,

					-- Smart add or send to location list.
					["<C-l><C-l>"] = actions.smart_send_to_loclist + actions.open_loclist,
					["<C-l>l"] = actions.smart_add_to_loclist + actions.open_loclist,
				},
			},
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--trim",
			},
		},
		pickers = {
			find_files = {
				find_command = {
					"fd",
					"--exclude",
					".git",
					"--hidden",
					"--no-ignore-vcs",
					"--type",
					"f",
					"--strip-cwd-prefix",
				},
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
		},
	})
	-- To get fzf loaded and working with telescope, you need to call
	-- load_extension, somewhere after setup function:
	telescope.load_extension("fzf")

	-- Load ultisnips snippet support.
	telescope.load_extension("ultisnips")
end

return {
	setup = setup,
}
