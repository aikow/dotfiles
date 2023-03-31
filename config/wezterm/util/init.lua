local M = {}

---Capture command output as a single string with newlines.
---@param cmd string The command to run
---@return string
M.capture = function(cmd, opts)
  opts = opts or {}
  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read("*a"))
  f:close()

  -- Trim each line and normalize new line characters.
  if opts.trim or true then
    s = string.gsub(s, "^%s+", "")
    s = string.gsub(s, "%s+$", "")
  end

  if opts.normalize_line_endings or true then
    s = string.gsub(s, "[\n\r]+", "\n")
  end
  return s
end

return M
