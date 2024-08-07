return {
  -- Find, filter, and search pretty much anything.
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        -- Native C FZF implementation for searching.
        "nvim-telescope/telescope-fzf-native.nvim",
        lazy = true,
        build = "make",
      },
      "benfowler/telescope-luasnip.nvim",
    },
    cmd = "Telescope",
    -- stylua: ignore
    keys = {
      { "<leader>i",  "<cmd>Telescope resume<CR>",                    desc = "telescope reopen last picker" },
      { "<leader>zf", "<cmd>Telescope spell_suggest<CR>",             desc = "telescope spell suggest" },
      -- Finding searching and navigating
      { "<leader>o",  "<cmd>Telescope find_files<CR>",                desc = "telescope find files" },
      { "<leader>p",  "<cmd>Telescope buffers<CR>",                   desc = "telescope buffers" },
      { "<leader>fo", "<cmd>Telescope oldfiles<CR>",                  desc = "telescope oldfiles" },
      { "<leader>ff", "<cmd>Telescope live_grep<CR>",                 desc = "telescope live grep" },
      { "<leader>ft", "<cmd>Telescope treesitter<CR>",                desc = "telescope treesitter symbols" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>",               desc = "telescope grep word under cursor" },
      { "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "telescope buffer fuzzy find" },
      -- Git shortcuts
      { "<leader>go", "<cmd>Telescope git_files<CR>",                 desc = "telescope git files" },
      { "<leader>gC", "<cmd>Telescope git_commits<CR>",               desc = "telescope git commits" },
      { "<leader>gc", "<cmd>Telescope git_bcommits<CR>",              desc = "telescope git buffer commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>",              desc = "telescope git branches" },
      { "<leader>gf", "<cmd>Telescope git_status<CR>",                desc = "telescope git status" },
      { "<leader>gh", "<cmd>Telescope git_stash<CR>",                 desc = "telescope git stash" },
      -- Vim internals shortcuts
      { "<leader>;",  "<cmd>Telescope commands<CR>",                  desc = "telescope vim commands" },
      { "<leader>h/", "<cmd>Telescope search_history<CR>",            desc = "telescope search history" },
      { "<leader>h;", "<cmd>Telescope command_history<CR>",           desc = "telescope command history" },
      { "<leader>ho", "<cmd>Telescope vim_options<CR>",               desc = "telescope vim options" },
      { "<leader>hc", "<cmd>Telescope colorscheme<CR>",               desc = "telescope colorschemes" },
      { "<leader>hh", "<cmd>Telescope help_tags<CR>",                 desc = "telescope help tags" },
      { "<leader>hm", "<cmd>Telescope man_pages<CR>",                 desc = "telescope man pages" },
      { "<leader>hk", "<cmd>Telescope keymaps<CR>",                   desc = "telescope keymaps" },
      { "<leader>hf", "<cmd>Telescope filetypes<CR>",                 desc = "telescope filetypes" },
      { "<leader>hs", "<cmd>Telescope luasnip<CR>",                   desc = "telescope luasnip snippets" },
      { "<leader>ha", "<cmd>Telescope autocommands<CR>",              desc = "telescope autocommands" },
      { "<leader>ht", "<cmd>Telescope builtin<CR>",                   desc = "telescope builtin pickers" },
      { "<leader>hq", "<cmd>Telescope quickfix<CR>",                  desc = "telescope quickfix list" },
      { "<leader>hl", "<cmd>Telescope loclist<CR>",                   desc = "telescope location list" },
      { "<leader>hr", "<cmd>Telescope reloader<CR>",                  desc = "telescope reload lua module" },
    },
    config = function()
      local telescope = require("telescope")
      local themes = require("telescope.themes")

      telescope.setup({
        defaults = {
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
          builtin = themes.get_dropdown({ enable_preview = false }),
          colorscheme = themes.get_dropdown({ enable_preview = false }),
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
}
