local fn = vim.fn
local separators = require("aiko.ui.icons").statusline_separators.default
local sep_l = separators["left"]
local sep_r = separators["right"]

local modes = {
  ["n"] = { "NORMAL", "StatusLineNormalMode" },
  ["niI"] = { "NORMAL i", "StatusLineNormalMode" },
  ["niR"] = { "NORMAL r", "StatusLineNormalMode" },
  ["niV"] = { "NORMAL v", "StatusLineNormalMode" },
  ["no"] = { "N-PENDING", "StatusLineNormalMode" },
  ["i"] = { "INSERT", "StatusLineInsertMode" },
  ["ic"] = { "INSERT (completion)", "StatusLineInsertMode" },
  ["ix"] = { "INSERT completion", "StatusLineInsertMode" },
  ["t"] = { "TERMINAL", "StatusLineTerminalMode" },
  ["nt"] = { "NTERMINAL", "StatusLineNTerminalMode" },
  ["v"] = { "VISUAL", "StatusLineVisualMode" },
  ["V"] = { "V-LINE", "StatusLineVisualMode" },
  ["Vs"] = { "V-LINE (Ctrl O)", "StatusLineVisualMode" },
  [""] = { "V-BLOCK", "StatusLineVisualMode" },
  ["R"] = { "REPLACE", "StatusLineReplaceMode" },
  ["Rv"] = { "V-REPLACE", "StatusLineReplaceMode" },
  ["s"] = { "SELECT", "StatusLineSelectMode" },
  ["S"] = { "S-LINE", "StatusLineSelectMode" },
  [""] = { "S-BLOCK", "StatusLineSelectMode" },
  ["c"] = { "COMMAND", "StatusLineCommandMode" },
  ["cv"] = { "COMMAND", "StatusLineCommandMode" },
  ["ce"] = { "COMMAND", "StatusLineCommandMode" },
  ["r"] = { "PROMPT", "StatusLineConfirmMode" },
  ["rm"] = { "MORE", "StatusLineConfirmMode" },
  ["r?"] = { "CONFIRM", "StatusLineConfirmMode" },
  ["!"] = { "SHELL", "StatusLineTerminalMode" },
}

local M = {}

M.mode = function()
  local m = vim.api.nvim_get_mode().mode
  local current_mode = "%#" .. modes[m][2] .. "#" .. "  " .. modes[m][1]
  local mode_sep1 = "%#" .. modes[m][2] .. "Sep" .. "#" .. sep_r

  return current_mode .. mode_sep1 .. "%#StatusLineEmptySpace#" .. sep_r
end

M.file_info = function()
  local icon = "  "
  local filename = (fn.expand("%") == "" and "Empty ") or fn.expand("%:t")

  if filename ~= "Empty " then
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if devicons_present then
      local ft_icon = devicons.get_icon(filename)
      icon = (ft_icon ~= nil and " " .. ft_icon) or ""
    end

    filename = " " .. filename .. " "
  end

  return "%#StatusLineFileInfo#"
    .. icon
    .. filename
    .. "%#StatusLineFileSep#"
    .. sep_r
end

M.git = function()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    return ""
  end

  local git_status = vim.b.gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0)
      and ("  " .. git_status.added)
    or ""
  local changed = (git_status.changed and git_status.changed ~= 0)
      and ("  " .. git_status.changed)
    or ""
  local removed = (git_status.removed and git_status.removed ~= 0)
      and ("  " .. git_status.removed)
    or ""
  local branch_name = "   " .. git_status.head .. " "

  return "%#StatusLineGitIcons#" .. branch_name .. added .. changed .. removed
end

M.location = function()
  local ok_nvim_navic, nvim_navic = pcall(require, "nvim-navic")
  if not ok_nvim_navic then
    return ""
  end

  if nvim_navic.is_available() then
    return nvim_navic.get_location() or ""
  end

  return ""
end

