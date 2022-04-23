local function has(x)
  return vim.fn.has(x) == 1
end

local function executable(x)
  return vim.fn.executable(x) == 1
end

local is_wsl = (function()
  local output = vim.fn.systemlist "uname -r"
  return not not string.find(output[1] or "", "WSL")
end)()

return {
  has = has,
  executable = executable,
}
