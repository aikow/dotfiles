local H = {}

MiniDeps.now(function()
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local name = ev.data.spec.name
      if name == "nvim-treesitter/nvim-treesitter" then
        vim.notify("[treesitter] Update parsers", vim.log.levels.INFO)
        vim.cmd.TSUpdate()
      end
    end,
  })

  vim.pack.add({
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
    { src = gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
    { src = gh("nvim-treesitter/nvim-treesitter-context") },
  })

  vim.api.nvim_create_autocmd("FileType", {
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

-- ------------------------------------------------------------------------
-- | Textobjects
-- ------------------------------------------------------------------------
MiniDeps.later(function()

  -- stylua: ignore start
  vim.keymap.set({"n", "x", "o"}, "]]", H.goto_next_start("@class.outer"),    {desc="next class"    })
  vim.keymap.set({"n", "x", "o"}, "][", H.goto_next_end("@class.outer"),      {desc="next class end"})
  vim.keymap.set({"n", "x", "o"}, "[[", H.goto_prev_start("@class.outer"),    {desc="prev class"    })
  vim.keymap.set({"n", "x", "o"}, "[]", H.goto_prev_end("@class.outer"),      {desc="prev class end"})

  vim.keymap.set({"n", "x", "o"}, "]m", H.goto_next_start("@function.outer"), {desc="next function"    })
  vim.keymap.set({"n", "x", "o"}, "]M", H.goto_next_end("@function.outer"),   {desc="next function end"})
  vim.keymap.set({"n", "x", "o"}, "[m", H.goto_prev_start("@function.outer"), {desc="prev function"    })
  vim.keymap.set({"n", "x", "o"}, "[M", H.goto_prev_end("@function.outer"),   {desc="prev function end"})

  vim.keymap.set("n",             "]p", H.swap_next("@parameter.inner"),      {desc="swap parameter forward" })
  vim.keymap.set("n",             "[p", H.swap_prev("@parameter.inner"),      {desc="swap parameter backward"})
  -- stylua: ignore end
end)

-- ------------------------------------------------------------------------
-- | Context
-- ------------------------------------------------------------------------
MiniDeps.later(
  function()
    require("treesitter-context").setup({
      enable = true,
      max_lines = 8,
      multiline_threshold = 1,
      trim_scope = "inner",
    })
  end
)

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
    require("nvim-treesitter-textobjects.move").goto_next_end(capname, group or "textobjects")
  end
end

function H.goto_prev_start(capname, group)
  return function()
    require("nvim-treesitter-textobjects.move").goto_previous_start(capname, group or "textobjects")
  end
end

function H.goto_prev_end(capname, group)
  return function()
    require("nvim-treesitter-textobjects.move").goto_previous_end(capname, group or "textobjects")
  end
end

function H.swap_next(textobj)
  return function() require("nvim-treesitter-textobjects.swap").swap_next(textobj) end
end

function H.swap_prev(textobj)
  return function() require("nvim-treesitter-textobjects.swap").swap_previous(textobj) end
end
