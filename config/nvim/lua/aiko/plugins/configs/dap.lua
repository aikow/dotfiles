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

  M.mappings()
end

M.mappings = function()
  local map = vim.keymap.set
  -- -----------------------------------
  -- |   Nvim Debug Adapter Protocol   |
  -- -----------------------------------
  map("n", "<F5>", function()
    require("dap").continue()
  end, { silent = true, desc = "dap continue" })

  map("n", "<F10>", function()
    require("dap").step_over()
  end, { silent = true, desc = "dap step over" })

  map("n", "<F11>", function()
    require("dap").step_into()
  end, { silent = true, desc = "dap step into" })

  map("n", "<F12>", function()
    require("dap").step_out()
  end, { silent = true, desc = "dap step out" })

  map("n", "<Leader>bb", function()
    require("dap").toggle_breakpoint()
  end, { silent = true, desc = "dap toggle breakpoint" })

  map("n", "<Leader>bc", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, { silent = true, desc = "dap set breakpoint with condition" })

  map("n", "<Leader>bB", function()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end, { silent = true, desc = "dap set break point with log point message" })

  map("n", "<Leader>bo", function()
    require("dap").repl.open()
  end, { silent = true, desc = "dap open" })

  map("n", "<Leader>bl", function()
    require("dap").run_last()
  end, { silent = true, desc = "dap run last" })
end

return M
