local conditions = require("heirline.conditions")
local icons = require("user.ui.icons")
local utils = require("heirline.utils")

local separators = icons.separators.round

local H = {}
H.conditions = {}

function H.conditions.is_git_repo() return vim.b.minigit_summary ~= nil end

local Components = {}

Components.align = { provider = "%=" }
Components.space = { provider = " " }

-- ------------------------------------------------------------------------
-- | Vim Mode
-- ------------------------------------------------------------------------

---Get the current Vim Mode
Components.vi_mode_raw = {
  init = function(item) item.mode = vim.fn.mode(1) end,
  static = {
    mode_names = {
      n = "N ",
      no = "N?",
      nov = "N?",
      noV = "N?",
      ["no\22"] = "N?",
      niI = "Ni",
      niR = "Nr",
      niV = "Nv",
      nt = "Nt",
      v = "V ",
      vs = "Vs",
      V = "V_",
      Vs = "Vs",
      ["\22"] = "^V",
      ["\22s"] = "^V",
      s = "S ",
      S = "S_",
      ["\19"] = "^S",
      i = "I ",
      ic = "Ic",
      ix = "Ix",
      R = "R ",
      Rc = "Rc",
      Rx = "Rx",
      Rv = "Rv",
      Rvc = "Rv",
      Rvx = "Rv",
      c = "C ",
      cv = "Ex",
      r = "...",
      rm = "M",
      ["r?"] = "? ",
      ["!"] = "! ",
      t = "T ",
    },
    mode_colors = {
      n = "red",
      i = "green",
      v = "cyan",
      V = "cyan",
      ["\22"] = "cyan",
      c = "orange",
      s = "purple",
      S = "purple",
      ["\19"] = "purple",
      R = "orange",
      r = "orange",
      ["!"] = "red",
      t = "red",
    },
  },
  provider = function(item) return "%2(" .. item.mode_names[item.mode] .. "%)" end,
  hl = function(item)
    -- Use the first character to determine the color.
    local mode = item.mode:sub(1, 1)
    return { fg = item.mode_colors[mode], bold = true }
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
  },
}

Components.vi_mode = utils.surround(
  { separators.fill.left, separators.fill.right },
  "bright_bg",
  { Components.vi_mode_raw }
)

-- ------------------------------------------------------------------------
-- | Filename
-- ------------------------------------------------------------------------

function H.file_name(filename)
  filename = vim.fn.fnamemodify(filename, ":.")
  if filename == "" then return "[No Name]" end
  local start = string.find(filename, "://")
  local protocol = start ~= nil and string.sub(filename, 1, start - 1) or ""

  -- If the filename would occupy more than 1/4 of the available space,
  -- shorten the path.
  if not conditions.width_percent_below(#filename, 0.25, true) then
    filename = vim.fn.pathshorten(filename)
    if protocol ~= "" then filename = protocol .. ":" .. string.sub(filename, 2) end
  end
  return filename
end

function H.file_icon(file_name)
  local extension = vim.fn.fnamemodify(file_name, ":e")
  local icon, icon_color =
    require("nvim-web-devicons").get_icon_color(file_name, extension, { default = true })

  return icon, icon_color
end

---Base component for file-name related components. Just sets the filename
---attribute to the name of the current buffer.
Components.file_name_base = {
  init = function(item) item.filename = vim.api.nvim_buf_get_name(0) end,
}

---Get the icon for the file type of the current buffer.
Components.file_icon = {
  init = function(item)
    item.icon, item.icon_color = H.file_icon(item.filename)
  end,
  provider = function(item) return item.icon and (item.icon .. " ") end,
  hl = function(item) return { fg = item.icon_color } end,
}

---Format and display the filename in the current buffer.
Components.file_name = {
  provider = function(item) return H.file_name(item.filename) end,
  hl = function()
    if vim.bo.modified then
      return { fg = "cyan", bold = true, force = true }
    else
      return { fg = "bright_fg" }
    end
  end,
}

---Get flags if the buffer is readonly, unmodifiable, or was already modified.
Components.file_flags = {
  {
    condition = function() return vim.bo.modified end,
    provider = "[+]",
    hl = { fg = "green" },
  },
  {
    condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
    provider = "",
    hl = { fg = "orange" },
  },
}

---Creates a block that encapsulates everything related to the filename.
Components.file_name_block = utils.insert(
  Components.file_name_base,
  Components.file_icon,
  Components.file_name,
  Components.file_flags,
  { provider = "%<" }
)

-- ------------------------------------------------------------------------
-- | File Info
-- ------------------------------------------------------------------------

Components.file_type = {
  condition = function() return vim.bo.filetype ~= "" end,
  utils.surround({ separators.fill.left, separators.fill.right }, "bright_bg", {
    provider = function() return vim.bo.filetype end,
    hl = { fg = "cyan", bold = true },
  }),
}

Components.file_encoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= "utf-8" and enc:upper()
  end,
}

