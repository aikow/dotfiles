local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l

-- ------------------------
-- |   Helper functions   |
-- ------------------------
local import_name = function(index)
  return f(function(args)
    local parts = vim.split(args[1][1], ".", { plain = true, trimempty = true })
    local name = parts[#parts] or ""
    return name:lower():gsub("-", "_")
  end, { index })
end

-- ----------------
-- |   Snippets   |
-- ----------------
return {
  s(
    "req",
    fmt([[local {2} = require("{1}")]], {
      i(1),
      import_name(1),
    })
  ),

  s(
    "sreq",
    fmt(
      [[
        local ok_{2}, {2} = pcall(require, "{1}")
        if not ok_{2} then
          {3}
        end
      ]],
      {
        i(1),
        import_name(1),
        c(2, {
          t("return"),
          t("error()"),
          i(nil, "-- TODO:"),
        }),
      }
    )
  ),
}
