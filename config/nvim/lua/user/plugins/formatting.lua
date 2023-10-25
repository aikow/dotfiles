return {
  {
    "stevearc/conform.nvim",
    dependencies = {
      "mason.nvim",
    },
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>rf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "x" },
        desc = "Format the current buffer",
      },
      {
        "<leader>rF",
        function()
          require("conform").format({
            async = true,
            lsp_fallback = true,
            formatters = { "injected" },
          })
        end,
        mode = { "n", "x" },
        desc = "Format the current buffer",
      },
    },
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        bash = { "shfmt" },
        c = { "clangd" },
        cpp = { "clangd" },
        fish = { "fish_indent" },
        json = { "jq" },
        lua = { "stylua" },
        markdown = { { "prettierd", "prettier" } },
        python = { "isort", "black" },
        sh = { "shfmt" },
        sql = { "sql_formatter" },
        yaml = { { "prettierd", "prettier" } },
      },
      formatters = {
        black = {
          prepend_args = { "--preview" },
        },
        isort = {
          prepend_args = { "--profile=black" },
        },
        shfmt = {
          prepend_args = {
            "--binary-next-line",
            "--case-indent",
            "--indent",
            "2",
            "--simplify",
          },
        },
        sql_formatter = {
          prepend_args = function()
            -- Override the default dialect using a buffer-local variable
            -- (`sqllanguage`).
            return { "-l", vim.b[0].sqllanguage or "sqlite" }
          end,
        },
        stylua = {},
      },
    },
  },
}
