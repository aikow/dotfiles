local modules = require("aiko.statusline.modules")

local M = {}

M.filetype_excludes_winbar = {
  "help",
  "alpha",
  "packer",
  "mason",
  "DressingInput",
  "NvimTree",
  "TelescopePrompt",
  "TelescopeResults",
  "TelescopePreview",
}

M.statusline = function()
  return table.concat({
    modules.mode(),
    modules.filename(),
    modules.git(),
    "%=",
    modules.lsp_progress(),
    "%=",
    modules.lsp_diagnostics(),
    modules.lsp_status(),
    modules.cwd(),
    modules.cursor_position(),
  })
end

M.winbar = function()
  return table.concat({
    modules.filename(),
    modules.lsp_location(),
    "%=",
    modules.filetype(),
  })
end

M.tabline = function()
  return table.concat({
    modules.tablist(),
    "%=",
  })
end

M.setup = function()
  vim.opt.showtabline = 1 -- Only show tabline when there is more than 1 tab.
  vim.opt.laststatus = 3 -- Use the global status line
  vim.opt.showmode = false -- Don't show the mode in the prompt, handled by theme.

  vim.opt.statusline = "%!v:lua.require'aiko.statusline'.statusline()"
  vim.opt.tabline = "%!v:lua.require'aiko.statusline'.tabline()"

  -- Create an auto-command to set the 'winbar'. This allows us to disable it
  -- for certain file types.
  -- FIXME: bug where new buffer does not have statusline.
  vim.api.nvim_create_autocmd({ "BufNew", "BufRead" }, {
    group = vim.api.nvim_create_augroup("set winbar", { clear = true }),
    callback = function()
      if vim.tbl_contains(M.filetype_excludes_winbar, vim.bo.filetype) then
        vim.opt_local.winbar = nil
      else
        vim.opt_local.winbar = "%{%v:lua.require'aiko.statusline'.winbar()%}"
      end
    end,
  })
end

return M
