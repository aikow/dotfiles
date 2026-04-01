local H = {}

safely("later", function()
  vim.pack.add({
    { src = gh("stevearc/conform.nvim") },
  })

  require("conform").setup({
    default_format_opts = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    format_on_save = false,
    formatters_by_ft = {
      bash = { "shfmt" },
      c = { "clangd" },
      cpp = { "clangd" },
      css = { "prettier" },
      fish = { "fish_indent" },
      html = { "prettier" },
      htmldjango = { "prettier" },
      json = { "jq" },
      lua = { "stylua" },
      -- markdown = { "prettier" },
      python = { "ruff_fix", "ruff_format" },
      sh = { "shfmt" },
      sql = { "sql_formatter" },
      yaml = { "prettier" },
    },
    formatters = {
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
          "--apply-ignore",
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

  -- stylua: ignore start
  vim.keymap.set({ "n", "x" }, "<leader>rf", H.format, { desc = "Format" })
  vim.keymap.set({ "n", "x" }, "<leader>rF", H.format_injections, { desc = "Format with injections" })
  -- stylua: ignore end
end)

function H.format() require("conform").format({ async = true, lsp_fallback = true }) end

function H.format_injections()
  require("conform").format({
    async = true,
    lsp_fallback = true,
    formatters = { "injected" },
  })
end
