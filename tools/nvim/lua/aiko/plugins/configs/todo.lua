local M = {}

M.setup = function ()
  local ok_todo, todo = pcall(require, "todo-comments")
  if not ok_todo then
    return
  end

  todo.setup({
    signs = true,
    sign_priority = 1,
  })
end

return M
