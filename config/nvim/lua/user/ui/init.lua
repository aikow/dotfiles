local protocol_icons = require("user.ui.icons").protocols

local M = {}

-- ------------------------------------------------------------------------
-- | Tabpage Icon Handlers
-- ------------------------------------------------------------------------
M.handlers = {
  empty = function(state)
    if state.bufname ~= "" then return end
    return "󰎔", "[No Name]"
  end,

  protocol_terminal = function(state)
    if state.protocol ~= "term" then return end
    local _, pid, cmd = state.rest:match("^(.*)//(%d+):(.*)$")
    return protocol_icons.term, pid .. " | " .. cmd
  end,

  protocol = function(state)
    if state.protocol == nil then return end
    local icon = protocol_icons[state.protocol] or ("[" .. state.protocol .. "]")
    local filename = vim.fn.fnamemodify(state.rest, ":t")
    return icon, filename
  end,

  diffview = function(state)
    if not vim.t[state.tabid].diffview_view_initialized then return end
    local icon = protocol_icons.diffview
    local filename = vim.fn.fnamemodify(state.bufname, ":t")
    return icon, filename
  end,

  default = function(state)
    local icon = require("mini.icons").get("file", state.bufname)
    local filename = vim.fn.fnamemodify(state.bufname, ":t")
    return icon, filename
  end,
}

---Get the display name for a buffer given its normal name.
---@param bufname string The name of the buffer as it returned by `bufname()` and `nvim_buf_get_name()`
---@return string
function M.buf_display_name(tabid, is_active)
  -- Get the current buffer of the tab
  local winid = vim.api.nvim_tabpage_get_win(tabid)
  local bufid = vim.api.nvim_win_get_buf(winid)
  local bufname = vim.api.nvim_buf_get_name(bufid)
  local protocol, rest = bufname:match("^([^:]+)://(.*)$")
  local state = {
    bufid = bufid,
    winid = winid,
    tabid = tabid,
    bufname = bufname,
    protocol = protocol,
    rest = rest,
    is_active = is_active,
  }

  local icon, tabname
  for _, h in pairs(M.handlers) do
    icon, tabname = h(state)
    if icon then break end
  end

  return string.format(
    "%%#%s#%s %%#%s#%s",
    state.is_active and "TabLineSel" or "TabLine",
    icon,
    state.is_active and "TabLineSel" or "TabLine",
    tabname
  )
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

    -- Format the name of the current buffer
    local display_name = M.buf_display_name(tabid, is_active)
    s = s .. string.format(" %d %s ", pos, display_name)
  end

  -- Fill the remaining tabline with TabLineFill and reset tab page number
  s = s .. "%#TabLineFill#%T"

  -- Right-align the label to close the current tab page
  if vim.fn.tabpagenr("$") > 1 then s = s .. "%=%#TabLine#%999X󰖭" end

  return s
end

return M
