local H = {}

function H.julia_command(meta)
  local buf = vim.api.nvim_buf_get_name(meta.current_bufnr)

  -- Check to see if the JULIA_PROJECT environment variable is set.
  local project = os.getenv("JUlIA_PROJECT")
  if project == "" then project = nil end

  if project == nil then
    project = vim.fs.root(buf, "Project.toml")
  end

  local startup = [[
    try
      using Revise
    catch e
      @warn "Error initializing Revise" exception=(e, catch_backtrace())
    end
  ]]

  if project then
    vim.notify("julia project: " .. project)
    return { "julia", '--interactive', "--project=" .. project, "--eval", startup }
  else
    vim.notify("julia project: default")
    return { "julia", "--interactive", "--eval", startup }
  end
end

MiniDeps.later(function()
  MiniDeps.add({ source = "Vigemus/iron.nvim" })

  local view = require("iron.view")
  require("iron.core").setup({
    config = {
      scratch_repl = true,
      repl_open_cmd = view.split.botright("40%"),
      repl_definition = {
        julia = { command = H.julia_command },
        nu = { command = { "nu" } },
        bash = { command = { "bash" } },
      },
      buflisted = true,
    },
    keymaps = {
      send_motion = "<space>kk",
      visual_send = "<space>kk",
      send_file = "<space>kf",                -- (f)ile
      send_line = "<space>kl",                -- (l)ine
      send_code_block = "<space>kb",          -- (b)lock
      send_code_block_and_move = "<space>kn", -- (n)ext block
      send_mark = "<space>ks",                -- (s)end mark
      send_until_cursor = "<space>ku",        -- (u)ntil cursor
      mark_motion = "<space>km",              -- (m)ark
      mark_visual = "<space>km",              -- (m)ark
      remove_mark = "<space>kc",              -- (c)lear mark
      cr = "<space>k<enter>",
      interrupt = "<space>kI",                -- (I)nterrupt
      exit = "<space>kq",                     -- (q)uit)
      clear = "<space>kr",                    -- (C)lear
    },
    ignore_blank_lines = true,                -- ignore blank lines when sending visual select lines
  })

  vim.keymap.set("n", "<leader>ko", "<cmd>IronRepl<CR>", { desc = "iron_repl_open" })
end)
