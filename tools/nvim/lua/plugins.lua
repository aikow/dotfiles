_ = vim.cmd [[packadd packer.nvim]]
_ = vim.cmd [[packadd vimball]]

-- Convenience definitions.
local g = vim.g
local fn = vim.fn
local cmd = vim.cmd
local o, wo, bo = vim.o, vim.wo, vim.bo

local utils = require("utils")

-- For bootstrapping packer local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	vim.notify("Bootstrapping packer")
	local packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

-- =========================
-- |=======================|
-- ||                     ||
-- ||   Include Plugins   ||
-- ||                     ||
-- |=======================|
-- =========================

local packer = require("packer")
local plugins = packer.startup(function(use)
	-- Have packer manage itself
	use("wbthomason/packer.nvim")

	-- ---------------------------------------
	-- |   Language Servers and Completion   |
	-- ---------------------------------------
	--
	-- LSP server for neovim
	use("neovim/nvim-lspconfig")

	-- Completion framework
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			-- Completion sources for nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-omni",
			"quangnguyen30192/cmp-nvim-ultisnips",
		},
		config = function()
			-- Setup completion framework nvim-cmp.
			local cmp = require("cmp")

			cmp.setup({
				-- Enable LSP snippets
				snippet = {
					expand = function(args)
						vim.fn["UltiSnips#Anon"](args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = {
					["<Tab>"] = cmp.mapping(function(fallback)
						if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
							vim.fn["UltiSnips#JumpForwards"]()
						elseif not cmp.visible() and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
							vim.fn["UltiSnips#ExpandSnippet"]()
						elseif cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						print(cmp.visible())
						if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
							vim.fn["UltiSnips#JumpBackwards"]()
						elseif cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end),

					["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
					["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),

					-- Scroll documentation
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-u>"] = cmp.mapping.scroll_docs(4),

					-- Confirm/abort/complete mappings
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "crates" },
					{ name = "ultisnips" },
					{ name = "omni" },
				}, {
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
			})

			-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline("@", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ":"
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "cmdline" },
				}, {
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	})

	-- --------------------------------
	-- |   Telescope and Treesitter   |
	-- --------------------------------
	-- Search
	use({
		{
			"nvim-telescope/telescope.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"telescope-fzf-native.nvim",
				"fhill2/telescope-ultisnips.nvim",
			},
			config = function()
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
			end,
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
		},
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			"nvim-treesitter/nvim-treesitter-refactor",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				-- Ensure that all maintained languages are always installed.
				ensure_installed = "all",
				sync_install = false,
				-- Allow incremental selection using Treesitter code regions.
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<leader>v",
						scope_incremental = "<C-l>",
						node_incremental = "<C-k>",
						node_decremental = "<C-j>",
					},
				},
				-- Enable Treesitter syntax highlighting.
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = "latex",
				},
				refactor = {
					highlight_definitions = {
						enable = true,
						clear_on_custor_move = true,
					},
					smart_rename = {
						enable = true,
						keymaps = {
							smart_rename = "<leader>rr",
						},
					},
				},
			})
		end,
		run = ":TSUpdate",
	})

	-- Enable correct spelling syntax highlighting with Treesitter.
	use({
		"lewis6991/spellsitter.nvim",
		config = function()
			require("spellsitter").setup({
				enable = true,
			})
		end,
	})

	-- Fancy UI which replaces vim.ui.select and vim.ui.input.
	use({ "stevearc/dressing.nvim" })

	-- ---------------------
	-- |   Code Snippets   |
	-- ---------------------
	--
	use({
		"sirver/ultisnips",
		config = function()
			vim.g.UltiSnipsExpandTrigger = "<tab>"
			vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
			vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
		end,
	})

	use({
		"numToStr/Comment.nvim",
		config = function()
			comment = require("Comment")
			comment.setup({
				padding = true,
				sticky = true,
				ignore = nil,
				toggler = {
					line = "gcc",
					block = "gbb",
				},
				opleader = {
					line = "gc",
					block = "gb",
				},
				extra = {
					above = "gcO",
					below = "gco",
					eol = "gcA",
				},
				mappings = {
					basic = true,
					extra = true,
					extended = false,
				},
			})
		end,
	})

	-- -----------------------
	-- |   General Plugins   |
	-- -----------------------
	--
	-- Nice helper plugins
	use({
		"tpope/vim-repeat",
		"tpope/vim-surround",
		"tpope/vim-vinegar",
		"godlygeek/tabular",
		"christoomey/vim-tmux-navigator",
		"airblade/vim-rooter",
		{
			"junegunn/fzf.vim",
			config = function()
				vim.g.fzf_history_dir = vim.fn.expand("~/.local/share/fzf-history")
			end,
		},
	})

	-- ------------------------
	-- |   Language Add-Ons   |
	-- ------------------------
	--
	-- Git
	use({
		{ "tpope/vim-fugitive" },
		{
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("gitsigns").setup({})
			end,
		},
	})

	-- Rust
	use({
		{
			"simrat39/rust-tools.nvim",
			requires = "neovim/nvim-lspconfig",
		},
		{
			"saecki/crates.nvim",
			tag = "v0.1.0",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("crates").setup()
			end,
			ft = { "toml" },
		},
	})

	-- Latex
	use({
		"lervag/vimtex",
		config = function()
			vim.g.tex_flavor = "latex"

			vim.g.vimtex_view_method = "zathura"

			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				build_dir = "build",
				callback = 1,
				continuous = 1,
				executable = "latexmk",
				hooks = {},
				options = {
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}

			vim.api.nvim_create_user_command("LatexSurround", function()
				vim.b["surround" .. vim.fn.char2nr("e")] = [[\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}]]
				vim.b["surround" .. vim.fn.char2nr("c")] = [[\\\1command: \1{\r}]]
			end, { nargs = 0 })
		end,
		ft = { "tex" },
	})
	use({
		"KeitaNakamura/tex-conceal.vim",
		ft = { "tex" },
	})

	-- Markdown
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		ft = { "markdown" },
	})

	-- Fish shell syntax support
	use({
		"dag/vim-fish",
		ft = { "fish" },
	})

	-- --------------------------------
	-- |   Themes and customization   |
	-- --------------------------------
	-- Vim status line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {},
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "fileformat", "filetype", "encoding" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {
					lualine_a = {
						{
							"tabs",
							max_length = vim.o.columns / 3,
							mode = 2,
						},
					},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				extensions = {},
			})
		end,
	})

	-- Colorschemes
	use({
		"joshdick/onedark.vim",
		"arcticicestudio/nord-vim",
		"sainnhe/gruvbox-material",
	})
