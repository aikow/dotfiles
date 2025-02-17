MiniDeps.later(function()
  MiniDeps.add({
    source = "saghen/blink.cmp",
    depends = { "rafamadriz/friendly-snippets" },
    hooks = {
      post_checkout = function(params)
        local proc = vim
          .system({ "rustup", "run", "nightly", "cargo", "build", "--release" }, { cwd = params.path })
          :wait()
        if proc.code == 0 then
          vim.notify("Building blink.cmp done", vim.log.levels.INFO)
        else
          vim.notify("Building blink.cmp failed\n" .. proc.stderr, vim.log.levels.ERROR)
        end
      end,
    },
  })

  require("blink.cmp").setup({
    completion = {
      list = { selection = { auto_insert = true } },
      trigger = { show_on_insert_on_trigger_character = false },
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
    snippets = { preset = "mini_snippets" },
    sources = { default = { "lsp", "buffer" } },
    cmdline = { sources = {} },
    signature = { enabled = true },
  })
end)
