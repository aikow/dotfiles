safely("later", function()
  local minipick = require("mini.pick")

  local copy = {
    char = "<C-y>",
    func = function()
      vim.fn.setreg("", minipick.get_picker_matches().current)
      return false -- Do not stop the picker
    end,
  }

  minipick.setup({
    options = {
      use_cache = false,
    },
    mappings = {
      copy = copy,
    },
  })

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
    local choose_from_dir = function(item) builtin.files(nil, { source = { cwd = item } }) end
    builtin.cli(
      { command = { "lsgit", workspace } },
      { source = { name = "Projects", choose = choose_from_dir } }
    )
  end

  local todo_comments = function() builtin.grep({ pattern = [[\b(?:TODO|NOTE|HACK|FIXME|PERF)\b]] }) end

  -- Search for a file that has the name of <cfile> under the cursor.
  local find_filename = function()
    local fname = vim.fn.expand("<cfile>")
    builtin.cli(
      { command = { "fd", "--fixed-strings", fname } },
      { source = { name = string.format("Filename (%s)", fname) } }
    )
  end

  -- Add a mapping to the builtin buffers picker to delete the currently selected buffers
  local buffers = function()
    local wipeout_cur = function()
      vim.api.nvim_buf_delete(minipick.get_picker_matches().current.bufnr, {})
    end
    local buffer_mappings = { wipeout = { char = "<C-d>", func = wipeout_cur } }
    builtin.buffers(nil, { mappings = buffer_mappings })
  end

  -- ---------------
  -- |   Keymaps   |
  -- ---------------
  -- stylua: ignore start
  vim.keymap.set("n", "<leader>i", builtin.resume, { desc = "Use mini.pick to reopen the picker" })

  -- Finding searching and navigating
  vim.keymap.set("n", "<leader>o",  builtin.files,     { desc = "Use mini.pick to find files" })
  vim.keymap.set("n", "<leader>O",  projects,          { desc = "Use mini.pick to find projects" })
  vim.keymap.set("n", "<leader>p",  buffers,           { desc = "Use mini.pick to find buffers" })
  vim.keymap.set("n", "<leader>fb", cur_buf_lines,     { desc = "Use mini.pick to fuzzy-find buffer lines" })
  vim.keymap.set("n", "<leader>fB", extra.buf_lines,   { desc = "Use mini.pick to fuzzy-find all buffer lines" })
  vim.keymap.set("n", "<leader>fc", extra.hipatterns,  { desc = "Find TODO highlights with mini.pick" })
  vim.keymap.set("n", "<leader>fC", todo_comments,     { desc = "Find TODO comments with mini.pick" })
  vim.keymap.set("n", "<leader>fe", extra.explorer,    { desc = "Browse files with mini.pick" })
  vim.keymap.set("n", "<leader>ff", builtin.grep_live, { desc = "Grep live with mini.pick" })
  vim.keymap.set("n", "<leader>fl", find_filename    , { desc = "Find filename under cursor with mini.pick" })
  vim.keymap.set("n", "<leader>fo", extra.oldfiles,    { desc = "Find old files with mini.pick" })
  vim.keymap.set("n", "<leader>ft", extra.treesitter,  { desc = "Find treesitter nodes with mini.pick" })
  vim.keymap.set("n", "<leader>fw", grep_curword,      { desc = "Grep word under cursor with mini.pick" })

  -- Git shortcuts
  vim.keymap.set("n", "<leader>gC", extra.git_commits,  { desc = "Find git commits with mini.pick" })
  vim.keymap.set("n", "<leader>gb", extra.git_branches, { desc = "Find git branches with mini.pick" })
  vim.keymap.set("n", "<leader>gc", git_buf_commits,    { desc = "Find buffer commits with mini.pick" })
  vim.keymap.set("n", "<leader>gh", extra.git_hunks,    { desc = "Find git hunks with mini.pick" })
  vim.keymap.set("n", "<leader>go", extra.git_files,    { desc = "Find git files with mini.pick" })
  vim.keymap.set("n", "<leader>gs", git_status,         { desc = "Find git status with mini.pick" })

  -- Vim internals shortcuts
  vim.keymap.set("n", "<leader>;",  extra.commands,     { desc = "Find Vim commands with mini.pick" })
  vim.keymap.set("n", "<leader>h/", search_history,     { desc = "Find search history with mini.pick" })
  vim.keymap.set("n", "<leader>h;", command_history,    { desc = "Find command history with mini.pick" })
  vim.keymap.set("n", "<leader>hc", extra.colorschemes, { desc = "Find colorschemes with mini.pick" })
  vim.keymap.set("n", "<leader>hh", builtin.help,       { desc = "Find help tags with mini.pick" })
  vim.keymap.set("n", "<leader>hk", extra.keymaps,      { desc = "Find keymaps with mini.pick" })
  vim.keymap.set("n", "<leader>hl", loclist,            { desc = "Find location entries with mini.pick" })
  vim.keymap.set("n", "<leader>hm", extra.manpages,     { desc = "Find man pages with mini.pick" })
  vim.keymap.set("n", "<leader>ho", extra.options,      { desc = "Find Vim options with mini.pick" })
  vim.keymap.set("n", "<leader>hq", quickfix,           { desc = "Find quickfix entries with mini.pick" })
  vim.keymap.set("n", "<leader>hr", extra.registers,    { desc = "Find registers with mini.pick" })
  vim.keymap.set("n", "<leader>hs", extra.spellsuggest, { desc = "Find spelling suggestions with mini.pick" })
end, "later")
