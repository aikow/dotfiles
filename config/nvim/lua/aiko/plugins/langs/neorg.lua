local M = {}

M.setup = function()
  require("neorg").setup({
    load = {
      -- Builtin modules
      ["core.defaults"] = {},
      ["core.keybinds"] = {
        config = {
          default_keybinds = true,
          neorg_leader = "<localleader>",
        },
      },
      ["core.norg.dirman"] = {
        config = {
          workspaces = {
            personal = "~/gdrive/notes",
          },
        },
      },

      -- Disable the concealer for now
      ["core.norg.concealer"] = {},

      ["core.norg.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },

      ["core.norg.qol.toc"] = {},

      -- --------------------
      -- |   Core modules   |
      -- --------------------
      ["core.presenter"] = {
        config = {
          zen_mode = "zen-mode",
        },
      },

      -- External Modules
      ["core.integrations.telescope"] = {},
    },
  })
end

return M
