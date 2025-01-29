MiniDeps.later(function()
  MiniDeps.add({ source = "Vigemus/iron.nvim" })

  local view = require("iron.view")
  require("iron.core").setup({
    config = {
      scratch_repl = true,
      repl_open_cmd = view.split.botright("40%"),
      repl_definition = {
        nu = {
          command = { "nu" },
        },
      },
      buflisted = true,
    },
    keymaps = {
      send_motion = "<space>kk",
      visual_send = "<space>kk",
      send_file = "<space>kf",
      send_line = "<space>kl",
      send_code_block = "<space>kb",
      send_code_block_and_move = "<space>kn",
      cr = "<space>k<enter>",
      interrupt = "<space>ki",
      exit = "<space>kq",
      clear = "<space>kr",
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
  })
end)
