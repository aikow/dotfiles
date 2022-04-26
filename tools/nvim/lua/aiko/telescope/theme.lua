-- Custom themes
local telescope_dynamic_theme = function(opts)
  opts = opts or {}

  local theme_opts = {
    layout_strategy = (vim.o.columns < 160) and "vertical" or "horizontal",
  }

  return vim.tbl_deep_extend("force", theme_opts, opts)
end

return {
  dynamic = telescope_dynamic_theme,
}
