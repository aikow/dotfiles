local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmta = require("luasnip.extras.fmt").fmta
local extras = require("luasnip.extras")
local rep = extras.rep
local l = extras.lambda
local m = extras.match
local dl = extras.dynamic_lambda
local ne = extras.nonempty

local autoinsert_space = require("aiko.luasnip.callbacks").autoinsert_space

return {},
  {
    -- Math
    s(
      { trig = "mk", wordTrig = true },
      { t("$"), i(1), t("$") },
      { callbacks = autoinsert_space }
    ),

    -- Code
    s(
      { trig = "nk", wordTrig = true },
      { t("`"), i(1), t("`") },
      { callbacks = autoinsert_space }
    ),
    s(
      { trig = "dn", wordTrig = true },
      { t("```"), i(1, "text"), t({ "", "" }), i(0), t({ "", "```" }) }
    ),

    -- Text formatting
    s(
      { trig = "ii", wordTrig = true },
      { t("*"), i(1), t("*") },
      { callbacks = autoinsert_space }
    ),
    s(
      { trig = "bf", wordTrig = true },
      { t("**"), i(1), t("**") },
      { callbacks = autoinsert_space }
    ),
    s(
      { trig = "BB", wordTrig = true },
      { t("***"), i(1), t("***") },
      { callbacks = autoinsert_space }
    ),
  }
