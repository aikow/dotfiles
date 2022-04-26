local cmd = vim.cmd
local o_s = vim.o
local map_key = vim.api.nvim_set_keymap

local function opt(o, v, scopes)
  scopes = scopes or { o_s }
  for _, s in ipairs(scopes) do
    s[o] = v
  end
end

local function autocmd(group, autocmds, clear)
  clear = clear ~= nil and clear or true

  if autocmds.event ~= nil then
    autocmds = { autocmds }
  end

  local group = vim.api.nvim_create_augroup(group, { clear = clear })

  for _, autocmd in ipairs(autocmds) do
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = group,
      pattern = autocmd.pattern,
      buffer = autocmd.buffer,
      desc = autocmd.desc,
      callback = autocmd.callback,
      command = autocmd.command,
      once = autocmd.once,
      nested = autocmd.nested,
    })
  end
end

local function map(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  if type(modes) == "string" then
    modes = { modes }
  end
  for _, mode in ipairs(modes) do
    map_key(mode, lhs, rhs, opts)
  end
end

local function smap(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  opts.silent = opts.silent == nil and true or opts.silent
  if type(modes) == "string" then
    modes = { modes }
  end
  for _, mode in ipairs(modes) do
    map_key(mode, lhs, rhs, opts)
  end
end

return { opt = opt, autocmd = autocmd, map = map, smap = smap }
