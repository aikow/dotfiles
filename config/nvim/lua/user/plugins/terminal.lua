local H = {}

function H.open_repl(opts, win_opts)
  win_opts = win_opts or {}
  if not win_opts.direction then win_opts.direction = "vertical" end

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  local cmd = opts.cmd
  if type(cmd) == "function" then cmd = cmd({ buf = buf }) end
  if win_opts.direction == "vertical" then
    vim.cmd.vsplit()
  else
    vim.cmd.split()
  end
  vim.cmd.term({ args = cmd })

  local term = vim.api.nvim_get_current_buf()
  local job = vim.bo[term].channel
  local pid = vim.fn.jobpid(job)

  vim.b[buf].slime_config = { jobid = job, pid = pid }

  vim.api.nvim_set_current_win(win)

  if opts.after_init then opts.after_init({ buf = buf, term = term }) end
end

function H.open_repl_rhs(lang)
  return function() H.open_repl(H.languages[lang]) end
end

H.languages = {
  ipython = {
    cmd = "python",
  },
  python = {
    cmd = "ipython",
  },
  julia = {
    cmd = function(opts)
      -- Check to see if the JULIA_PROJECT environment variable is set.
      local project = os.getenv("JUlIA_PROJECT")
      if project == "" then project = nil end
      if project == nil then project = vim.fs.root(opts.buf, "Project.toml") end

      if project then
        vim.notify("julia project: " .. project)
        return { "julia", "--interactive", "--project=" .. project }
      else
        vim.notify("julia project: default")
        return { "julia", "--interactive" }
      end
    end,
    after_init = function()
      local startup = [[
try
  using Revise
catch e
  @warn "Error initializing Revise" exception=(e, catch_backtrace())
end
]]
      vim.fn["slime#send"](startup)
    end,
  },
}

function fix_neovim_target()
  -- Redefine neovim-specific sending, to fix the bug that some terminal programs don't receive
  -- a final newline
  vim.cmd.runtime({ "autoload/slime/targets/neovim.vim" })
  vim.cmd([[
    function! slime#targets#neovim#send(config, text) abort
      let [bracketed_paste, text_to_paste, has_crlf] = slime#common#bracketed_paste(a:text)
      let job_id = str2nr(a:config["jobid"])
      if bracketed_paste
        call chansend(job_id, "\e[200~")
        call chansend(job_id, text_to_paste)
        call chansend(job_id, "\e[201~")
        if has_crlf
          call chansend(job_id, "\r")
        end
      else
        call chansend(job_id, split(a:text, "\r", 1))
      end
    endfunction
  ]])
end

MiniDeps.later(function()
  -- Need to be set before slime is loaded
  vim.g.slime_target = "neovim"
  vim.g.slime_no_mappings = true

  MiniDeps.add({ source = "jpalardy/vim-slime" })

  fix_neovim_target()

  vim.g.slime_bracketed_paste = true

  -- Neovim terminal configuration settings
  vim.g.slime_suggest_default = false
  vim.g.slime_menu_config = true
  vim.g.slime_neovim_ignore_unlisted = true

  -- Mappings
  vim.keymap.set("x", "<leader>k", "<Plug>SlimeRegionSend", { desc = "slime send region" })
  vim.keymap.set("n", "<leader>k", "<Plug>SlimeMotionSend", { desc = "slime send motion" })
  vim.keymap.set("n", "<leader>kl", "<Plug>SlimeLineSend", { desc = "slime send line" })
  vim.keymap.set("n", "<leader>kc", "<Plug>SlimeSendCell", { desc = "slime send cell" })
  vim.keymap.set("n", "<leader>kC", "<Plug>SlimeConfig", { desc = "slime config" })
  vim.keymap.set(
    "n",
    "<leader>k<cr>",
    function() vim.fn["slime#send"]("\n") end,
    { desc = "slime new line" }
  )

  vim.keymap.set("n", "<leader>krj", H.open_repl_rhs("julia"), { desc = "slime open repl julia" })
  vim.keymap.set(
    "n",
    "<leader>kri",
    H.open_repl_rhs("ipython"),
    { desc = "slime open repl ipython" }
  )
  vim.keymap.set("n", "<leader>krp", H.open_repl_rhs("python"), { desc = "slime open repl python" })
end)
