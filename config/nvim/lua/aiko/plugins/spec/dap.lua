return {
  -- -----------------
  -- |   Debugging   |
  -- -----------------
  --
  -- Debug adapter protocol.
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        silent = true,
        desc = "dap continue",
      },

      {
        "<F10>",
        [[lua require("dap").step_over()]],
        silent = true,
        desc = "dap step over",
      },

      {
        "<F11>",
        [[lua require("dap").step_into()]],
        silent = true,
        desc = "dap step into",
      },

      {
        "<F12>",
        [[lua require("dap").step_out()]],
        silent = true,
        desc = "dap step out",
      },

      {
        "<Leader>bb",
        [[lua require("dap").toggle_breakpoint()]],
        silent = true,
        desc = "dap toggle breakpoint",
      },

      {
        "<Leader>bc",
        [[lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))]],
        silent = true,
        desc = "dap set breakpoint with condition",
      },

      {
        "<Leader>bB",
        [[lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))]],
        silent = true,
        desc = "dap set break point with log point message",
      },

      {
        "<Leader>bo",
        [[lua require("dap").repl.open()]],
        silent = true,
        desc = "dap open",
      },

      {
        "<Leader>bl",
        [[lua require("dap").run_last()]],
        silent = true,
        desc = "dap run last",
      },
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
      require("dapui").setup()
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
