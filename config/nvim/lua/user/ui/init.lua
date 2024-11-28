local protocol_icons = require("user.ui.icons").protocols

local M = {}

---Get the display name for a buffer given its normal name.
---@param bufname string The name of the buffer as it returned by `bufname()` and `nvim_buf_get_name()`
---@return string
function M.buf_display_name(bufname, is_active)
  if bufname == "" then return "󰎔 [No Name]" end

  local protocol, rest = bufname:match("^([^:]+)://(.*)$")
  if protocol == "term" then
    local _, pid, cmd = rest:match("^(.*)//(%d+):(.*)$")
    return string.format(
      "%%#%s#%s %%#%s#%s | %s",
      is_active and "TabLineSel" or "TabLine",
      protocol_icons.term,
      is_active and "TabLineSel" or "TabLine",
      pid,
      cmd
    )
  elseif protocol ~= nil then
    local icon = protocol_icons[protocol] or ("[" .. protocol .. "]")
    local filename = vim.fn.fnamemodify(rest, ":t")
    return string.format(
      "%%#%s#%s %%#%s#%s",
      is_active and "TabLineSel" or "TabLine",
      icon,
      is_active and "TabLineSel" or "TabLine",
      filename
    )
  else
    local icon
    if vim.t.diffview_view_initialized then
      icon = protocol_icons.diffview
    else
      icon = require("mini.icons").get("file", bufname)
    end

    local filename = vim.fn.fnamemodify(bufname, ":t")
    return string.format(
      "%%#%s#%s %%#%s#%s",
      is_active and "TabLineSel" or "TabLine",
      icon,
      is_active and "TabLineSel" or "TabLine",
      filename
    )
  end
end

---Return the tabline string.
---@return string
function M.tabline()
  local s = ""
  local cur_tabid = vim.api.nvim_get_current_tabpage()
  for pos, tabid in ipairs(vim.api.nvim_list_tabpages()) do
    local is_active = (tabid == cur_tabid)
    local hl = is_active and "TabLineSel" or "TabLine"

    -- Start the tab using the tabpage ID
    s = s .. "%#" .. hl .. "#%" .. tabid .. "T"

    -- Get the current buffer of the tab
    local winid = vim.api.nvim_tabpage_get_win(tabid)
    local bufid = vim.api.nvim_win_get_buf(winid)
    local bufname = vim.api.nvim_buf_get_name(bufid)

    -- Format the name of the current buffer
    local display_name = M.buf_display_name(bufname, is_active)
    s = s .. string.format(" %d %s ", pos, display_name)
  end

  -- Fill the remaining tabline with TabLineFill and reset tab page number
  s = s .. "%#TabLineFill#%T"

  -- Right-align the label to close the current tab page
  if vim.fn.tabpagenr("$") > 1 then s = s .. "%=%#TabLine#%999X󰖭" end

  return s
end

return M
