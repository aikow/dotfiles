return {
  opts = {
    load = {
      -- Load all default modules
      ["core.defaults"] = {},

      -- Remove leading whitespace when yanking a code-block.
      ["core.clipboard.code-blocks"] = {},

      -- Customize the core completion module to use nvim-cmp.
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },

      -- Replace some Neorg markup notation with fancy icons.
      ["core.concealer"] = {},

      -- Manage directories and workspaces.
      ["core.dirman"] = {
        config = {
          workspaces = {
            personal = "~/gdrive/notes",
            docs = "~/Documents/",
          },
          index = "index.norg",
        },
      },

      -- Convert Neorg files to other formats like markdown.
      ["core.export"] = {},

      -- Easily continue a Neorg item on the next line.
      ["core.itero"] = {},

      -- Configure the default keybindings.
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

      -- Allows editing code-blocks in a separate buffer of that filetype.
      ["core.looking-glass"] = {},

      -- Easily toggle between the two list types.
      ["core.pivot"] = {},

      -- Enable a fancy presenter mode for showing off Neorg documents.
      ["core.presenter"] = {
        config = {
          zen_mode = "zen-mode",
        },
      },

      -- Shortcuts for increasing and decreasing the nesting level of Neorg
      -- items.
      ["core.promo"] = {},

      -- Generate a table-of-contents dynamically.
      ["core.qol.toc"] = {},

      -- Generate a summary of the workspace.
      ["core.summary"] = {},

      -- Allows piping the contents of codeblocks into multiple different files.
      ["core.tangle"] = {},

      -- Enable the date picker.
      ["core.ui.calendar"] = {},
    },
  },
}