-- LSP STUFF
M.lsp_progress = function()
  if not rawget(vim, "lsp") then
    return ""
  end

  local Lsp = vim.lsp.util.get_progress_messages()[1]

  if vim.o.columns < 120 or not Lsp then
    return ""
  end

  local msg = Lsp.message or ""
  local percentage = Lsp.percentage or 0
  local title = Lsp.title or ""
  local spinners = { "", "" }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  local content = string.format(
    " %%<%s %s %s (%s%%%%) ",
    spinners[frame + 1],
    title,
    msg,
    percentage
  )

  return ("%#StatusLineLspProgress#" .. content) or ""
end

M.lsp_diagnostics = function()
  if not rawget(vim, "lsp") then
    return ""
  end

  local num_errors = #vim.diagnostic.get(0, {
    severity = vim.diagnostic.severity.ERROR,
  })
  local num_warnings = #vim.diagnostic.get(0, {
    severity = vim.diagnostic.severity.WARN,
  })
  local num_hints = #vim.diagnostic.get(0, {
    severity = vim.diagnostic.severity.HINT,
  })
  local num_info = #vim.diagnostic.get(0, {
    severity = vim.diagnostic.severity.INFO,
  })

  local errors = (num_errors and num_errors > 0)
      and ("%#StatusLineLspError#" .. " " .. num_errors .. " ")
    or ""
  local warnings = (num_warnings and num_warnings > 0)
      and ("%#StatusLineLspWarning#" .. "  " .. num_warnings .. " ")
    or ""
  local hints = (num_hints and num_hints > 0)
      and ("%#StatusLineLspHints#" .. "ﯧ " .. num_hints .. " ")
    or ""
  local info = (num_info and num_info > 0)
      and ("%#StatusLineLspInfo#" .. " " .. num_info .. " ")
    or ""

  return errors .. warnings .. hints .. info
end

M.lsp_status = function()
  if rawget(vim, "lsp") then
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] then
        if vim.o.columns > 100 then
          return "%#StatusLineLspStatus#"
            .. "   LSP ~ "
            .. client.name
            .. " "
        else
          return "   LSP "
        end
      end
    end
  end

  return ""
end

M.cwd = function()
  if vim.o.columns < 85 then
    return
  end

  local filename = " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "

  return table.concat({
    "%#StatusLineCwdSep#",
    sep_l,
    "%#StatusLineCwdIcon#",
    " ",
    "%#StatusLineCwdText#",
    filename,
  })
end

M.filetype = function()
  if vim.o.columns < 80 then
    return ""
  end

  local icon
  local filetype
  local ok_devicons, devicons = pcall(require, "nvim-web-devicons")
  if ok_devicons then
    icon = devicons.get_icon(vim.bo.filetype) or " "
    icon = icon .. " "
  else
    icon = "  "
  end

  filetype = " " .. vim.bo.filetype .. " "

  return "%#StatusLineFileTypeSep#"
    .. sep_l
    .. "%#StatusLineFileTypeIcon#"
    .. icon
    .. "%#StatusLineFileTypeText#"
    .. filetype
end

M.cursor_position = function()
  local left_sep = "%#StatusLinePosSep#"
    .. sep_l
    .. "%#StatusLinePosIcon#"
    .. " "

  local current_line = fn.line(".")
  local total_line = fn.line("$")

  local text
  if current_line == 1 then
    text = "Top"
  elseif current_line == total_line then
    text = "Bot"
  else
    text = math.modf((current_line / total_line) * 100) .. "%%"
  end

  return left_sep
    .. "%#StatusLinePosText#"
    .. " "
    .. text
    .. " of "
    .. total_line
    .. " "
end

M.tablist = function()
  local result = ""
  local number_of_tabs = fn.tabpagenr("$")

  for i = 1, number_of_tabs, 1 do
    local tab_hl
    if i == fn.tabpagenr() then
      tab_hl = "%#StatusLineActiveTab# "
    else
      tab_hl = "%#StatusLineInactiveTab# "
    end

    local buflist = fn.tabpagebuflist(i)
    local bufname = vim.api.nvim_buf_get_name(buflist[1])
    local name = string.match(bufname, "[^/]*$")

    result = table.concat({ result, "%", i, "T", tab_hl, name, i, "%X " })
  end

  return result
end

return M
