local M = {}

-- https://github.com/echasnovski/nvim/blob/219540b7db51f1375077124406b2913b19c7aa90/plugin/20_mini.lua#L55
local n_wraps = function(row)
  return vim.api.nvim_win_text_height(0, { start_row = row, start_vcol = 0, end_row = row }).all - 1
end

-- https://github.com/echasnovski/nvim/blob/219540b7db51f1375077124406b2913b19c7aa90/plugin/20_mini.lua#L71
function M.statuscolumn()
  -- TODO: address `signcolumn=auto` and `foldcolumn=auto`
  if not vim.wo.number and vim.wo.signcolumn == "no" and vim.wo.foldcolumn == "0" then return "" end

  -- TODO: Take a look at why `CursorLineNr` is not combined with extmark
  -- highligting from 'mini.diff'
  local is_cur = vim.v.relnum == 0
  local line_nr_hl = "%#" .. (is_cur and "Cursor" or "") .. "LineNr#"

  local lnum = vim.v.virtnum == 0 and "%l"
    or (
      vim.v.virtnum < 0 and "•" or (vim.v.virtnum == n_wraps(vim.v.lnum - 1) and "└" or "├")
    )

  return "%C%s%=" .. line_nr_hl .. lnum .. "%#LineNr# "
end

return M
