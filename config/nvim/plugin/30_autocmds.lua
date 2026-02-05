local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Prevent accidental writes to buffers that shouldn't be edited
local unmodifiable_group = augroup("user.ft.unmodifiable", {})
local function make_unmodifiable() vim.bo.readonly = true end
autocmd("FileType", {
  group = unmodifiable_group,
  pattern = { "log" },
  callback = make_unmodifiable,
})
autocmd("BufRead", {
  group = unmodifiable_group,
  pattern = { "*.orig", "*.pacnew" },
  callback = make_unmodifiable,
})

-- Manage big files
autocmd({ "FileType" }, {
  group = augroup("user.ft.bigfile", {}),
  pattern = "bigfile",
  callback = function(params)
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(params.buf), ":p:~:.")
    vim.notify(("Big file detected '%s'"):format(path), vim.log.levels.INFO)

    local ft = vim.filetype.match({ buf = params.buf }) or ""
    vim.api.nvim_buf_call(params.buf, function()
      vim.b[params.buf].minihipatterns_disable = true
      vim.schedule(function() vim.bo[params.buf].syntax = ft end)
    end)
  end,
})

-- Set settings for built-in terminal
autocmd("TermOpen", {
  group = augroup("user.terminal.settings", {}),
  callback = function(params)
    vim.wo.wrap = true -- With wrap disabled, you can scroll sideways, which is disconcerting

    vim.keymap.set("n", "<localleader>r", [[A<Up><CR><C-\><C-n>G]], { buffer = params.buf })
  end,
})

-- Automatically trust 'exrc' files that are created and edited using nvim
autocmd("BufWritePost", {
  group = augroup("user.exrc.autotrust", {}),
  pattern = { ".nvim.lua", ".nvimrc", ".exrc" },
  callback = function(params) vim.secure.trust({ action = "allow", bufnr = params.buf }) end,
})
