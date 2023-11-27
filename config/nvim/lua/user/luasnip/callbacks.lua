-- local events = require("luasnip.util.events")

local M = {}

-- Register an auto-command to insert a space after a snippet if the following
-- character is a letter.
M.autoinsert_space = {
  -- FIXME: Currently a bit broken
  -- index `-1` means the callback is on the snippet as a whole
  -- [-1] = {
  --   [events.leave] = function()
  --     vim.api.nvim_create_autocmd("InsertCharPre", {
  --       buffer = 0,
  --       once = true,
  --       callback = function()
  --         if string.find(vim.v.char, "%a") then
  --           vim.v.char = " " .. vim.v.char
  --         end
  --       end,
  --     })
  --   end,
  -- },
}

return M
