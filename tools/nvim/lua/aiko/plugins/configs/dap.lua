local M = {}

M.setup = function()
  local ok_dap, dap = pcall(require, "dap")
  if not ok_dap then
    return
  end

  dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
  }

  dap.configurations.python = {
    {
      -- The first three options are required by nvim-dap
      type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
      request = "launch",
      name = "Launch file",

      program = "${file}", -- This configuration will launch the current file if used.
      pythonPath = function()
        local venv = os.getenv("VIRTUAL_ENV")
        if venv then
          return vim.fn.getcwd() .. string.format("%s/bin/python", venv)
        else
          return "/usr/bin/python"
        end
      end,
    },
  }
end

return M
