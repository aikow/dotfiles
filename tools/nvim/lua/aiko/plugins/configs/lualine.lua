local M = {}

M.setup = function()
  local ok_lualine, lualine = pcall(require, "lualine")
  if not ok_lualine then
    return
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

  lualine.setup({
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {},
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
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { lsp_progress, loc },
      lualine_y = { "encoding", "fileformat", "filetype" },
      lualine_z = { "%p%%", "%l/%L:%c" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
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
    winbar = {},
    inactive_winbar = {},
    extensions = {
      "quickfix",
      "fugitive",
      "man",
      "neo-tree",
      "toggleterm",
      "nvim-dap-ui",
    },
  })
end

return M
