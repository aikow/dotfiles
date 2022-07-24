local M = {}

M.setup = function()
  local ok_nvim_tree, nvim_tree = pcall(require, "nvim-tree")
  if not ok_nvim_tree then
    return
  end

  local icons = require("aiko.ui.icons")

  nvim_tree.setup({
    disable_netrw = false,
    hijack_netrw = false,

    open_on_setup = false,

    hijack_cursor = true,
    hijack_directories = {
      enable = true,
    },
    hijack_unnamed_buffer_when_opening = false,

    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = false,
    },

    view = {
      adaptive_size = false,
      side = "left",
      width = 40,
      hide_root_folder = true,
    },

    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = icons.diagnostics.hint,
        info = icons.diagnostics.info,
        warning = icons.diagnostics.warn,
        error = icons.diagnostics.error,
      },
    },

    git = {
      enable = true,
      ignore = true,
    },

    filesystem_watchers = {
      enable = true,
    },

    actions = {
      change_dir = {
        enable = true,
        restrict_above_cwd = true,
      },
      open_file = {
        resize_window = false,
      },
    },

    renderer = {
      highlight_git = true,
      highlight_opened_files = "none",

      indent_markers = {
        enable = false,
      },

      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },

        glyphs = {
          default = "",
          symlink = "",
          folder = {
            default = "",
            empty = "",
            empty_open = "",
            open = "",
            symlink = "",
            symlink_open = "",
            arrow_open = "",
            arrow_closed = "",
          },
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },
  })
end

M.mappings = function()
  local map = vim.keymap.set

  map(
    "n",
    "_",
    [[<cmd>NvimTreeFindFile<CR>]],
    { silent = true, desc = "Neotree reveal filesystem" }
  )
end

return M
