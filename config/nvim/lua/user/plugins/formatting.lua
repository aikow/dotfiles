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
        fish = { "fish_indent" },
        json = { "jq" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        python = { "isort", "black" },
        sh = { "shfmt" },
        sql = { "sql_formatter" },
        yaml = { "prettierd" },
      },
      formatters = {
        {
          black = {
            prepend_args = { "--preview" },
          },
          fish_indent = {},
          isort = {
            with = { extra_args = { "--profile=black" } },
          },
          jq = {},
          shfmt = {
            extra_args = { "--indent", "2", "--case-indent" },
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
  },
}
