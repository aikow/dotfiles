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
          -- stylua: ignore
          hook = function(keybinds)
            keybinds.map("norg", "n", "<localleader>mi", "<cmd>Neorg inject-metadata<CR>")
            keybinds.map("norg", "n", "<localleader>mu", "<cmd>Neorg update-metadata<CR>")
            keybinds.map("norg", "n", "<localleader>t", "<cmd>Neorg tangle current-file<CR>")

            -- Looking glass
            keybinds.map_event("norg", "n", "<localleader>c", "core.looking-glass.magnify-code-block")
          end,
        },
      },
      ["core.norg.dirman"] = {
        config = {
          workspaces = {
            personal = "~/gdrive/notes",
            notes = "~/notes",
          },
          index = "index.norg",
        },
      },

      -- ["core.norg.concealer"] = {},

      ["core.norg.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },

      ["core.norg.qol.toc"] = {},

      -- Neorg presentations
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
