local M = {}

---comment
---@param colors Base46Colors
---@return table<string, Color>
M.palette = function(_, colors)
  return {
    -- LSP References
    LspReferenceText = { fg = colors.dark_black, bg = colors.white },
    LspReferenceRead = { fg = colors.dark_black, bg = colors.white },
    LspReferenceWrite = { fg = colors.dark_black, bg = colors.white },

    -- Lsp Diagnostics
    DiagnosticHint = { fg = colors.purple },
    DiagnosticError = { fg = colors.red },
    DiagnosticWarn = { fg = colors.yellow },
    DiagnosticInformation = { fg = colors.green },
    LspSignatureActiveParameter = { fg = colors.black, bg = colors.green },

    RenamerTitle = { fg = colors.black, bg = colors.red },
    RenamerBorder = { fg = colors.red },
  }
end

return M
