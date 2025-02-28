local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Prevent accidental writes to buffers that shouldn't be edited
local unmodifiable_group = augroup("Unmodifiable files", {})
local function make_unmodifiable() vim.opt_local.readonly = true end
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
  group = augroup("Bigfile", {}),
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
  group = augroup("Terminal settings", {}),
  callback = function(params)
    vim.opt_local.spell = false
    vim.opt_local.number = false
    vim.opt_local.wrap = true -- With wrap disabled, you can scroll sideways, which is disconcerting

    vim.keymap.set("n", "<localleader>r", [[A<Up><CR><C-\><C-n>G]], { buffer = params.buf })
  end,
})

-- Automatically read and source `exrc` file in any parent directory.
autocmd("VimEnter", {
  group = augroup("Source exrc", {}),
  callback = function()
    -- Find the list of configs.
    local exrc_patterns = { ".exrc", ".nvimrc" }
    local configs = vim.fs.find(exrc_patterns, { upward = true, type = "file", limit = math.huge })

    -- Iterate over the files in reverse so that the "most local" one gets sourced last.
    for f in vim.iter(configs):rev() do
      local contents = vim.secure.read(f)
      if contents ~= nil then
        vim.api.nvim_exec2(contents, {})
      else
        vim.notify(string.format("Skip loading '%s'", f), vim.log.levels.DEBUG)
      end
    end
  end,
})
