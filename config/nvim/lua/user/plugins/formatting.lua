MiniDeps.later(function()
  MiniDeps.add({
    source = "stevearc/conform.nvim",
  })

  require("conform").setup({
    default_format_opts = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    format_on_save = function(bufid)
      if vim.g.autoformat_enable ~= false and vim.b[bufid].autoformat_enable ~= false then
        return {}
      end
    end,
    formatters_by_ft = {
      bash = { "shfmt" },
      c = { "clangd" },
      cpp = { "clangd" },
      css = { "prettierd" },
      fish = { "fish_indent" },
      html = { "prettierd" },
      htmldjango = { "prettierd" },
      json = { "jq" },
      lua = { "stylua" },
      markdown = { "prettierd" },
      python = { "ruff_fix", "ruff_format" },
      sh = { "shfmt" },
      sql = { "sql_formatter" },
      yaml = { "prettierd" },
    },
    formatters = {
      black = {
        prepend_args = { "--preview" },
      },
      ruff_fix = {
        args = {
          "check",
          "--fix",
          "--unfixable",
          "ARG,F401",
          "--force-exclude",
          "--exit-zero",
          "--no-cache",
          "--stdin-filename",
          "$FILENAME",
          "-",
        },
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
    },
  })

  vim.keymap.set(
    { "n", "x" },
    "<leader>rf",
    function() require("conform").format({ async = true, lsp_fallback = true }) end,
    { desc = "Format the current buffer" }
  )
  vim.keymap.set(
    { "n", "x" },
    "<leader>rF",
    function()
      require("conform").format({
        async = true,
        lsp_fallback = true,
        formatters = { "injected" },
      })
    end,
    { desc = "Format the current buffer with tree-sitter injections" }
  )
  vim.keymap.set("n", "<leader>tf", function()
    local bufid = vim.api.nvim_get_current_buf()
    if vim.b[bufid].autoformat_enable == nil then
      vim.b[bufid].autoformat_enable = false
    else
      vim.b[bufid].autoformat_enable = not vim.b[bufid].autoformat_enable
    end
  end, { desc = "toggle format on save" })
  vim.keymap.set("n", "<leader>tF", function()
    if vim.g.autoformat_enable == nil then
      vim.g.autoformat_enable = false
    else
      vim.g.autoformat_enable = not vim.g.autoformat_enable
    end
  end, { desc = "toggle global format on save" })
end)
