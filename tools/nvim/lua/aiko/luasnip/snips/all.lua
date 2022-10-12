local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local replace = function(index, char)
  return f(function(arg)
    return string.rep(char, string.len(arg[1][1]))
  end, { index })
end

local parse_comments = function()
  -- Parse vim 'comments' option to extract line comment format.
  -- See the help for the exact syntax.
  local iter = vim.gsplit(vim.o.comments, ",", true)
  local comments = { single = {}, triple = {}, other = {} }

  local split = function(cs)
    local flags, text = string.match(cs or "", "^([^:]*):([^:]*)$")
    return flags or "", text or ""
  end

  while true do
    local cs = iter()
    if not cs then
      break
    end
    local flags, text = split(cs)

    if #flags == 0 then
      -- Parse the single line comment string.
      table.insert(
        comments.other,
        1,
        { start = text, mid = text, stop = text, indent = "" }
      )
    elseif flags:match("s") and not flags:match("O") then
      -- Parse 3 part comment string, but ignore those with the O flag
      local ctriple = {}
      local indent = ""

      if string.match(flags:sub(-1), "%d+") then
        indent = string.rep(" ", flags:sub(-1))
      end
      ctriple.start = text

      cs = iter()
      flags, text = split(cs)
      assert(
        vim.startswith(flags, "m"),
        "Expected middle comment format of triple"
      )
      ctriple.mid = text

      cs = iter()
      flags, text = split(cs)
      assert(
        vim.startswith(flags, "e"),
        "Expected end comment format of triple"
      )
      ctriple.stop = text
      ctriple.indent = indent

      table.insert(comments.triple, 1, ctriple)
    elseif flags:match("b") then
      if #text == 1 then
        table.insert(
          comments.single,
          1,
          { start = text, mid = text, stop = text, indent = "" }
        )
      end
    end
  end

  return comments
end

local comment_format = function()
  if vim.o.commentstring:match("%%s$") then
    -- Remove last two characters
    local cf
    cf = vim.trim(vim.o.commentstring:sub(1, -3))
    return { start = cf, mid = cf, stop = cf, indent = "" }
  end

  local comments = parse_comments()
  if not vim.tbl_isempty(comments.single) then
    return comments.single[1]
  end

  if not vim.tbl_isempty(comments.other) then
    return comments.other[1]
  end

  return comments.triple[1]
end

local comment = function(part)
  return f(function()
    local cf = comment_format()
    if part == "mid" then
      return cf.indent .. cf[part]
    else
      return cf[part]
    end
  end, {})
end

return {
  s(
    "ubox",
    fmt(
      [[
        {3} ┌─{2}─┐
        {4} │ {1} │
        {5} └─{2}─┘
      ]],
      {
        i(1),
        replace(1, "─"),
        comment("start"),
        comment("mid"),
        comment("stop"),
      }
    )
  ),

  s(
    "uubox",
    fmt(
      [[
        {4} ┌────{2}────┐
        {5} │┌───{2}───┐│
        {5} ││   {3}   ││
        {5} ││   {1}   ││
        {5} ││   {3}   ││
        {5} │└───{2}───┘│
        {6} └────{2}────┘
      ]],
      {
        i(1),
        replace(1, "─"),
        replace(1, " "),
        comment("start"),
        comment("mid"),
        comment("stop"),
      }
    )
  ),

  s(
    "box",
    fmt(
      [[
        {3} ----{2}----
        {4} |   {1}   |
        {5} ----{2}----
      ]],
      {
        i(1),
        replace(1, "-"),
        comment("start"),
        comment("mid"),
        comment("stop"),
      }
    )
  ),

  s(
    "bbox",
    fmt(
      [[
        {4} ====={2}=====
        {5} |===={2}====|
        {5} ||   {3}   ||
        {5} ||   {1}   ||
        {5} ||   {3}   ||
        {5} |===={2}====|
        {6} ====={2}=====
      ]],
      {
        i(1),
        replace(1, "="),
        replace(1, " "),
        comment("start"),
        comment("mid"),
        comment("stop"),
      }
    )
  ),
}
