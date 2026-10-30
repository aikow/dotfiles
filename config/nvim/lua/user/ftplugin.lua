local M = {}

---Append cleanup without replacing the runtime ftplugin's cleanup.
---@param command string|string[] Ex commands to run when the filetype changes.
function M.undo(command)
  local commands = type(command) == "table" and command or { command }
  -- :unmap consumes bars as part of its arguments, so execute each action
  -- separately before joining it to the runtime's cleanup command.
  command = table.concat(
    vim.tbl_map(function(action) return "execute " .. vim.fn.string(action) end, commands),
    " | "
  )
  local previous = vim.b.undo_ftplugin
  vim.b.undo_ftplugin = previous and previous .. " | " .. command or command
end

return M
