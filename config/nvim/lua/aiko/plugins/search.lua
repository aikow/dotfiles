return {
  -- Find, filter, and search pretty much anything.
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "benfowler/telescope-luasnip.nvim",
    },
    cmd = "Telescope",
    -- stylua: ignore
    keys = {
      {"<leader>i", "<cmd>Telescope resume<CR>",  desc = "telescope reopen last picker" },
      {"<leader>ds", "<cmd>Telescope spell_suggest<CR>",  desc = "telescope spell suggest" },
      -- Finding searching and navigating
      {"<leader>o", "<cmd>Telescope find_files<CR>",  desc = "telescope find files" },
      {"<leader>p", "<cmd>Telescope buffers<CR>",  desc = "telescope buffers" },
      {"<leader>ff", "<cmd>Telescope live_grep<CR>",  desc = "telescope live grep" },
      {"<leader>fw", "<cmd>Telescope grep_string<CR>",  desc = "telescope grep word under cursor" },
      {"<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>",  desc = "telescope buffer fuzzy find" },
      -- Git shortcuts
      {"<leader>go", "<cmd>Telescope git_files<CR>",  desc = "telescope git files" },
      {"<leader>gC", "<cmd>Telescope git_commits<CR>",  desc = "telescope git commits" },
      {"<leader>gc", "<cmd>Telescope git_bcommits<CR>",  desc = "telescope git buffer commits" },
      {"<leader>gb", "<cmd>Telescope git_branches<CR>",  desc = "telescope git branches" },
      {"<leader>gf", "<cmd>Telescope git_status<CR>",  desc = "telescope git status" },
      {"<leader>gh", "<cmd>Telescope git_stash<CR>",  desc = "telescope git stash" },
      -- Setting shortcuts
      {"<leader>;", "<cmd>Telescope commands<CR>",  desc = "telescope vim commands" },
      {"<leader>h/", "<cmd>Telescope search_history<CR>",  desc = "telescope search history" },
      {"<leader>h;", "<cmd>Telescope command_history<CR>",  desc = "telescope command history" },
      {"<leader>ho", "<cmd>Telescope vim_options<CR>",  desc = "telescope vim options" },
      {"<leader>hc", "<cmd>Telescope colorscheme<CR>",  desc = "telescope colorschemes" },
      {"<leader>hh", "<cmd>Telescope help_tags<CR>",  desc = "telescope help tags" },
      {"<leader>hm", "<cmd>Telescope man_pages<CR>",  desc = "telescope man pages" },
      {"<leader>hk", "<cmd>Telescope keymaps<CR>",  desc = "telescope keymaps" },
      {"<leader>hf", "<cmd>Telescope filetypes<CR>",  desc = "telescope filetypes" },
      {"<leader>hs", "<cmd>Telescope luasnip<CR>",  desc = "telescope luasnip snippets" },
      {"<leader>ha", "<cmd>Telescope autocommands<CR>",  desc = "telescope autocommands" },
      {"<leader>ht", "<cmd>Telescope builtin<CR>",  desc = "telescope builtin pickers" },
      {"<leader>hq", "<cmd>Telescope quickfix<CR>",  desc = "telescope quickfix list" },
      {"<leader>hl", "<cmd>Telescope loclist<CR>",  desc = "telescope location list" },
      {"<leader>hp", "<cmd>Telescope reloader<CR>",  desc = "telescope reload lua module" },
    },
    config = function()
      local telescope = require("telescope")
      local themes = require("telescope.themes")
      local actions = require("telescope.actions")
      local actions_layout = require("telescope.actions.layout")

      telescope.setup({
        defaults = {
          prompt_prefix = "> ",
          selection_caret = "> ",
          entry_prefix = "  ",

          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",

          layout_strategy = "flex",
          layout_config = {
            flex = {
              flip_columns = 160,
              flip_lines = 36,
            },
            prompt_position = "top",
            width = 0.87,
            height = 0.80,
          },

          path_display = { "truncate" },

          border = {},
          borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
          -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

          winblend = 0,
          color_devicons = true,
          -- set_env = { ["COLORTERM"] = "truecolor" },

          mappings = {
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,

              -- Scroll through buffer and results.
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-f>"] = actions.preview_scrolling_down,

              ["<C-u>"] = actions.results_scrolling_up,
              ["<C-d>"] = actions.results_scrolling_down,

              ["<C-w>"] = { "<c-s-w>", type = "command" },

              -- Cycle through history.
              ["<C-k>"] = actions.cycle_history_next,
              ["<C-j>"] = actions.cycle_history_prev,

              -- Toggle the preview window.
              ["<C-_>"] = actions_layout.toggle_preview,

              -- Show keybindings.
              ["<C-h>"] = actions.which_key,
            },
            n = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-f>"] = actions.preview_scrolling_down,

              ["<C-u>"] = actions.results_scrolling_up,
              ["<C-d>"] = actions.results_scrolling_down,

              ["<C-_>"] = actions_layout.toggle_preview,

              -- Show keybindings.
              ["<C-h>"] = actions.which_key,

              -- Smart add or send to quick fix list.
              ["Q"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["q"] = actions.smart_add_to_qflist + actions.open_qflist,

              -- Smart add or send to location list.
              ["O"] = actions.smart_send_to_loclist + actions.open_loclist,
              ["o"] = actions.smart_add_to_loclist + actions.open_qflist,
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
          colorscheme = themes.get_dropdown(),
          command_history = themes.get_dropdown(),
          filetypes = themes.get_dropdown(),
          find_files = {
            find_command = {
              "fd",
              "--ignore-file",
              "~/.config/fd/ignore",
              "--hidden",
              "--no-ignore-vcs",
              "--type",
              "f",
              "--strip-cwd-prefix",
            },
          },
          highlights = themes.get_dropdown({ previewer = false }),
          jumplist = themes.get_dropdown(),
          reloader = themes.get_dropdown(),
          search_history = themes.get_dropdown(),
          spell_suggest = themes.get_cursor(),
          vim_options = themes.get_dropdown(),
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("luasnip")
    end,
  },

  -- Native C FZF implementation for searching.
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = true,
    build = "make",
  },

  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<leader>z", "<cmd>FzfLua<CR>" },
      { "<leader>zo", "<cmd>FzfLua files<CR>" },
      { "<leader>zgo", "<cmd>FzfLua git_files<CR>" },
      { "<leader>zff", "<cmd>FzfLua live_grep<CR>" },
      { "<leader>zfg", "<cmd>FzfLua live_grep_glob<CR>" },
    },
  },

  -- Pretty quickfix-like list for diagnostics, loclist, etc.
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- stylua: ignore
    keys = {
      { "]r", function() require("trouble").next({ skip_groups = true, jump = true }) end, desc = "jump to next item, skipping groups", },
      { "[r", function() require("trouble").previous({ skip_groups = true, jump = true }) end, desc = "jump to previous item, skipping groups", },
      { "]R", function() require("trouble").first({ skip_groups = true, jump = true }) end, desc = "jump to first item, skipping groups", },
      { "[R", function() require("trouble").last({ skip_groups = true, jump = true }) end, desc = "jump to last item, skipping groups", },
    },
    cmd = {
      "Trouble",
      "TroubleClose",
      "TroubleToggle",
      "TroubleRefresh",
    },
    config = function()
      require("trouble").setup({})
    end,
  },
}
