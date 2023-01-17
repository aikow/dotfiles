return {
  -- Debug adapter protocol.
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
    },
    -- stylua: ignore
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "dap continue", },
      { "<F10>", function() require("dap").step_over() end, desc = "dap step over", },
      { "<F11>", function() require("dap").step_into() end, desc = "dap step into", },
      { "<F12>", function() require("dap").step_out() end, desc = "dap step out", },
      { "<Leader>bb", function() require("dap").toggle_breakpoint() end, desc = "dap toggle breakpoint", },
      {
        "<Leader>bc",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "dap set breakpoint with condition",
      },
      {
        "<Leader>bB",
        function()
          require("dap").set_breakpoint(
            nil,
            nil,
            vim.fn.input("Log point message: ")
          )
        end,
        desc = "dap set break point with log point message",
      },
      { "<Leader>bo", function() require("dap").repl.open() end, desc = "dap open", },
      { "<Leader>bl", function() require("dap").run_last() end, desc = "dap run last", },
    },
    config = function()
      local dap = require("dap")

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
    end,
  },

  -- UI elements for nvim-dap.
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    config = function()
      require("dapui").setup({})
    end,
  },

  -- Insert virtual text during debugging for variable values.
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end,
  },

  -- DAP configuration for python.
  {
    "mfussenegger/nvim-dap-python",
    lazy = true,
    config = function()
      require("dap-python").setup(
        "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      )
    end,
  },
}
