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

local replace = function(index, char)
  return f(function(arg)
    return string.rep(char, string.len(arg[1][1]))
  end, { index })
end

local comment = function()
  return f(function()
    local cs = vim.o.commentstring
    local parts = vim.split(cs, "%s", true)
    local start, ending = parts[1], parts[2]
    return start
  end, {})
end

return {
  s(
    "lsep",
    fmt(
      [[
    {2} ------------------------------------------------------------------------
    {2} | {1}
    {2} ------------------------------------------------------------------------
  ]],
      { i(1), comment() }
    )
  ),

  s(
    "box",
    fmt(
      [[
    {3} ----{2}----
    {3} |   {1}   |
    {3} ----{2}----
  ]],
      { i(1), replace(1, "-"), comment() }
    )
  ),

  s(
    "bbox",
    fmt(
      [[
    {4} ====={2}=====
    {4} |===={2}====|
    {4} ||   {3}   ||
    {4} ||   {1}   ||
    {4} ||   {3}   ||
    {4} |===={2}====|
    {4} ====={2}=====
  ]],
      { i(1), replace(1, "="), replace(1, " "), comment() }
    )
  ),
}
