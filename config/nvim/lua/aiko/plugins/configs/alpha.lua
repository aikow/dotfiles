local M = {}

M.setup = function()
  local alpha = require("alpha")
  local dashboard = require("alpha.themes.dashboard")

  -- Set header
  dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
  }

  -- Set menu
  dashboard.section.buttons.val = {
    dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button(
      "f",
      "  > Find file",
      ":cd $HOME/Workspace | Telescope find_files<CR>"
    ),
    dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
    dashboard.button(
      "s",
      "  > Settings",
      ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"
    ),
    dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
  }

  local fortune = require("alpha.fortune")
  dashboard.section.footer.val = fortune()

  -- Send config to alpha
  alpha.setup(dashboard.opts)

  -- Disable folding on alpha buffer
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "alpha",
    callback = function()
      vim.opt_local.foldenable = false
    end,
  })
end

return M
