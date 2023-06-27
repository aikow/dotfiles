local Components = {}
local H = {}

Components.mode = function(args)
  local mode_info = H.modes[vim.fn.mode()]

  local mode = Components.is_truncated(args.trunc_width) and mode_info.short
    or mode_info.long

  return mode, mode_info.hl
end

Components.git = function(args)
  if not H.is_normal_buffer() then
    return ""
  end

  local head = vim.bo.gitsigns_head or "-"
  local signs = Components.is_truncated(args.trunc_width) and ""
    or (vim.bo.gitsigns_status or "")
  local icon = args.icon or ""

  if signs == "" then
    if head == "-" or head == "" then
      return ""
    end
    return string.format("%s %s", icon, head)
  end
  return string.format("%s %s %s", icon, head, signs)
end

Components.diagnostics = function(args)
  -- Assumption: there are no attached clients if table
  -- `vim.lsp.buf_get_clients()` is empty
  local hasnt_attached_client = next(vim.lsp.get_active_clients()) == nil
  local dont_show_lsp = Components.is_truncated(args.trunc_width)
    or not H.is_normal_buffer()
    or hasnt_attached_client
  if dont_show_lsp then
    return ""
  end

  -- Construct diagnostic info using predefined order
  local t = {}
  for _, level in ipairs(H.diagnostic_levels) do
    local n = H.get_diagnostic_count(level.id)
    -- Add level info only if diagnostic is present
    if n > 0 then
      table.insert(t, string.format(" %s%s", level.sign, n))
    end
  end

  local icon = args.icon or ""
  if vim.tbl_count(t) == 0 then
    return ("%s -"):format(icon)
  end
  return string.format("%s%s", icon, table.concat(t, ""))
end

Components.cwd = function()
  local filename = vim.fs.basename(vim.fn.getcwd())

  return "  " .. filename
end

Components.lsp_location = function()
  local ok_nvim_navic, nvim_navic = pcall(require, "nvim-navic")
  if not ok_nvim_navic then
    return ""
  end

  if nvim_navic.is_available() then
    return nvim_navic.get_location() or ""
  end

  return ""
end

Components.lsp_progress = function()
  local lsp = vim.lsp.status()[1]
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

  local clients = vim.lsp.get_active_clients()
  if clients then
    local names = {}
    for _, client in pairs(clients) do
      table.insert(names, client.name)
    end
    return table.concat(names, ", ")
  end

  return ""
end

Components.filename = function(args)
  -- In terminal always use plain name
  if vim.bo.buftype == "terminal" then
    return "%t"
  elseif Components.is_truncated(args.trunc_width) then
    -- File name with 'truncate', 'modified', 'readonly' flags
    -- Use relative path if truncated
    return "%f%m%r"
  else
    -- Use fullpath if not truncated
    return "%F%m%r"
  end
end

Components.fileinfo = function(args)
  local filetype = vim.bo.filetype

  -- Don't show anything if can't detect file type or not inside a "normal
  -- buffer"
  if (filetype == "") or not H.is_normal_buffer() then
    return ""
  end

  -- Add filetype icon
  local icon = H.get_filetype_icon()
  if icon ~= "" then
    filetype = string.format("%s %s", icon, filetype)
  end

  -- Construct output string if truncated
  if Components.is_truncated(args.trunc_width) then
    return filetype
  end

  -- Construct output string with extra file info
  local encoding = vim.bo.fileencoding or vim.bo.encoding
  local format = vim.bo.fileformat
  local size = H.get_filesize()

  return string.format("%s %s[%s] %s", filetype, encoding, format, size)
end

Components.location = function(args)
  -- Use virtual column number to allow update when past last column
  if Components.is_truncated(args.trunc_width) then
    return "%l│%2v"
  end

  -- Use `virtcol()` to correctly handle multi-byte characters
  return '%l|%L│%2v|%-2{virtcol("$") - 1}'
end

Components.searchcount = function(args)
  if vim.v.hlsearch == 0 or Components.is_truncated(args.trunc_width) then
    return ""
  end
  -- `searchcount()` can return errors because it is evaluated very often in
  -- statusline. For example, when typing `/` followed by `\(`, it gives E54.
  local ok, s_count =
    pcall(vim.fn.searchcount, (args or {}).options or { recompute = true })
  if not ok or s_count.current == nil or s_count.total == 0 then
    return ""
  end

  if s_count.incomplete == 1 then
    return "?/?"
  end

  local too_many = (">%d"):format(s_count.maxcount)
  local current = s_count.current > s_count.maxcount and too_many
    or s_count.current
  local total = s_count.total > s_count.maxcount and too_many or s_count.total
  return ("%s/%s"):format(current, total)
