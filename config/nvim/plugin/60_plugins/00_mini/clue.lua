MiniDeps.later(function()
  local miniclue = require("mini.clue")
  miniclue.setup({
    window = {
      config = {
        width = "auto",
      },
    },
    triggers = {
      -- Leader
      { mode = "n", keys = "<leader>" },
      { mode = "x", keys = "<leader>" },

      -- Local leader
      { mode = "n", keys = "<localleader>" },
      { mode = "x", keys = "<localleader>" },

      -- Brackets
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },

      -- Built-in completion
      { mode = "i", keys = "<C-x>" },

      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },

      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },

      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },

      -- Window commands
      { mode = "n", keys = "<C-w>" },

      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },

    clues = {
      { mode = "n", keys = "<leader>d", desc = "+Diagnostic" },
      { mode = "n", keys = "<leader>f", desc = "+Find" },
      { mode = "n", keys = "<leader>g", desc = "+Git" },
      { mode = "n", keys = "<leader>h", desc = "+Neovim" },
      { mode = "n", keys = "<leader>j", desc = "+MiniVisits" },
      { mode = "n", keys = "<leader>k", desc = "+Slime" },
      { mode = "n", keys = "<leader>kr", desc = "+Repls" },
      { mode = "n", keys = "<leader>l", desc = "+LSP" },
      { mode = "n", keys = "<leader>m", desc = "+Misc" },
      { mode = "n", keys = "<leader>r", desc = "+Refactor/Reformat" },
      { mode = "n", keys = "<leader>t", desc = "+Toggle" },
      { mode = "n", keys = "<leader>w", desc = "+Window" },

      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
  })
end)
