local M = {}

local separators = require("aiko.ui.icons").separators

M.setup = function()
  local ok_lualine, lualine = pcall(require, "lualine")
  if not ok_lualine then
    return
  end

  local cwd = function()
    local filename = vim.fs.basename(vim.fn.getcwd())

    return "  " .. filename
  end

  local loc = function()
    local ok_nvim_navic, nvim_navic = pcall(require, "nvim-navic")
    if not ok_nvim_navic then
      return ""
    end

    if nvim_navic.is_available() then
      return nvim_navic.get_location() or ""
    end

    return ""
  end

  local lsp_progress = function()
    local lsp = vim.lsp.util.get_progress_messages()[1]
    if lsp then
      local name = lsp.name or ""
      local msg = lsp.message or ""
      local percentage = lsp.percentage or 0
      local title = lsp.title or ""
      return string.format(
        " %%<%s: %s %s (%s%%%%) ",
        name,
        title,
        msg,
        percentage
      )
    end

    local clients = vim.lsp.buf_get_clients()
    if clients then
      local names = {}
      for _, client in pairs(clients) do
        table.insert(names, client.name)
      end
      return table.concat(names, ", ")
    end

    return ""
  end

  -- Hide the tabline if only one tab is opened.
  vim.api.nvim_create_autocmd({ "VimEnter", "TabNew", "TabClosed" }, {
    group = vim.api.nvim_create_augroup("LualineTab", {}),
    callback = function()
      local show = #vim.api.nvim_list_tabpages() > 1
      vim.o.showtabline = show and 1 or 0
      lualine.hide({
        place = { "tabline" },
        unhide = show,
      })
    end,
  })

  lualine.setup({
    options = {
      icons_enabled = true,
      component_separators = separators.round.outline,
      section_separators = separators.round.fill,
      disabled_filetypes = {
        statusline = {},
        winbar = { "NvimTree", "neo-tree" },
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { cwd, "branch" },
      lualine_c = { "diff" },
      lualine_x = { lsp_progress },
      lualine_y = { "diagnostics" },
      lualine_z = { "%l:%c", "%L" },
    },

    tabline = {
      lualine_a = {
        {
          "tabs",
          max_length = vim.o.columns / 3,
          mode = 2,
        },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        {
          "windows",
          max_length = vim.o.columns / 3,
        },
      },
    },
    winbar = {
      lualine_a = {},
      lualine_b = { "filename" },
      lualine_c = { loc },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = {},
      lualine_z = {},
    },
    inactive_winbar = {
      lualine_a = {},
      lualine_b = { "filename" },
      lualine_c = { loc },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {
      "fugitive",
      "man",
      "neo-tree",
      "nvim-dap-ui",
      "nvim-tree",
      "quickfix",
      "toggleterm",
    },
  })

  -- Hide the tabline by default.
  lualine.hide({
    place = { "tabline" },
    unhide = false,
  })
end

return M