Components.file_format = {
  provider = function()
    local fmt = vim.bo.fileformat
    return fmt ~= "unix" and fmt:upper()
  end,
}

-- ------------------------------------------------------------------------
-- | LSP and Diagnostics
-- ------------------------------------------------------------------------

Components.lsp_active = {
  condition = function() return conditions.lsp_attached() and vim.api.nvim_win_get_width(0) > 80 end,
  update = { "LspAttach", "LspDetach", "Colorscheme" },
  utils.surround({ separators.fill.left, separators.fill.right }, "bright_bg", {
    provider = function()
      local names = {}
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      for _, server in pairs(clients) do
        table.insert(names, server.name)
      end
      return " [" .. table.concat(names, " ") .. "]"
    end,
    hl = { fg = "green", bold = true },
  }),
}

Components.diagnostics = {
  condition = conditions.has_diagnostics,
  static = {
    error_icon = icons.diagnostics.error,
    warn_icon = icons.diagnostics.warn,
    info_icon = icons.diagnostics.info,
    hint_icon = icons.diagnostics.hint,
  },
  init = function(item)
    item.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    item.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    item.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    item.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  update = { "DiagnosticChanged", "BufEnter" },
  { provider = "![" },
  {
    provider = function(item) return item.errors > 0 and (item.error_icon .. item.errors .. " ") end,
    hl = { fg = "diag_error" },
  },
  {
    provider = function(item) return item.warnings > 0 and (item.warn_icon .. item.warnings .. " ") end,
    hl = { fg = "diag_warn" },
  },
  {
    provider = function(item) return item.info > 0 and (item.info_icon .. item.info .. " ") end,
    hl = { fg = "diag_info" },
  },
  {
    provider = function(item) return item.hints > 0 and (item.hint_icon .. item.hints) end,
    hl = { fg = "diag_hint" },
  },
  { provider = "]" },
}

-- ------------------------------------------------------------------------
-- | Git
-- ------------------------------------------------------------------------
Components.git = {
  condition = H.conditions.is_git_repo,
  init = function(item)
    item.git_info = vim.b.minigit_summary
    item.diff_info = vim.b.minidiff_summary
    if item.git_info == nil or item.diff_info == nil then
      item.has_changes = false
    else
      item.has_changes = item.diff_info.source_name == "git"
        and (item.diff_info.add ~= 0 or item.diff_info.delete ~= 0 or item.diff_info.change ~= 0)
    end
  end,
  hl = { fg = "orange" },
  utils.surround({ separators.fill.left, separators.fill.right }, "bright_bg", {
    {
      provider = function(item) return " " .. (item.git_info.head_name or "") end,
      hl = { bold = true },
    },
    {
      condition = function(item) return item.has_changes end,
      {
        provider = "(",
      },
      {
        provider = function(item)
          local count = item.diff_info.add or 0
          return count > 0 and ("+" .. count)
        end,
        hl = { fg = "git_add" },
      },
      {
        provider = function(item)
          local count = item.diff_info.delete or 0
          return count > 0 and ("-" .. count)
        end,
        hl = { fg = "git_del" },
      },
      {
        provider = function(item)
          local count = item.diff_info.change or 0
          return count > 0 and ("~" .. count)
        end,
        hl = { fg = "git_change" },
      },
      {
        provider = ")",
      },
    },
  }),
}

-- ------------------------------------------------------------------------
-- | Vim Info
-- ------------------------------------------------------------------------

Components.ruler = utils.surround(
  {
    separators.fill.left,
    separators.fill.right,
  },
  "bright_bg",
  {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%7(%l/%3L%):%2c %P",
  }
)