end

-- Shown diagnostic levels
H.diagnostic_levels = {
  { id = vim.diagnostic.severity.ERROR, sign = "E" },
  { id = vim.diagnostic.severity.WARN, sign = "W" },
  { id = vim.diagnostic.severity.INFO, sign = "I" },
  { id = vim.diagnostic.severity.HINT, sign = "H" },
}

-- Custom `^V` and `^S` symbols to make this file appropriate for copy-paste
-- (otherwise those symbols are not displayed).
local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)

-- stylua: ignore start
H.modes = setmetatable({
  ['n']    = { long = 'Normal',   short = 'N',   hl = 'StatuslineModeNormal' },
  ['v']    = { long = 'Visual',   short = 'V',   hl = 'StatuslineModeVisual' },
  ['V']    = { long = 'V-Line',   short = 'V-L', hl = 'StatuslineModeVisual' },
  [CTRL_V] = { long = 'V-Block',  short = 'V-B', hl = 'StatuslineModeVisual' },
  ['s']    = { long = 'Select',   short = 'S',   hl = 'StatuslineModeVisual' },
  ['S']    = { long = 'S-Line',   short = 'S-L', hl = 'StatuslineModeVisual' },
  [CTRL_S] = { long = 'S-Block',  short = 'S-B', hl = 'StatuslineModeVisual' },
  ['i']    = { long = 'Insert',   short = 'I',   hl = 'StatuslineModeInsert' },
  ['R']    = { long = 'Replace',  short = 'R',   hl = 'StatuslineModeReplace' },
  ['c']    = { long = 'Command',  short = 'C',   hl = 'StatuslineModeCommand' },
  ['r']    = { long = 'Prompt',   short = 'P',   hl = 'StatuslineModeOther' },
  ['!']    = { long = 'Shell',    short = 'Sh',  hl = 'StatuslineModeOther' },
  ['t']    = { long = 'Terminal', short = 'T',   hl = 'StatuslineModeOther' },
}, {
  -- By default return 'Unknown' but this shouldn't be needed
  __index = function()
    return   { long = 'Unknown',  short = 'U',   hl = '%#StatuslineModeOther#' }
  end,
})
-- stylua: ignore end

H.create_default_hl = function()
  local set_default_hl = function(name, data)
    data.default = true
    vim.api.nvim_set_hl(0, name, data)
  end

  set_default_hl("StatusLineModeNormal", { link = "Cursor" })
  set_default_hl("StatusLineModeInsert", { link = "DiffChange" })
  set_default_hl("StatusLineModeVisual", { link = "DiffAdd" })
  set_default_hl("StatusLineModeReplace", { link = "DiffDelete" })
  set_default_hl("StatusLineModeCommand", { link = "DiffText" })
  set_default_hl("StatusLineModeOther", { link = "IncSearch" })

  set_default_hl("StatusLineDevinfo", { link = "StatusLine" })
  set_default_hl("StatusLineFilename", { link = "StatusLineNC" })
  set_default_hl("StatusLineFileinfo", { link = "StatusLine" })
  set_default_hl("StatusLineInactive", { link = "StatusLineNC" })
end

H.is_normal_buffer = function()
  -- For more information see ":h buftype"
  return vim.bo.buftype == ""
end

H.get_filesize = function()
  local size = vim.fn.getfsize(vim.fn.getreg("%"))
  local formats = { "B", "KB", "MB", "GB", "TB" }
  local f_idx = 1
  while size > 1024 and f_idx < #formats do
    size = size / 1024
    f_idx = f_idx + 1
  end
  return string.format("%d%s", size, formats[f_idx])
end

H.get_filetype_icon = function()
  -- Have this `require()` here to not depend on plugin initialization order
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if not has_devicons then
    return ""
  end

  local file_name = vim.fn.expand("%:t")
  local file_ext = vim.fn.expand("%:e")
  return devicons.get_icon(file_name, file_ext, { default = true })
end

H.get_diagnostic_count = function(id)
  return #vim.diagnostic.get(0, { severity = id })
end
