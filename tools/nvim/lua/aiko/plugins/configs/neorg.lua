local M = {}

M.setup = function()
  local ok_neorg, neorg = pcall(require, "neorg")
  if not ok_neorg then
    return
  end

  neorg.setup({
    load = {
      -- Builtin modules
      ["core.defaults"] = {},
      ["core.keybinds"] = {
        config = {
          default_keybinds = false,
          neorg_leader = "<localleader>",
          hook = function(keybinds)
            local leader = keybinds.leader

            -- Map all the below keybinds only when the "norg" mode is active
            keybinds.map_event_to_mode("norg", {
              n = { -- Bind keys in normal mode

                -- Keys for managing TODO items and setting their states
                {
                  leader .. "tu",
                  "core.norg.qol.todo_items.todo.task_undone",
                },
                {
                  leader .. "tp",
                  "core.norg.qol.todo_items.todo.task_pending",
                },
                { leader .. "td", "core.norg.qol.todo_items.todo.task_done" },
                {
                  leader .. "th",
                  "core.norg.qol.todo_items.todo.task_on_hold",
                },
                {
                  leader .. "tc",
                  "core.norg.qol.todo_items.todo.task_cancelled",
                },
                {
                  leader .. "tr",
                  "core.norg.qol.todo_items.todo.task_recurring",
                },
                {
                  leader .. "ti",
                  "core.norg.qol.todo_items.todo.task_important",
                },
                {
                  leader .. "tt",
                  "core.norg.qol.todo_items.todo.task_cycle",
                },

                -- Keys for managing GTD
                -- { leader .. "gc", "core.gtd.base.capture" },
                -- { leader .. "gv", "core.gtd.base.views" },
                -- { leader .. "ge", "core.gtd.base.edit" },

                -- Keys for managing notes
                { leader .. "e", "core.norg.dirman.new.note" },

                { "<CR>", "core.norg.esupports.hop.hop-link" },
                { "<M-CR>", "core.norg.esupports.hop.hop-link", "vsplit" },

                { "<C-k>", "core.norg.manoeuvre.item_up" },
                { "<C-j>", "core.norg.manoeuvre.item_down" },

                -- mnemonic: markup toggle
                { leader .. "hm", "core.norg.concealer.toggle-markup" },

                { "<C-h>", "core.integrations.telescope.find_linkable" },
              },
              o = {
                { "ah", "core.norg.manoeuvre.textobject.around-heading" },
                { "ih", "core.norg.manoeuvre.textobject.inner-heading" },
                { "at", "core.norg.manoeuvre.textobject.around-tag" },
                { "it", "core.norg.manoeuvre.textobject.inner-tag" },
                { "al", "core.norg.manoeuvre.textobject.around-whole-list" },
              },
              i = {
                { "<C-h>", "core.integrations.telescope.insert_link" },
              },
            }, {
              silent = true,
              noremap = true,
            })

            -- Map the below keys only when traverse-heading mode is active
            keybinds.map_event_to_mode("traverse-heading", {
              n = {
                -- Rebind j and k to move between headings in traverse-heading mode
                { "j", "core.integrations.treesitter.next.heading" },
                { "k", "core.integrations.treesitter.previous.heading" },
              },
            }, {
              silent = true,
              noremap = true,
            })

            keybinds.map_event_to_mode("toc-split", {
              n = {
                { "<CR>", "core.norg.qol.toc.hop-toc-link" },

                -- Keys for closing the current display
                { "q", "core.norg.qol.toc.close" },
                { "<Esc>", "core.norg.qol.toc.close" },
              },
            }, {
              silent = true,
              noremap = true,
              nowait = true,
            })

            -- Map the below keys on gtd displays
            -- keybinds.map_event_to_mode("gtd-displays", {
            --   n = {
            --     { "<CR>", "core.gtd.ui.goto_task" },
            --
            --     -- Keys for closing the current display
            --     { "q", "core.gtd.ui.close" },
            --     { "<Esc>", "core.gtd.ui.close" },
            --
            --     { "e", "core.gtd.ui.edit_task" },
            --     { "<Tab>", "core.gtd.ui.details" },
            --   },
            -- }, {
            --   silent = true,
            --   noremap = true,
            --   nowait = true,
            -- })

            -- Map the below keys on presenter mode
            keybinds.map_event_to_mode("presenter", {
              n = {
                { "<CR>", "core.presenter.next_page" },
                { "l", "core.presenter.next_page" },
                { "h", "core.presenter.previous_page" },
                { "j", "core.presenter.next_page" },
                { "k", "core.presenter.previous_page" },

                -- Keys for closing the current display
                { "q", "core.presenter.close" },
                { "<Esc>", "core.presenter.close" },
              },
            }, {
              silent = true,
              noremap = true,
              nowait = true,
            })
            -- Apply the below keys to all modes
            keybinds.map_to_mode("all", {
              n = {
                { leader .. "n", ":Neorg mode norg<CR>" },
                { leader .. "h", ":Neorg mode traverse-heading<CR>" },
              },
            }, {
              silent = true,
              noremap = true,
            })
          end,
        },
      },
      ["core.norg.dirman"] = {
        config = {
          workspaces = {
            personal = "~/GDrive/notes",
          },
        },
      },

      -- Disable the concealer for now
      -- ["core.norg.concealer"] = {},

      ["core.norg.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },

      -- --------------------
      -- |   Core modules   |
      -- --------------------
      -- ["core.presenter"] = {},

      -- ["core.norg.journal"] = {
      --   config = {
      --     workspace = "personal",
      --     journal_folder = "journal",
      --     strategy = "nested",
      --   },
      -- },

      -- ---------------------------
      -- |   Getting Things Done   |
      -- ---------------------------
      -- ["core.gtd.base"] = {},

      -- External Modules
      ["core.integrations.telescope"] = {},
    },
  })
end

return M
