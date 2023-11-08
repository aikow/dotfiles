local util = require("user.util")

local M = {}

---@alias os "darwin" | "linux" | "windows" | "unknown"

---Returns the current OS name.
---@return os
M.os = function()
  local uname = util.capture("uname", { trim = "all" }):lower()
  if uname == "darwin" then
    return "darwin"
  elseif uname == "linux" then
    return "linux"
  elseif uname == "windows" then
    return "windows"
  end

  return "unknown"
end

return M
