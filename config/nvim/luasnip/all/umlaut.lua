local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
  -- Umlauts for German.
  s({ trig = "aee", wordTrig = false, snippetType = "autosnippet" }, t("ä")),
  s({ trig = "Aee", wordTrig = false, snippetType = "autosnippet" }, t("Ä")),
  s({ trig = "oee", wordTrig = false, snippetType = "autosnippet" }, t("ö")),
  s({ trig = "Oee", wordTrig = false, snippetType = "autosnippet" }, t("Ö")),
  s({ trig = "uee", wordTrig = false, snippetType = "autosnippet" }, t("ü")),
  s({ trig = "Uee", wordTrig = false, snippetType = "autosnippet" }, t("Ü")),
  s({ trig = "bss", wordTrig = false, snippetType = "autosnippet" }, t("ß")),
}
