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
      ["core.norg.dirman"] = {
        config = {
          workspaces = {
            personal = "~/GDrive/notes",
          },
        },
      },
      ["core.norg.concealer"] = {},
      ["core.norg.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
      ["core.presenter"] = {},
      ["core.norg.journal"] = {
        config = {
          workspace = "personal",
          journal_folder = "journal",
          strategy = "nested",
        },
      },

      -- External Modules
      ["core.integrations.telescope"] = {},
    },
  })
end

return M
