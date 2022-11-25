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

---@alias Comments { start: string, mid: string, stop: string, indent: string }

---Parse vim 'comments' option to extract line comment format.
---See the help for the exact syntax.
---@return {single: Comments[], triple: Comments[], other: Comments[]}
local parse_comments = function()
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

---Use the parsed comment's format and return a triple.
---@return Comments
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

---Creates a function node for luasnip.
---@param part "start"|"mid"|"stop"
---@return function
local comment = function(part)
  return f(function()
    local cf = comment_format()
    local c
    if part == "mid" then
      c = cf.indent .. cf[part]
    else
      c = cf[part]
    end

    if c ~= "" then
      c = c .. " "
    end
  end, {})
end

---Insert as many characters as possible in order to fill up to textwidth.
---@param char string
---@param padding integer
---@param part "start"|"mid"|"stop"
---@return function
local fill = function(char, padding, part)
  return f(function()
    local clen = string.len(comment_format()[part])
    return string.rep(char, vim.bo.textwidth - padding - clen)
  end)
end

---
---@param index integer
---@param char string
---@param padding integer
---@param part "start"|"mid"|"stop"
---@param side "left"|"right"
---@return function
local center = function(index, char, padding, part, side)
  return f(function(arg)
    local cf = comment_format()
    local clen
    if part == "mid" then
      clen = string.len(cf.indent .. cf[part])
    else
      clen = string.len(cf[part])
    end
    local text = string.len(arg[1][1])
    local count = vim.bo.textwidth - padding - text - clen
    if count % 2 == 1 and side == "left" then
      count = (count + 1) / 2
    else
      count = count / 2
    end
    return string.rep(char, count)
  end, { index })
end

return {
  -- ------------------------------------------------------------------------
  -- | Wide Boxes
  -- ------------------------------------------------------------------------
  s(
    "vbox",
    fmt(
      [[
        {comment_start}┌───{filler}───┐
        {comment_mid}│   {left_center}{insert}{right_center}   │
        {comment_stop}└───{filler}───┘
      ]],
      {
        comment_start = comment("start"),
        comment_mid = comment("mid"),
        comment_stop = comment("stop"),
        filler = fill("─", 9, "start"),
        left_center = center(1, " ", 9, "mid", "left"),
        insert = i(1),
        right_center = center(1, " ", 9, "mid", "right"),
      }
    )
  ),

  s(
    "vvbox",
    fmt(
      [[
        {comment_start}┌────{box_filler}────┐
        {comment_mid}│┌───{box_filler}───┐│
        {comment_mid}││   {space_filler}   ││
        {comment_mid}││   {left_center}{insert}{right_center}   ││
        {comment_mid}││   {space_filler}   ││
        {comment_mid}│└───{box_filler}───┘│
        {comment_stop}└────{box_filler}────┘
      ]],
      {
        comment_start = comment("start"),
        comment_mid = comment("mid"),
        comment_stop = comment("stop"),
        box_filler = fill("─", 11, "start"),
        space_filler = fill(" ", 11, "start"),
        left_center = center(1, " ", 11, "mid", "left"),
        insert = i(1),
        right_center = center(1, " ", 11, "mid", "right"),
      }
    )
  ),

  s(
    "wbox",
    fmt(
      [[
        {comment_start}----{filler}----
        {comment_mid}|   {left_center}{insert}{right_center}   |
        {comment_stop}----{filler}----
      ]],
      {
        comment_start = comment("start"),
        comment_mid = comment("mid"),
        comment_stop = comment("stop"),
        filler = fill("-", 9, "start"),
        left_center = center(1, " ", 9, "mid", "left"),
        insert = i(1),
        right_center = center(1, " ", 9, "mid", "right"),
      }
    )
  ),

  s(
    "wwbox",
    fmt(
      [[
        {comment_start}====={box_filler}=====
        {comment_mid}|===={box_filler}====|
        {comment_mid}||   {space_filler}   ||
        {comment_mid}||   {left_center}{insert}{right_center}   ||
        {comment_mid}||   {space_filler}   ||
        {comment_mid}|===={box_filler}====|
        {comment_stop}====={box_filler}=====
      ]],
      {
        comment_start = comment("start"),
        comment_mid = comment("mid"),
        comment_stop = comment("stop"),
        box_filler = fill("=", 11, "start"),
        space_filler = fill(" ", 11, "start"),
        left_center = center(1, " ", 11, "mid", "left"),
        insert = i(1),
        right_center = center(1, " ", 11, "mid", "right"),
      }
    )
  ),

  -- ------------------------------------------------------------------------
  -- | Tight Boxes
  -- ------------------------------------------------------------------------
  s(
    "ubox",
    fmt(
      [[
        {3}┌───{2}───┐
        {4}│   {1}   │
        {5}└───{2}───┘
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
        {4}┌────{2}────┐
        {5}│┌───{2}───┐│
        {5}││   {3}   ││
        {5}││   {1}   ││
        {5}││   {3}   ││
        {5}│└───{2}───┘│
        {6}└────{2}────┘
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
        {3}----{2}----
        {4}|   {1}   |
        {5}----{2}----
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
        {4}====={2}=====
        {5}|===={2}====|
        {5}||   {3}   ||
        {5}||   {1}   ||
        {5}||   {3}   ||
        {5}|===={2}====|
        {6}====={2}=====
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
