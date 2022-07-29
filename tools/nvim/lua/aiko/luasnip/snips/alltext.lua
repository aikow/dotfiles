local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {}, {
  -- Umlauts for German.
  s({ trig = "aee", wordTrig = false }, t("ä")),
  s({ trig = "Aee", wordTrig = false }, t("Ä")),
  s({ trig = "oee", wordTrig = false }, t("ö")),
  s({ trig = "Oee", wordTrig = false }, t("Ö")),
  s({ trig = "uee", wordTrig = false }, t("ü")),
  s({ trig = "Uee", wordTrig = false }, t("Ü")),
  s({ trig = "bss", wordTrig = false }, t("ß")),
}
