local H = {}

MiniDeps.later(function()
  MiniDeps.add({
    source = "stevearc/conform.nvim",
    depends = { "mason-org/mason.nvim" },
  })

  require("conform").setup({
    default_format_opts = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    format_on_save = H.format_on_save,
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
      -- markdown = { "prettierd" },
      python = { "ruff_fix", "ruff_format" },
      sh = { "shfmt" },
      sql = { "sql_formatter" },
      yaml = { "prettierd" },
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
  vim.keymap.set({ "n", "x" }, "<leader>rf", H.format,               { desc = "Format" })
  vim.keymap.set({ "n", "x" }, "<leader>rF", H.format_injections,    { desc = "Format with injections" })
  vim.keymap.set("n",          "<leader>tf", H.toggle_format,        { desc = "Toggle format on save" })
  vim.keymap.set("n",          "<leader>tF", H.toggle_format_global, { desc = "Toggle global format on save" })
  -- stylua: ignore end
end)

---Enable format on save, respecting the buffer and global autoformat toggles.
function H.format_on_save(bufid)
  if vim.g.autoformat_enable ~= false and vim.b[bufid].autoformat_enable ~= false then return {} end
end

function H.format() require("conform").format({ async = true, lsp_fallback = true }) end

function H.format_injections()
  require("conform").format({
    async = true,
    lsp_fallback = true,
    formatters = { "injected" },
  })
end

function H.toggle_format()
  local bufid = vim.api.nvim_get_current_buf()
  if vim.b[bufid].autoformat_enable == nil then
    vim.b[bufid].autoformat_enable = false
  else
    vim.b[bufid].autoformat_enable = not vim.b[bufid].autoformat_enable
  end
end

function H.toggle_format_global()
  if vim.g.autoformat_enable == nil then
    vim.g.autoformat_enable = false
  else
    vim.g.autoformat_enable = not vim.g.autoformat_enable
  end
end
