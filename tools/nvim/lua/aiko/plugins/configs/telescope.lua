local M = {}

M.setup = function()
  local ok_telescope, telescope = pcall(require, "telescope")
  if not ok_telescope then
    return
  end

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

      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          prompt_position = "top",
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },

      path_display = { "truncate" },

      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

      color_devicons = true,

      set_env = { ["COLORTERM"] = "truecolor" },

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
          ["<C-b>"] = actions.preview_scrolling_up,
          ["<C-f>"] = actions.preview_scrolling_down,

          ["<C-u>"] = actions.results_scrolling_up,
          ["<C-d>"] = actions.results_scrolling_down,

          -- Toggle selection without moving up or down.
          ["<C-space>"] = actions.toggle_selection,
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
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
          ["q"] = actions.close,

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
          "--ignore-file",
          "~/.config/fd/ignore",
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

  -- Load luasnip snippet support.
  telescope.load_extension("luasnip")
end

-- Custom themes
M.dynamic = function(opts)
  opts = opts or {}
  local max_cols = opts.max_cols or 160

  local theme_opts = {
    layout_strategy = (vim.o.columns < max_cols) and "vertical" or "horizontal",
  }

  return vim.tbl_deep_extend("force", theme_opts, opts)
end

M.mappings = function()
  local map = vim.keymap.set

  map("n", "<leader>i", function()
    require("telescope.builtin").resume()
  end, { silent = true, desc = "telescope reopen last telescope window" })

  map("n", "<leader>do", function()
    require("telescope.builtin").diagnostics(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope open diagnostics" })

  map("n", "<leader>ds", function()
    require("telescope.builtin").spell_suggest(
      require("telescope.themes").get_cursor()
    )
  end, { silent = true, desc = "telescope spell suggest" })

  map("n", "<leader>jf", function()
    require("telescope.builtin").treesitter(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope treesitter" })

  map("n", "<leader>jd", function()
    require("telescope.builtin").lsp_definitions(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope lsp list definitions" })

  map("n", "<leader>jr", function()
    require("telescope.builtin").lsp_references(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope lsp list references" })

  map("n", "<leader>ji", function()
    require("telescope.builtin").lsp_implementations(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope lsp list implementations" })

  map("n", "<leader>jt", function()
    require("telescope.builtin").lsp_type_definitions(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope lsp list type definitions" })

  map("n", "<leader>ji", function()
    require("telescope.builtin").lsp_incoming_calls(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope lsp list incoming calls" })

  map("n", "<leader>jo", function()
    require("telescope.builtin").lsp_outgoing_calls(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope lsp list outgoing calls" })

  map("n", "<leader>jw", function()
    require("telescope.builtin").lsp_workspace_symbols(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope lsp list workspace symbols" })

  map("n", "<leader>jW", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, {
    silent = true,
    desc = "telescope lsp list dynamic workspace symbols",
  })

  map("n", "<leader>js", function()
    require("telescope.builtin").lsp_document_symbols(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope lsp list document symbols" })

  -- Finding searching and navigating
  map("n", "<leader>;", function()
    require("telescope.builtin").commands(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope vim commands" })

  map("n", "<leader>o", function()
    require("telescope.builtin").find_files(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope find files" })

  map("n", "<leader>p", function()
    require("telescope.builtin").buffers(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope buffers" })

  -- Find shortcuts
  map("n", "<leader>ff", function()
    require("telescope.builtin").live_grep(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope live grep" })

  map("n", "<leader>fw", function()
    require("telescope.builtin").grep_string(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope grep word under cursor" })

  map("n", "<leader>fs", function()
    require("telescope.builtin").spell_suggest(
      require("telescope.themes").get_cursor()
    )
  end, { silent = true, desc = "telescope spelling suggestions" })

  map("n", "<leader>fb", function()
    require("telescope.builtin").current_buffer_fuzzy_find(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope buffer fuzzy find" })

  map("n", "<leader>ft", function()
    require("telescope.builtin").tags(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope tags" })

  map("n", "<leader>f/", function()
    require("telescope.builtin").search_history(
      require("telescope.themes").get_dropdown()
    )
  end, { silent = true, desc = "telescope search history" })

  map("n", "<leader>f;", function()
    require("telescope.builtin").command_history(
      require("telescope.themes").get_dropdown()
    )
  end, { silent = true, desc = "telescope command history" })

  -- Git shortcuts
  map("n", "<leader>go", function()
    require("telescope.builtin").git_files(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope git files" })

  map("n", "<leader>gC", function()
    require("telescope.builtin").git_commits(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope git commits" })

  map("n", "<leader>gc", function()
    require("telescope.builtin").git_bcommits(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope git buffer commits" })

  map("n", "<leader>gb", function()
    require("telescope.builtin").git_branches(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope git branches" })

  map("n", "<leader>gt", function()
    require("telescope.builtin").git_status(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope git status" })

  map("n", "<leader>gh", function()
    require("telescope.builtin").git_stash(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope git stash" })

  -- Setting shortcuts
  map("n", "<leader>ho", function()
    require("telescope.builtin").vim_options(
      require("telescope.themes").get_dropdown()
    )
  end, { silent = true, desc = "telescope vim options" })

  map("n", "<leader>hc", function()
    require("telescope.builtin").colorscheme(
      require("telescope.themes").get_dropdown()
    )
  end, { silent = true, desc = "telescope colorschemes" })

  map("n", "<leader>hh", function()
    require("telescope.builtin").help_tags(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope help tags" })

  map("n", "<leader>hm", function()
    require("telescope.builtin").man_pages(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope man pages" })

  map("n", [[<leader>h']], function()
    require("telescope.builtin").marks(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope marks" })

  map("n", "<leader>hk", function()
    require("telescope.builtin").keymaps(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope keymaps" })

  map("n", "<leader>hf", function()
    require("telescope.builtin").filetypes(
      require("telescope.themes").get_dropdown()
    )
  end, { silent = true, desc = "telescope filetypes" })

  map("n", "<leader>hj", function()
    require("telescope.builtin").jumplist(
      require("telescope.themes").get_dropdown()
    )
  end, { silent = true, desc = "telescope jumplist" })

  map("n", "<leader>hr", function()
    require("telescope.builtin").registers(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope registers" })

  map("n", "<leader>hs", function()
    require("telescope").extensions.luasnip.luasnip(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope luasnip snippets" })

  map("n", "<leader>ha", function()
    require("telescope.builtin").autocommands(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope autocommands" })

  map("n", "<leader>ht", function()
    require("telescope.builtin").builtin(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope builtin pickers" })

  map("n", "<leader>hq", function()
    require("telescope.builtin").quickfix(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope quickfix list" })

  map("n", "<leader>hl", function()
    require("telescope.builtin").loclist(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope location list" })

  map("n", "<leader>hg", function()
    require("telescope.builtin").highlights(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope highlights" })

  map("n", "<leader>hp", function()
    require("telescope.builtin").reloader(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end, { silent = true, desc = "telescope highlights" })
end

return M
