local function map_telescope(lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(opts.mode or "n", lhs, type(rhs) == "string" and function()
    require("telescope.builtin")[rhs](opts.opts)
  end or rhs, { silent = true, desc = opts.desc })
end

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
      map_telescope("<leader>i", "resume", { desc = "telescope reopen last picker" }),
      map_telescope("<leader>ls", "spell_suggest", { desc = "telescope spell suggest" }),
      map_telescope("<leader>lf", "treesitter", { desc = "telescope treesitter" }),
      -- Finding searching and navigating
      map_telescope("<leader>o", "find_files", { desc = "telescope find files" }),
      map_telescope("<leader>p", "buffers", { desc = "telescope buffers" }),
      map_telescope("<leader>ff", "live_grep", { desc = "telescope live grep" }),
      map_telescope("<leader>fw", "grep_string", { desc = "telescope grep word under cursor" }),
      map_telescope("<leader>fb", "current_buffer_fuzzy_find", { desc = "telescope buffer fuzzy find" }),
      -- Git shortcuts
      map_telescope("<leader>go", "git_files", { desc = "telescope git files" }),
      map_telescope("<leader>gC", "git_commits", { desc = "telescope git commits" }),
      map_telescope("<leader>gc", "git_bcommits", { desc = "telescope git buffer commits" }),
      map_telescope("<leader>gb", "git_branches", { desc = "telescope git branches" }),
      map_telescope("<leader>gf", "git_status", { desc = "telescope git status" }),
      map_telescope("<leader>gh", "git_stash", { desc = "telescope git stash" }),
      -- Setting shortcuts
      map_telescope("<leader>;", "commands", { desc = "telescope vim commands" }),
      map_telescope("<leader>h/", "search_history", { desc = "telescope search history" }),
      map_telescope("<leader>h;", "command_history", { desc = "telescope command history" }),
      map_telescope("<leader>ho", "vim_options", { desc = "telescope vim options" }),
      map_telescope("<leader>hc", "colorscheme", { desc = "telescope colorschemes" }),
      map_telescope("<leader>hh", "help_tags", { desc = "telescope help tags" }),
      map_telescope("<leader>hm", "man_pages", { desc = "telescope man pages" }),
      map_telescope("<leader>hk", "keymaps", { desc = "telescope keymaps" }),
      map_telescope("<leader>hf", "filetypes", { desc = "telescope filetypes" }),
      map_telescope("<leader>hs", "extensions.luasnip.luasnip", { desc = "telescope luasnip snippets" }),
      map_telescope("<leader>ha", "autocommands", { desc = "telescope autocommands" }),
      map_telescope("<leader>ht", "builtin", { desc = "telescope builtin pickers" }),
      map_telescope("<leader>hq", "quickfix", { desc = "telescope quickfix list" }),
      map_telescope("<leader>hl", "loclist", { desc = "telescope location list" }),
      map_telescope("<leader>hp", "reloader", { desc = "telescope reload lua module" }),
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
      { "<leader>z", "<cmd>FzfLua<CR>", silent = true },
    },
  },
}
