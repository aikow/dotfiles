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

  lualine.setup({
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { loc },
      lualine_y = { "fileformat", "filetype", "encoding" },
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
      lualine_z = {},
    },
    extensions = {},
  })
end

return M
