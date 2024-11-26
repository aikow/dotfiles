local M = {}

function M.tabline()
  local s = ""
  for tabid = 1, vim.fn.tabpagenr("$") do
    -- select the highlighting
    if tabid == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    -- set the tab page number (for mouse clicks)
    s = s .. "%" .. tabid .. "T"

    -- the label is made by MyTabLabel()
    local buflist = vim.fn.tabpagebuflist(tabid)
    local winnr = vim.fn.tabpagewinnr(tabid)
    local bufname = vim.fn.bufname(buflist[winnr])
    if bufname == "" then bufname = "[No Name]" end
    s = s .. string.format(" %d %s ", tabid, bufname)
  end

  -- after the last tab fill with TabLineFill and reset tab page number
  s = s .. "%#TabLineFill#%T"

  -- right-align the label to close the current tab page
  if vim.fn.tabpagenr("$") > 1 then s = s .. "%=%#TabLine#%999X󰖭" end

  return s
end

return M
