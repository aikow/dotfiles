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

  -- Code
  s(
    { trig = "nk", wordTrig = true, snippetType = "autosnippet" },
    { t("`"), i(1), t("`") },
    { callbacks = autoinsert_space }
  ),
  s(
    { trig = "dn", wordTrig = true, snippetType = "autosnippet" },
    { t("```"), i(1, "text"), t({ "", "" }), i(0), t({ "", "```" }) }
  ),

  -- Text formatting
  s(
    { trig = "ii", wordTrig = true, snippetType = "autosnippet" },
    { t("*"), i(1), t("*") },
    { callbacks = autoinsert_space }
  ),
  s(
    { trig = "bb", wordTrig = true, snippetType = "autosnippet" },
    { t("**"), i(1), t("**") },
    { callbacks = autoinsert_space }
  ),
  s(
    { trig = "BB", wordTrig = true, snippetType = "autosnippet" },
    { t("***"), i(1), t("***") },
    { callbacks = autoinsert_space }
  ),
}
