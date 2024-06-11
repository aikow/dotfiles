local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- local autoinsert_space = require("user.luasnip.callbacks").autoinsert_space

return {
  s({ trig = "file", wordTrig = true }, {
    t("["),
    i(1, "path"),
    t("](./"),
    f(function(args)
      print(args)
      return args[1][1]
    end, { 1 }),
    t(")"),
  }),

  -- Math
  s({ trig = "mk", wordTrig = true, snippetType = "autosnippet" }, { t("$"), i(1), t("$") }),

  -- Code
  s({ trig = "nk", wordTrig = true, snippetType = "autosnippet" }, { t("`"), i(1), t("`") }),
  s(
    { trig = "dn", wordTrig = true, snippetType = "autosnippet" },
    { t("```"), i(1, "text"), t({ "", "" }), i(0), t({ "", "```" }) }
  ),

  -- Text formatting
  s({ trig = "ii", wordTrig = true, snippetType = "autosnippet" }, { t("*"), i(1), t("*") }),
  s({ trig = "bb", wordTrig = true, snippetType = "autosnippet" }, { t("**"), i(1), t("**") }),
  s({ trig = "BB", wordTrig = true, snippetType = "autosnippet" }, { t("***"), i(1), t("***") }),
}
