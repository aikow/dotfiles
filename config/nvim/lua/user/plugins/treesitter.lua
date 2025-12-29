local H = {}

MiniDeps.later(function()
  MiniDeps.add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    monitor = "main",
    hooks = { post_checkout = function() vim.cmd.TSUpdate() end },
  })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "User: enable treesitter highlighting",
    callback = function(params)
      local hasStarted = pcall(vim.treesitter.start)

      if hasStarted and not vim.list_contains({ "python" }, params.match) then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })

  vim.api.nvim_create_user_command(
    "TSInstallEssential",
    function() require("nvim-treesitter").install(H.basic_parsers) end,
    { desc = "TS install essential parsers" }
  )

  vim.api.nvim_create_user_command("TSInstallAll", function()
    local parsers = require("nvim-treesitter").get_available()
    require("nvim-treesitter").install(parsers)
  end, { desc = "TS install all parsers" })
end)

MiniDeps.later(function()
  MiniDeps.add({
    source = "nvim-treesitter/nvim-treesitter-textobjects",
    checkout = "main",
    monitor = "main",
  })

  vim.keymap.set({ "n", "x", "o" }, "]]", H.goto_next_start("@class.outer"))
  vim.keymap.set({ "n", "x", "o" }, "][", H.goto_next_end("@class.outer"))
  vim.keymap.set({ "n", "x", "o" }, "[[", H.goto_prev_start("@class.outer"))
  vim.keymap.set({ "n", "x", "o" }, "[]", H.goto_prev_end("@class.outer"))

  vim.keymap.set({ "n", "x", "o" }, "]m", H.goto_next_start("@function.outer"))
  vim.keymap.set({ "n", "x", "o" }, "]M", H.goto_next_end("@function.outer"))
  vim.keymap.set({ "n", "x", "o" }, "[m", H.goto_prev_start("@function.outer"))
  vim.keymap.set({ "n", "x", "o" }, "[M", H.goto_prev_end("@function.outer"))

  vim.keymap.set("n", "]p", H.swap_next("@parameter.inner"))
  vim.keymap.set("n", "[p", H.swap_prev("@parameter.outer"))
end)

MiniDeps.later(function()
  MiniDeps.add({ source = "nvim-treesitter/nvim-treesitter-context" })
  require("treesitter-context").setup({
    enable = true,
    max_lines = 8,
    multiline_threshold = 1,
    trim_scope = "inner",
  })
end)

-- ------------------------------------------------------------------------
-- | Helpers
-- ------------------------------------------------------------------------

-- stylua: ignore
H.basic_parsers = { "bash", "c", "comment", "cpp", "fish", "julia", "json", "lua", "markdown",
  "python", "query", "regex", "rust", "sql", "toml", "vim", "vimdoc", "yaml", "zig" }

function H.goto_next_start(capname, group)
  return function()
    require("nvim-treesitter-textobjects.move").goto_next_start(capname, group or "textobjects")
  end
end

function H.goto_next_end(capname, group)
  return function()
    require("nvim-treesitter-textobjects.move").goto_next_start(capname, group or "textobjects")
  end
end

function H.goto_prev_start(capname, group)
  return function()
    require("nvim-treesitter-textobjects.move").goto_next_start(capname, group or "textobjects")
  end
end

function H.goto_prev_end(capname, group)
  return function()
    require("nvim-treesitter-textobjects.move").goto_next_start(capname, group or "textobjects")
  end
end

function H.swap_next(textobj)
  return function() require("nvim-treesitter-textobjects.swap").swap_next(textobj) end
end

function H.swap_prev(textobj)
  return function() require("nvim-treesitter-textobjects.swap").swap_previous(textobj) end
end
