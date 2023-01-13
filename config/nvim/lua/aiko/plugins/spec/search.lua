return {
  -- -----------------
  -- |   Telescope   |
  -- -----------------
  --
  -- Find, filter, and search pretty much anything.
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "benfowler/telescope-luasnip.nvim",
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
          set_env = { ["COLORTERM"] = "truecolor" },

          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              -- Scroll through buffer and results.
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-f>"] = actions.preview_scrolling_down,

              ["<C-u>"] = actions.results_scrolling_up,
              ["<C-d>"] = actions.results_scrolling_down,

              -- Toggle selection without moving up or down.
              ["<C-space>"] = actions.toggle_selection,
              ["<Tab>"] = actions.toggle_selection
                + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection
                + actions.move_selection_better,

              ["<C-l>"] = actions.complete_tag,
              ["<C-w>"] = { "<c-s-w>", type = "command" },

              -- Cycle through history.
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,

              -- Toggle the preview window.
              ["<C-_>"] = actions_layout.toggle_preview,

              -- Show keybindings.
              ["<C-h>"] = actions.which_key,
            },
            n = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              -- Toggle selection without moving up or down.
              ["<C-space>"] = actions.toggle_selection,
              ["<Tab>"] = actions.toggle_selection
                + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection
                + actions.move_selection_better,

              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-f>"] = actions.preview_scrolling_down,

              ["<C-u>"] = actions.results_scrolling_up,
              ["<C-d>"] = actions.results_scrolling_down,

              ["<C-_>"] = actions_layout.toggle_preview,

              -- Show keybindings.
              ["<C-h>"] = actions.which_key,

              -- Smart add or send to quick fix list.
              ["Q"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["q"] = actions.smart_add_to_qflist,

              -- Smart add or send to location list.
              ["O"] = actions.smart_send_to_loclist + actions.open_loclist,
              ["o"] = actions.smart_add_to_loclist,
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

      -- ---------------
      -- |   Keymaps   |
      -- ---------------
      local map = vim.keymap.set

      map("n", "<leader>i", function()
        require("telescope.builtin").resume()
      end, {
        silent = true,
        desc = "telescope reopen last telescope window",
      })

      map("n", "<leader>do", function()
        require("telescope.builtin").diagnostics()
      end, { silent = true, desc = "telescope open diagnostics" })

      map("n", "<leader>ls", function()
        require("telescope.builtin").spell_suggest()
      end, { silent = true, desc = "telescope spell suggest" })

      map("n", "<leader>lf", function()
        require("telescope.builtin").treesitter()
      end, { silent = true, desc = "telescope treesitter" })

      map("n", "<leader>ld", function()
        require("telescope.builtin").lsp_definitions()
      end, { silent = true, desc = "telescope lsp list definitions" })

      map("n", "<leader>lr", function()
        require("telescope.builtin").lsp_references()
      end, { silent = true, desc = "telescope lsp list references" })

      map("n", "<leader>li", function()
        require("telescope.builtin").lsp_implementations()
      end, { silent = true, desc = "telescope lsp list implementations" })

      map("n", "<leader>lt", function()
        require("telescope.builtin").lsp_type_definitions()
      end, { silent = true, desc = "telescope lsp list type definitions" })

      map("n", "<leader>lw", function()
        require("telescope.builtin").lsp_workspace_symbols()
      end, {
        silent = true,
        desc = "telescope lsp list workspace symbols",
      })

      map("n", "<leader>lW", function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end, {
        silent = true,
        desc = "telescope lsp list dynamic workspace symbols",
      })

      map("n", "<leader>ls", function()
        require("telescope.builtin").lsp_document_symbols()
      end, { silent = true, desc = "telescope lsp list document symbols" })

      -- Finding searching and navigating
      map("n", "<leader>;", function()
        require("telescope.builtin").commands()
      end, { silent = true, desc = "telescope vim commands" })

      map("n", "<leader>h/", function()
        require("telescope.builtin").search_history()
      end, { silent = true, desc = "telescope search history" })

      map("n", "<leader>h;", function()
        require("telescope.builtin").command_history()
      end, { silent = true, desc = "telescope command history" })

      map("n", "<leader>o", function()
        require("telescope.builtin").find_files()
      end, { silent = true, desc = "telescope find files" })

      map("n", "<leader>p", function()
        require("telescope.builtin").buffers()
      end, { silent = true, desc = "telescope buffers" })

      -- Find shortcuts
      map("n", "<leader>ff", function()
        require("telescope.builtin").live_grep()
      end, { silent = true, desc = "telescope live grep" })

      map("n", "<leader>fw", function()
        require("telescope.builtin").grep_string()
      end, { silent = true, desc = "telescope grep word under cursor" })

      map("n", "<leader>fb", function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end, { silent = true, desc = "telescope buffer fuzzy find" })

      -- Git shortcuts
      map("n", "<leader>go", function()
        require("telescope.builtin").git_files()
      end, { silent = true, desc = "telescope git files" })

      map("n", "<leader>gC", function()
        require("telescope.builtin").git_commits()
      end, { silent = true, desc = "telescope git commits" })

      map("n", "<leader>gc", function()
        require("telescope.builtin").git_bcommits()
      end, { silent = true, desc = "telescope git buffer commits" })

      map("n", "<leader>gb", function()
        require("telescope.builtin").git_branches()
      end, { silent = true, desc = "telescope git branches" })

      map("n", "<leader>gf", function()
        require("telescope.builtin").git_status()
      end, { silent = true, desc = "telescope git status" })

      map("n", "<leader>gh", function()
        require("telescope.builtin").git_stash()
      end, { silent = true, desc = "telescope git stash" })

      -- Setting shortcuts
      map("n", "<leader>ho", function()
        require("telescope.builtin").vim_options()
      end, { silent = true, desc = "telescope vim options" })

      map("n", "<leader>hc", function()
        require("telescope.builtin").colorscheme()
      end, { silent = true, desc = "telescope colorschemes" })

      map("n", "<leader>hh", function()
        require("telescope.builtin").help_tags()
      end, { silent = true, desc = "telescope help tags" })

      map("n", "<leader>hm", function()
        require("telescope.builtin").man_pages()
      end, { silent = true, desc = "telescope man pages" })

      map("n", "<leader>hk", function()
        require("telescope.builtin").keymaps()
      end, { silent = true, desc = "telescope keymaps" })

      map("n", "<leader>hf", function()
        require("telescope.builtin").filetypes()
      end, { silent = true, desc = "telescope filetypes" })

      map("n", "<leader>hs", function()
        require("telescope").extensions.luasnip.luasnip()
      end, { silent = true, desc = "telescope luasnip snippets" })

      map("n", "<leader>ha", function()
        require("telescope.builtin").autocommands()
      end, { silent = true, desc = "telescope autocommands" })

      map("n", "<leader>ht", function()
        require("telescope.builtin").builtin()
      end, { silent = true, desc = "telescope builtin pickers" })

      map("n", "<leader>hq", function()
        require("telescope.builtin").quickfix()
      end, { silent = true, desc = "telescope quickfix list" })

      map("n", "<leader>hl", function()
        require("telescope.builtin").loclist()
      end, { silent = true, desc = "telescope location list" })

      map("n", "<leader>hp", function()
        require("telescope.builtin").reloader()
      end, { silent = true, desc = "telescope reload lua module" })
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
      { "<leader>z", "<cmd>FzfLua<CR>", silent = true },
    },
  },
}
