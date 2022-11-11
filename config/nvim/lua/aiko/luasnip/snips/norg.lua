local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local autoinsert_space = require("aiko.luasnip.callbacks").autoinsert_space

return {
  -- Math
  s(
    { trig = "mk", wordTrig = true, snippetType = "autosnippet" },
    { t("$"), i(1), t("$") },
    { callbacks = autoinsert_space }
  ),
  s(
    { trig = "dm", wordTrig = true, snippetType = "autosnippet" },
    { t({ "@math ", "" }), i(0, ""), t({ "", "@end" }) }
  ),

  -- Code
  s(
    { trig = "nk", wordTrig = true, snippetType = "autosnippet" },
    { t("`"), i(1), t("`") },
    { callbacks = autoinsert_space }
  ),
  s(
    { trig = "dn", wordTrig = true, snippetType = "autosnippet" },
    { t("@code "), i(1, "lang"), t({ "", "" }), i(0, ""), t({ "", "@end" }) }
  ),

  -- Text formatting
  s(
    { trig = "ii", wordTrig = true, snippetType = "autosnippet" },
    { t("/"), i(1), t("/") },
    { callbacks = autoinsert_space }
  ),
  s({
    trig = "bb",
    hidden = false,
    wordTrig = true,
    snippetType = "autosnippet",
  }, { t("*"), i(1), t("*") }, { callbacks = autoinsert_space }),

  -- Symbols
  s({ trig = "->", wordTrig = true, snippetType = "autosnippet" }, t("→")),
  s({ trig = "<-", wordTrig = true, snippetType = "autosnippet" }, t("←")),
}
