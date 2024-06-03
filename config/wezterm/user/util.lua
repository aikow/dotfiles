local M = {}

---Capture command output as a single string with newlines.
---@param cmd string The command to run
---@param opts {trim: "none" | "all" | "right" | "left" | nil, normalize_line_endings: boolean?}?
---@return string
function M.capture(cmd, opts)
  opts = opts or {}
  opts.trim = opts.trim == nil and "none" or opts.trim
  opts.normalize_line_endings = opts.normalize_line_endings == nil and true
    or opts.normalize_line_endings

  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read("*a"))
  f:close()

  -- Trim each line and normalize new line characters.
  if opts.trim == "all" or opts.trim == "left" then
    s = string.gsub(s, "^%s+", "")
  end

  if opts.trim == "all" or opts.trim == "right" then
    s = string.gsub(s, "%s+$", "")
  end

  if opts.normalize_line_endings then
    s = string.gsub(s, "[\n\r]+", "\n")
  end
  return s
end

return M
