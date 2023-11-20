local conditions = require("heirline.conditions")
local icons = require("user.ui.icons")
local utils = require("heirline.utils")

local separators = icons.separators.round

local H = {}
local Components = {}

Components.align = { provider = "%=" }
Components.space = { provider = " " }

-- ------------------------------------------------------------------------
-- | Vim Mode
-- ------------------------------------------------------------------------

---Get the current Vim Mode
Components.vi_mode_raw = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
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
  provider = function(self)
    return "%2(" .. self.mode_names[self.mode] .. "%)"
  end,
  hl = function(self)
    -- Use the first character to determine the color.
    local mode = self.mode:sub(1, 1)
    return { fg = self.mode_colors[mode], bold = true }
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd.redrawstatus()
    end),
  },
}

Components.vi_mode = utils.surround(
  { separators.fill.left, separators.fill.right },
  "gray",
  { Components.vi_mode_raw }
)

-- ------------------------------------------------------------------------
-- | Filename
-- ------------------------------------------------------------------------
H.file_name = function(filename)
  filename = vim.fn.fnamemodify(filename, ":.")
  if filename == "" then
    return "[No Name]"
  end
  -- If the filename would occupy more than 1/4 of the available space,
  -- shorten the path.
  if not conditions.width_percent_below(#filename, 0.25) then
    filename = vim.fn.pathshorten(filename)
  end
  return filename
end

H.file_icon = function(file_name)
  local extension = vim.fn.fnamemodify(file_name, ":e")
  local icon, icon_color = require("nvim-web-devicons").get_icon_color(
    file_name,
    extension,
    { default = true }
  )

  return icon, icon_color
end

Components.file_name_block = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}

Components.file_icon = {
  init = function(self)
    self.icon, self.icon_color = H.file_icon(self.filename)
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

Components.file_name = {
  provider = function(self)
    return H.file_name(self.filename)
  end,
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = "cyan", bold = true, force = true }
    else
      return { fg = "bright_fg" }
    end
  end,
}

Components.file_flags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+]",
    hl = { fg = "green" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "",
    hl = { fg = "orange" },
  },
}

-- let's add the children to our FileNameBlock component
Components.file_name_block = utils.insert(
  Components.file_name_block,
  Components.file_icon,
  Components.file_name,
  Components.file_flags,
  { provider = "%<" }
)

-- ------------------------------------------------------------------------
-- | File Info
-- ------------------------------------------------------------------------
Components.file_type = {
  condition = function()
    return vim.bo.filetype ~= ""
  end,

  utils.surround({ separators.fill.left, separators.fill.right }, "gray", {
    provider = function()
      return vim.bo.filetype
    end,
    hl = { fg = "orange", bold = true },
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
  condition = conditions.lsp_attached,
  update = { "LspAttach", "LspDetach" },
  utils.surround({ separators.fill.left, separators.fill.right }, "gray", {
    provider = function()
      local names = {}
      for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
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
  init = function(self)
    self.errors =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  update = { "DiagnosticChanged", "BufEnter" },
  { provider = "![" },
  {
    provider = function(self)
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = { fg = "diag_error" },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = { fg = "diag_warn" },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = { fg = "diag_info" },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = { fg = "diag_hint" },
  },
  { provider = "]" },
}

-- ------------------------------------------------------------------------
-- | Git
-- ------------------------------------------------------------------------
Components.git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0
      or self.status_dict.removed ~= 0
      or self.status_dict.changed ~= 0
  end,
  hl = { fg = "orange" },
  utils.surround({ separators.fill.left, separators.fill.right }, "gray", {
    {
      provider = function(self)
        return " " .. self.status_dict.head
      end,
      hl = { bold = true },
    },
    {
      condition = function(self)
        return self.has_changes
      end,
      provider = "(",
    },
    {
      provider = function(self)
        local count = self.status_dict.added or 0
        return count > 0 and ("+" .. count)
      end,
      hl = { fg = "git_add" },
    },
    {
      provider = function(self)
        local count = self.status_dict.removed or 0
        return count > 0 and ("-" .. count)
      end,
      hl = { fg = "git_del" },
    },
    {
      provider = function(self)
        local count = self.status_dict.changed or 0
        return count > 0 and ("~" .. count)
      end,
      hl = { fg = "git_change" },
    },
    {
      condition = function(self)
        return self.has_changes
      end,
      provider = ")",
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
  "gray",
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
    if not conditions.width_percent_below(#cwd, 0.25) then
      cwd = vim.fn.pathshorten(cwd)
    end
    local trail = cwd:sub(-1) == "/" and "" or "/"
    return icon .. cwd .. trail
  end,
  hl = { fg = "blue", bold = true },
}

Components.search_count = {
  condition = function()
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  provider = function(self)
    local search = self.search
    return string.format(
      "[%d/%d]",
      search.current,
      math.min(search.total, search.maxcount)
    )
  end,
}

Components.marco_recording = {
  condition = function()
    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
  end,
  provider = " ",
  hl = { fg = "orange", bold = true },
  utils.surround({ "[", "]" }, nil, {
    provider = function()
      return vim.fn.reg_recording()
    end,
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
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = { fg = "blue" },
}

-- ------------------------------------------------------------------------
-- | Tabpages
-- ------------------------------------------------------------------------

Components.tabpage = {
  hl = function(self)
    if not self.is_active then
      return "TabLine"
    else
      return "TabLineSel"
    end
  end,
  {
    provider = function(self)
      return " %" .. self.tabnr .. "T" .. self.tabpage .. " "
    end,
  },
  {
    provider = function(self)
      local win_id = vim.api.nvim_tabpage_get_win(self.tabnr)
      local buf_id = vim.api.nvim_win_get_buf(win_id)
      local buf_name = vim.api.nvim_buf_get_name(buf_id)
      local filename = H.file_name(buf_name)

      return filename
    end,
  },
  Components.file_flags,
  { provider = " %T" },
}

Components.tabpage_close = {
  provider = "%999X  %X",
  hl = "TabLine",
}

Components.tabpages = {
  -- only show this component if there's 2 or more tabpages
  condition = function()
    return #vim.api.nvim_list_tabpages() >= 2
  end,
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
  Components.file_type,
  Components.space,
  Components.file_name_block,
  Components.align,
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
  Components.align,
}

Line.terminal_statusline = {
  condition = function()
    return conditions.buffer_matches({ buftype = { "terminal" } })
  end,
  hl = { bg = "gray" },
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
  hl = function()
    return "StatusLine"
  end,

  Components.tabpages,
}

-- ------------------------------------------------------------------------
-- | Colors
-- ------------------------------------------------------------------------

H.init_colors = function()
  return {
    bright_bg = utils.get_highlight("Folded").bg,
    bright_fg = utils.get_highlight("Folded").fg,
    red = utils.get_highlight("DiagnosticError").fg,
    dark_red = utils.get_highlight("DiffDelete").bg,
    green = utils.get_highlight("String").fg,
    blue = utils.get_highlight("Function").fg,
    gray = utils.get_highlight("NonText").fg,
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

M.setup = function()
  vim.api.nvim_create_autocmd("Colorscheme", {
    callback = function()
      require("heirline").load_colors(H.init_colors)
    end,
  })

  require("heirline").setup({
    statusline = Line.statusline,
    tabline = Line.tabline,
  })
end

return M
