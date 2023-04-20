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

            -- Telescope
            keybinds.map("norg", "i", "<C-l>", "<cmd>Telescope neorg insert_link<CR>")
            keybinds.map("norg", "i", "<C-h>", "<cmd>Telescope neorg insert_file_link<CR>")

            keybinds.map("norg", "n", "<localleader>fo", "<cmd>Telescope neorg find_norg_files<CR>")
            keybinds.map("norg", "n", "<localleader>fl", "<cmd>Telescope neorg find_linkable<CR>")
            keybinds.map("norg", "n", "<localleader>fh", "<cmd>Telescope neorg find_headings<CR>")

            -- Looking glass
            keybinds.map_event("norg", "n", "<localleader>c", "core.looking-glass.magnify-code-block")
          end,
        },
      },
      ["core.dirman"] = {
        config = {
          workspaces = {
            personal = "~/gdrive/notes",
            notes = "~/notes",
          },
          index = "index.norg",
        },
      },

      ["core.concealer"] = {},

      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },

      ["core.qol.toc"] = {},

      -- Neorg presentations
      ["core.presenter"] = {
        config = {
          zen_mode = "zen-mode",
        },
      },

      ["core.export"] = {},

      -- External Modules
      ["core.integrations.telescope"] = {},
    },
  })
end

return M
