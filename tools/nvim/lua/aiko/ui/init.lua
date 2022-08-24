local M = {}

M.filetype_excludes_winbar = {
  "help",
  "alpha",
  "packer",
  "mason",
  "NvimTree",
  "TelescopePrompt",
  "TelescopeResults",
  "TelescopePreview",
}

M.setup = function()
  vim.opt.statusline = "%!v:lua.require'aiko.ui.statusline'.statusline()"
  vim.opt.tabline = "%!v:lua.require'aiko.ui.statusline'.tabline()"

  -- Create an auto-command to set the 'winbar'. This allows us to disable it
  -- for certain file types.
  -- FIXME: bug where new buffer does not have statusline.
  vim.api.nvim_create_autocmd({ "BufRead" }, {
    group = vim.api.nvim_create_augroup("set winbar", { clear = true }),
    callback = function()
      if vim.tbl_contains(M.filetype_excludes_winbar, vim.bo.filetype) then
        vim.opt_local.winbar = nil
      else
        vim.opt_local.winbar = "%{%v:lua.require'aiko.ui.statusline'.winbar()%}"
      end
    end,
  })
end

return M
