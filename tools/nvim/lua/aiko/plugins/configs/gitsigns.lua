local M = {}

M.setup = function()
  local ok_gitsigns, gitsigns = pcall(require, "gitsigns")
  if not ok_gitsigns then
    return
  end

  gitsigns.setup({
    -- signs = {
    -- 	add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
    -- 	change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
    -- 	delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
    -- 	topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
    -- 	changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
    -- },
  })

  M.mappings()
end

M.mappings = function()
  local map = vim.keymap.set

  -- Navigation
  map({ "n", "v", "o" }, "]h", function()
    return vim.wo.diff and "]c" or "<cmd>Gitsigns next_hunk<CR>"
  end, { expr = true, silent = true, desc = "go to next git hunk" })

  map({ "n", "v", "o" }, "[h", function()
    return vim.wo.diff and "[c" or "<cmd>Gitsigns prev_hunk<CR>"
  end, { expr = true, silent = true, desc = "go to previous git hunk" })

  -- Git actions related actions with <leader>g...
  map(
    { "n", "v" },
    "<leader>gs",
    "<cmd>Gitsigns stage_hunk<CR>",
    { silent = true, desc = "git stage hunk" }
  )
  map(
    { "n", "v" },
    "<leader>gr",
    "<cmd>Gitsigns reset_hunk<CR>",
    { silent = true, desc = "git reset hunk" }
  )
  map(
    "n",
    "<leader>gS",
    "<cmd>Gitsigns stage_buffer<CR>",
    { silent = true, desc = "git stage buffer" }
  )
  map(
    "n",
    "<leader>gu",
    "<cmd>Gitsigns undo_stage_hunk<CR>",
    { silent = true, desc = "git undo stage buffer" }
  )
  map(
    "n",
    "<leader>gR",
    "<cmd>Gitsigns reset_buffer<CR>",
    { silent = true, desc = "git reset buffer" }
  )
  map(
    "n",
    "<leader>gp",
    "<cmd>Gitsigns preview_hunk<CR>",
    { silent = true, desc = "git preview hunk" }
  )
  map(
    "n",
    "<leader>gl",
    "<cmd>Gitsigns toggle_current_line_blame<CR>",
    { silent = true, desc = "git toggle inline blame" }
  )
  map(
    "n",
    "<leader>gd",
    "<cmd>Gitsigns diffthis<CR>",
    { silent = true, desc = "git diff current file" }
  )
  map(
    "n",
    "<leader>gD",
    "<cmd>Gitsigns toggle_deleted<CR>",
    { silent = true, desc = "git toggle showing deleted lines" }
  )

  -- Text object
  map(
    { "o", "x" },
    "ih",
    ":<C-u>Gitsigns select_hunk<CR>",
    { silent = true, desc = "git hunk text object" }
  )
end

return M