end)

-- ------------------------
-- |   Bootstrap Packer   |
-- ------------------------
--
-- Automatically set up the configuration after cloning packer.nvim.
if packer_bootstrap then
	packer.compile()
	packer.sync()
end

-- =================================
-- |===============================|
-- ||                             ||
-- ||   Additional Plugin Setup   ||
-- ||                             ||
-- |===============================|
-- =================================

-- -----------------------------
-- |   Setup Language Server   |
-- -----------------------------
--
-- Setup nvim-cmp with lspconfig.
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require("lspconfig")

-- Python language server.
if vim.fn.executable("pyright") == 1 then
	lspconfig.pyright.setup({
		capabilities = capabilities,
		on_attach = function(client, buf_nr)
			-- Create a buffer local command to reformat using black.
			vim.api.nvim_buf_create_user_command(0, "BlackFormat", function()
				vim.api.nvim_command("write")
				vim.api.nvim_command("silent !black " .. vim.api.nvim_buf_get_name(0))
				vim.api.nvim_command("edit")
			end, {})
			-- Create a buffer local keymap to reformat, using the buffer local
			-- command.
			vim.api.nvim_buf_set_keymap(buf_nr, "n", "<leader>rf", "<cmd>BlackFormat<CR>", { silent = true })
		end,
	})
end

-- CPP and C server
if vim.fn.executable("clangd") == 1 then
	lspconfig.clangd.setup({
		capabilities = capabilities,
	})
end

-- YAML language server
if vim.fn.executable("yaml-language-server") == 1 then
	lspconfig.yamlls.setup({
		capabilities = capabilities,
	})
end

-- Bash language server
if vim.fn.executable("bash-language-server") == 1 then
	lspconfig.bashls.setup({
		capabilities = capabilities,
	})
end

-- Setup rust LSP separately, since rust-tools overwrites the LSP server.
if vim.fn.executable("rust-analyzer") == 1 then
	require("rust-tools").setup({
		tools = { -- rust-tools options
			autoSetHints = true, -- Automatically set inlay hints
			hover_with_actions = true, -- Show action inside the hover menu
			inlay_hints = {
				show_parameter_hints = true, -- Show parameter hints
				parameter_hints_prefix = "<- ",
				other_hints_prefix = "=> ",
			},
		},
		-- These override the defaults set by rust-tools.nvim.
		-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
		server = {
			capabilities = capabilities,
			settings = {
				-- to enable rust-analyzer settings visit:
				-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
				["rust-analyzer"] = {
					-- enable clippy on save
					checkOnSave = {
						command = "clippy",
					},
					procMacro = {
						enable = true,
					},
				},
			},
		},
	})
end

-- Automaticaclly recompile packer plugins.
vim.api.nvim_create_augroup("packer_user_config", {})
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "plugins.lua",
	command = "source <afile> | PackerCompile",
	group = "packer_user_config",
})

return plugins
