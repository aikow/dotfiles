local function has(x)
  return vim.fn.has(x) == 1
end

local function executable(x)
  return vim.fn.executable(x) == 1
end

local function is_wsl()
  local output = vim.fn.systemlist "uname -r"
  return not not string.find(output[1] or "", "WSL")
end

return {
  has = has,
  is_wsl = is_wsl,
  executable = executable,
}