Components.cwd = {
  provider = function()
    local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
    local cwd = vim.fn.getcwd(0)
    cwd = vim.fn.fnamemodify(cwd, ":~")
    if not conditions.width_percent_below(#cwd, 0.25, true) then cwd = vim.fn.pathshorten(cwd) end
    local trail = cwd:sub(-1) == "/" and "" or "/"
    return icon .. cwd .. trail
  end,
  hl = { fg = "blue", bold = true },
}

Components.search_count = {
  condition = function() return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0 end,
  init = function(item)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then item.search = search end
  end,
  provider = function(item)
    local search = item.search
    return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
  end,
}

Components.marco_recording = {
  condition = function() return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0 end,
  provider = " ",
  hl = { fg = "orange", bold = true },
  utils.surround({ "[", "]" }, nil, {
    provider = function() return vim.fn.reg_recording() end,
    hl = { fg = "green", bold = true },
  }),
  update = { "RecordingEnter", "RecordingLeave" },
}

-- ------------------------------------------------------------------------
-- | Special Buffers
-- ------------------------------------------------------------------------

Components.terminal_name = {
  provider = function()
    local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
    return " " .. tname
  end,
  hl = { fg = "blue", bold = true },
}

Components.help_file_name = {
  condition = function() return vim.bo.filetype == "help" end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = { fg = "blue" },
}

Components.man_file_name = {
  condition = function() return vim.bo.filetype == "man" end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return string.sub(filename, 7, -4)
  end,
  hl = { fg = "blue" },
}

-- ------------------------------------------------------------------------
-- | Tabpages
-- ------------------------------------------------------------------------

Components.tabpage_base = {
  init = function(item)
    local win_id = vim.api.nvim_tabpage_get_win(item.tabpage)
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    item.filename = vim.api.nvim_buf_get_name(buf_id)
  end,
}

Components.tabpage_file_name_block = utils.insert(
  Components.tabpage_base,
  Components.file_icon,
  Components.file_name,
  Components.file_flags
)

Components.tabpage = {
  hl = function(item)
    if not item.is_active then
      return "TabLine"
    else
      return "TabLineSel"
    end
  end,
  {
    provider = function(item) return "%" .. item.tabnr .. "T " .. item.tabpage .. " " end,
  },
  Components.tabpage_file_name_block,
  { provider = " %T" },
}

Components.tabpage_close = {
  provider = "%999X  %X",
  hl = "TabLine",
}

Components.tabpages = {
  -- only show this component if there's 2 or more tabpages
  condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
  utils.make_tablist(Components.tabpage),
  Components.tabpage_close,
  { provider = "%=" },
}

-- ------------------------------------------------------------------------
-- | Statusline
-- ------------------------------------------------------------------------

local Line = {}

Line.default_statusline = {
  Components.vi_mode,
  Components.space,
  Components.git,
  Components.space,
  Components.file_name_block,
  Components.align,
  Components.diagnostics,
  Components.space,
  Components.lsp_active,
  Components.space,
  Components.file_type,
  Components.space,
  Components.ruler,
}

Line.inactive_statusline = {
  condition = conditions.is_not_active,
  Components.file_name_block,
  Components.align,
  Components.file_type,
}

Line.special_statusline = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "fugitive" },
    })
  end,
  Components.file_type,
  Components.space,
  Components.help_file_name,
  Components.man_file_name,
  Components.align,
}

Line.terminal_statusline = {
  condition = function() return conditions.buffer_matches({ buftype = { "terminal" } }) end,
  hl = { bg = "bright_bg" },
  { condition = conditions.is_active, Components.vi_mode, Components.space },
  Components.terminal_name,
  Components.align,
  Components.ruler,
}

Line.statusline = {
  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,
  fallthrough = false,
  Line.special_statusline,
  Line.terminal_statusline,
  Line.inactive_statusline,
  Line.default_statusline,
}

-- ------------------------------------------------------------------------
-- | Tabline
-- ------------------------------------------------------------------------

Line.tabline = {
  hl = function() return "StatusLine" end,

  Components.tabpages,
}

-- ------------------------------------------------------------------------
-- | Colors
-- ------------------------------------------------------------------------

function H.init_colors()
  return {
    bright_bg = utils.get_highlight("Folded").bg,
    bright_fg = utils.get_highlight("Folded").fg,
    red = utils.get_highlight("DiagnosticError").fg,
    dark_red = utils.get_highlight("DiffDelete").bg,
    green = utils.get_highlight("String").fg,
    blue = utils.get_highlight("Function").fg,
    grey = utils.get_highlight("Comment").fg,
    orange = utils.get_highlight("Constant").fg,
    purple = utils.get_highlight("Statement").fg,
    cyan = utils.get_highlight("Special").fg,
    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
    diag_error = utils.get_highlight("DiagnosticError").fg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg,
    git_del = utils.get_highlight("DiffDelete").bg,
    git_add = utils.get_highlight("DiffAdd").bg,
    git_change = utils.get_highlight("DiffChange").bg,
  }
end

-- ------------------------------------------------------------------------
-- | Main Module
-- ------------------------------------------------------------------------

local M = {}

function M.config()
  -- Setup an autocmd to get the colors from highlight groups for non base.nvim
  -- color schemes.
  vim.api.nvim_create_autocmd("ColorschemePre", {
    group = vim.api.nvim_create_augroup("heirline colors", { clear = true }),
    callback = function()
      local heirline = require("heirline")
      heirline.load_colors(H.init_colors)
    end,
  })

  require("heirline").setup({
    statusline = Line.statusline,
    tabline = Line.tabline,
  })
end

return M
