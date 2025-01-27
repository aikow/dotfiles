local M = {}

function M.setup()
  local miniclue = require("mini.clue")
  miniclue.setup({
    window = {
      config = {
        width = "auto",
      },
    },
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },

      -- Built-in completion
      { mode = "i", keys = "<C-x>" },

      -- Brackets
      { mode = "i", keys = "[" },
      { mode = "n", keys = "[" },
      { mode = "i", keys = "]" },
      { mode = "n", keys = "]" },

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
      { mode = "n", keys = "<leader>a", desc = "+Orgmode" },
      { mode = "n", keys = "<leader>d", desc = "+Diagnostic" },
      { mode = "n", keys = "<leader>f", desc = "+Find" },
      { mode = "n", keys = "<leader>g", desc = "+Git" },
      { mode = "n", keys = "<leader>h", desc = "+Neovim" },
      { mode = "n", keys = "<leader>j", desc = "+MiniVisits" },
      { mode = "n", keys = "<leader>k", desc = "+Iron" },
      { mode = "n", keys = "<leader>l", desc = "+LSP" },
      { mode = "n", keys = "<leader>r", desc = "+Refactor/Reformat" },
      { mode = "n", keys = "<leader>t", desc = "+Toggle" },

      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end

return M
