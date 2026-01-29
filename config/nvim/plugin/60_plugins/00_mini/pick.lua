MiniDeps.later(function()
  local minipick = require("mini.pick")
  minipick.setup({ options = { use_cache = true } })

  -- -----------------
  -- |   MiniExtra   |
  -- -----------------
  local miniextra = require("mini.extra")
  miniextra.setup({})

  -- ----------------------
  -- |   Custom Pickers   |
  -- ----------------------
  local extra = miniextra.pickers
  local builtin = minipick.builtin

  local command_history = function() extra.history({ scope = ":" }) end
  local cur_buf_lines = function() extra.buf_lines({ scope = "current" }) end
  local git_buf_commits = function() extra.git_commits({ path = vim.fn.expand("%") }) end
  local git_status = function() builtin.cli({ command = { "git", "diff", "--name-only" } }) end
  local grep_curword = function() builtin.grep({ pattern = vim.fn.expand("<cword>") }) end
  local loclist = function() extra.list({ scope = "location" }) end
  local quickfix = function() extra.list({ scope = "quickfix" }) end
  local search_history = function() extra.history({ scope = "/" }) end
  local projects = function()
    local workspace = os.getenv("WORKSPACE_HOME") or vim.fs.normalize("~/workspace")
    builtin.cli({
      command = { "lsgit", workspace },
    }, {
      source = {
        choose = function(item)
          builtin.files({}, {
            source = { cwd = item },
          })
        end,
      },
    })
  end
  local todo_comments = function()
    builtin.grep({
      pattern = [[\b(?:TODO|NOTE|HACK|FIXME|PERF)\b]],
    })
  end

-- ---------------
-- |   Keymaps   |
-- ---------------
-- stylua: ignore start
vim.keymap.set("n", "<leader>i", builtin.resume, { desc = "mini.pick reopen last picker" })

-- mini.visits
vim.keymap.set("n", "<leader>jl", extra.visit_labels, { desc = "mini.pick visit labels" })
vim.keymap.set("n", "<leader>jj", extra.visit_paths,  { desc = "mini.pick visit paths" })

-- Finding searching and navigating
vim.keymap.set("n", "<leader>o",  builtin.files,     { desc = "mini.pick find files" })
vim.keymap.set("n", "<leader>O",  projects,          { desc = "mini.pick projects" })
vim.keymap.set("n", "<leader>p",  builtin.buffers,   { desc = "mini.pick buffers" })
vim.keymap.set("n", "<leader>fB", extra.buf_lines,   { desc = "mini.pick all buffer fuzzy find" })
vim.keymap.set("n", "<leader>fb", cur_buf_lines,     { desc = "mini.pick buffer fuzzy find" })
vim.keymap.set("n", "<leader>fe", extra.explorer,    { desc = "mini.pick explore" })
vim.keymap.set("n", "<leader>ff", builtin.grep_live, { desc = "mini.pick live grep" })
vim.keymap.set("n", "<leader>fo", extra.oldfiles,    { desc = "mini.pick oldfiles" })
vim.keymap.set("n", "<leader>ft", extra.treesitter,  { desc = "mini.pick treesitter nodes" })
vim.keymap.set("n", "<leader>fn", extra.hipatterns,  { desc = "mini.pick todo hipatterns" })
vim.keymap.set("n", "<leader>fN", todo_comments,     { desc = "mini.pick todo comments" })
vim.keymap.set("n", "<leader>fw", grep_curword,      { desc = "mini.pick grep word under cursor" })

-- Git shortcuts
vim.keymap.set("n", "<leader>gC", extra.git_commits,  { desc = "mini.pick git commits" })
vim.keymap.set("n", "<leader>gb", extra.git_branches, { desc = "mini.pick git branches" })
vim.keymap.set("n", "<leader>gc", git_buf_commits,    { desc = "mini.pick git buffer commits" })
vim.keymap.set("n", "<leader>gh", extra.git_hunks,    { desc = "mini.pick hunks" })
vim.keymap.set("n", "<leader>go", extra.git_files,    { desc = "mini.pick git files" })
vim.keymap.set("n", "<leader>gs", git_status,         { desc = "mini.pick git status" })

-- Vim internals shortcuts
vim.keymap.set("n", "<leader>;",  extra.commands,     { desc = "mini.pick vim commands" })
vim.keymap.set("n", "<leader>h/", search_history,     { desc = "mini.pick search history" })
vim.keymap.set("n", "<leader>h;", command_history,    { desc = "mini.pick command history" })
vim.keymap.set("n", "<leader>hc", extra.colorschemes, { desc = "mini.pick colorschemes" })
vim.keymap.set("n", "<leader>hh", builtin.help,       { desc = "mini.pick help tags" })
vim.keymap.set("n", "<leader>hk", extra.keymaps,      { desc = "mini.pick keymaps" })
vim.keymap.set("n", "<leader>hl", loclist,            { desc = "mini.pick loclist" })
vim.keymap.set("n", "<leader>hm", extra.manpages,     { desc = "mini.pick man pages" })
vim.keymap.set("n", "<leader>ho", extra.options,      { desc = "mini.pick vim options" })
vim.keymap.set("n", "<leader>hq", quickfix,           { desc = "mini.pick quickfix" })
vim.keymap.set("n", "<leader>hr", extra.registers,    { desc = "mini.pick registers" })
vim.keymap.set("n", "<leader>hs", extra.spellsuggest, { desc = "mini.pick spell suggest" })
end)
