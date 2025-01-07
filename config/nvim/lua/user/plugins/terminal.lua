MiniDeps.later(function()
  MiniDeps.add({ source = "Vigemus/iron.nvim" })

  local view = require("iron.view")
  require("iron.core").setup({
    config = {
      scratch_repl = true,
      repl_open_cmd = view.split.botright("40%"),
    },
    keymaps = {
      send_motion = "<space>kk",
      visual_send = "<space>kk",
      send_file = "<space>kf",
      send_line = "<space>kl",
      cr = "<space>k<cr>",
      interrupt = "<space>ki",
      exit = "<space>kq",
      clear = "<space>kr",
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
  })
end)
