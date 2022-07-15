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

-- ----------------------
-- |   Vimtex Regions   |
-- ----------------------

local x = {
  --- Returns true if the cursor is currently in a math zone.
  -- @return boolean
  m = function()
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
  end,

  --- Returns true if the cursor is not currently in a math zone.
  -- @return boolean
  M = function()
    return vim.fn["vimtex#syntax#in_mathzone"]() ~= 1
  end,

  --- Returns true if the cursor is currently in a latex comment.
  -- @return boolean
  c = function()
    return vim.fn["vimtex#syntax_in_comment"]() == 1
  end,

  --- Returns a true if the cursor is currently not in a latex comment.
  C = function()
    return vim.fn["vimtex#syntax_in_comment"]() ~= 1
  end,

  --- Returns a function that returns true if the cursor is currently inside an
  -- environment specified by name.
  -- @param name The name of the environment
  e = function(name)
    return function()
      local bounds = vim.fn["vimtex#env#is_inside"](name)
      return bounds[1] ~= 0 and bounds[2] ~= 0
    end
  end,

  --- Returns a function that returns true if the cursor is currently not inside
  -- an environment specified by name.
  -- @param name The name of the environment
  E = function(name)
    return function()
      local bounds = vim.fn["vimtex#env#is_inside"](name)
      return bounds[1] == 0 or bounds[2] == 0
    end
  end,

  --- Returns true if the current line starts with any amount of whitespace
  -- followed by the trigger.
  -- @param trig The trigger used to expand the snippet.
  b = function(trig)
    return function(line_to_cursor)
      return string.match(line_to_cursor, "^%s*" .. trig .. "$")
    end
  end,

  --- Join multiple conditions into a single condition.
  -- @param conditions A list of conditions, all of which have to be true for
  -- the entire function to evaluate to true.
  join = function(conditions)
    return function(line_to_cursor)
      for _, cond in ipairs(conditions) do
        if not cond(line_to_cursor) then
          return false
        end
      end

      return true
    end
  end,
}

-- ------------------------
-- |   Helper Functions   |
-- ------------------------

-- return the capture group at index.
local cap = function(index)
  return f(function(_, snip)
    return snip.captures[index]
  end)
end

-- Convert content of node at index to snake case.
local to_snake = function(index)
  return f(function(args)
    s = args[1][1]
    s = s:gsub("ü", "ue")
    s = s:gsub("Ü", "Ue")
    s = s:gsub("ä", "ae")
    s = s:gsub("Ä", "Ae")
    s = s:gsub("ö", "oe")
    s = s:gsub("Ö", "Oe")
    s = s:gsub("ß", "ss")

    s = s:lower(s)
    return s:gsub("%W+", "_")
  end, { index })
end

-- Create a choice node which simply toggles text
local toggle_text = function(index, text, reverse)
  if reverse then
    return c(index, {
      t(text),
      t(""),
    })
  else
    return c(index, {
      t(""),
      t(text),
    })
  end
end

-- Dynamically create a bunch of snippet nodes parsed from a latex table string.
local table_node = function(args)
  local tabs = {}
  local table = args[1][1]:gsub("%s", ""):gsub("|", "")
  local count = table:len()

  for j = 1, count do
    local i_node = i(j)
    tabs[2 * j - 1] = i_node
    if j ~= count then
      tabs[2 * j] = t(" & ")
    end
  end

  return sn(nil, tabs)
end

-- Recursively create the table rows.
local rec_table
rec_table = function()
  return sn(nil, {
    c(1, {
      t({ "" }),
      sn(nil, {
        t({ [[\\]] }),
        d(1, table_node, { ai[1] }),
        d(2, rec_table, { ai[1] }),
      }),
    }),
  })
end

-- --------------------------------
-- |   Snippet Helper Functions   |
-- --------------------------------

local snips = {}
local autosnips = {}

--- Creates a simple math snippet.
--
-- @param mode string: string of Ultisnips options
--  i: inside word
--  w: word boundary
--  b: beginning of line
--  m: math mode
-- @param trig string: the trigger of the snippet
-- @param desc string: description
-- @param nodes string or table: the expansion or a table of nodes.
-- @param opts table:
--  prio int:
local snip = function(mode, trig, desc, nodes, opts)
  if not mode:gmatch("([rwib])([mM]?)(A?)(S?)") then
    error("unknown mode: " .. mode, 2)
  end

  -- Parse mode string
  local wordTrig = true
  local regTrig = false
  local condition_table = {}
  local show_condition_table = {}
  local autoexpand = false
  local callbacks = nil

  local modeopts = {
    r = function()
      regTrig = true
    end,
    i = function()
      wordTrig = false
    end,
    w = function()
      wordTrig = false
    end,
    A = function()
      autoexpand = true
    end,
    S = function()
      callbacks = autoinsert_space
    end,
    b = function()
      table.insert(condition_table, x.b(trig))
    end,
    m = function()
      table.insert(condition_table, x.m)
      table.insert(show_condition_table, x.m)
    end,
    M = function()
      table.insert(condition_table, x.M)
      table.insert(show_condition_table, x.M)
    end,
    c = function()
      table.insert(condition_table, x.c)
      table.insert(show_condition_table, x.c)
    end,
    C = function()
      table.insert(condition_table, x.C)
      table.insert(show_condition_table, x.C)
    end,
  }

  for ch in mode:gmatch(".") do
    modeopts[ch]()
  end

  -- Default the description to be just the trigger.
  desc = desc or trig

  -- If the nodes is just a string, create a text node from it.
  if type(nodes) == "string" then
    nodes = { t(nodes) }
  end

  -- Go through all the nodes and create text nodes from raw strings inside the
  -- table.
  for idx, node in pairs(nodes) do
    if type(node) == "string" then
      nodes[idx] = t(node)
    end
  end

  -- Parse the opts table.
  opts = opts or {}
  local prio = opts.prio or 1000

  -- Check opts for optional `env` and `not_env` keys.
  if opts.env then
    table.insert(condition_table, x.e(opts.env))
    table.insert(show_condition_table, x.e(opts.env))
  end

  if opts.not_env then
    table.insert(condition_table, x.E(opts.not_env))
    table.insert(show_condition_table, x.E(opts.not_env))
  end

  -- Build condition functions by joining both tables.
  local condition = x.join(condition_table)
  local show_condition = x.join(show_condition_table)

  -- Create the snippet.
  local node = s(
    {
      trig = trig,
      wordTrig = wordTrig,
      regTrig = regTrig,
      dscr = desc,
      priority = prio,
    },
    nodes,
    {
      condition = condition,
      show_condition = show_condition,
      callbacks = callbacks,
    }
  )

  -- Insert it into the correct table, depending on whether it is an
  -- auto-snippet.
  if autoexpand then
    table.insert(autosnips, node)
  else
    table.insert(snips, node)
  end
end

-- =====================================
-- |===================================|
-- ||                                 ||
-- ||     LaTeX Snippet Definitions   ||
-- ||                                 ||
-- |===================================|
-- =====================================

-- --------------------
-- |   Environments   |
-- --------------------
snip(
  "bMA",
  "beg",
  "create environment",
  fmta(
    [[
      \begin{<name>}<leftpar><options><rightpar>
        <stop>
      \end{<name2>}
    ]],
    {
      name = i(1),
      name2 = rep(1),
      options = i(2),
      leftpar = ne(2, "", "{"),
      rightpar = ne(2, "", "}"),
      stop = i(0),
    }
  )
)
snip(
  "bM",
  "table",
  "table environment",
  fmta(
    [[
      \begin{table}[<position>]
        \centering
        \caption{<caption>}
        \label{tab:<label>}
        \begin{tabular}{<columns>}
          <table><rec>
        \end{tabular}
      \end{table}
    ]],
    {
      position = i(1, "htbp"),
      caption = i(2, "caption"),
      label = i(3, "label"),
      columns = i(4, "c c c"),
      table = d(5, table_node, { 4 }, {}),
      rec = d(6, rec_table, { 4 }),
    }
  )
)
snip(
  "bM",
  "fig",
  "figure",
  fmta(
    [[
        \begin{figure}[<position>]
          \centering
          <include>
          \caption{<caption>}
          \label{fig:<label>}
        \end{figure}
      ]],
    {
      position = i(1, "htbp"),
      include = c(2, {
        sn(nil, {
          t([[\includegraphics[width=0.8\textwidth]{]]),
          i(1),
          t([[}]]),
        }),
        t(""),
      }),
      caption = i(2, "caption"),
      label = i(3, "label"),
    }
  )
)
snip(
  "bM",
  "enum",
  "enumeration",
  fmta(
    [[
      \begin{enumerate}
        \item <item>
      \end{enumerate}
    ]],
    { item = i(0) }
  )
)
snip(
  "bMA",
  "-",
  "new item inside enumeration",
  [[\item ]],
  { env = "enumerate" }
)
snip(
  "bM",
  "item",
  "itemize",
  fmta(
    [[
      \begin{itemize}
        \item <item>
      \end{itemize}
    ]],
    { item = i(0) }
  )
)
snip("bMA", "-", "new item inside enumeration", [[\item ]], { env = "itemize" })
snip(
  "bM",
  "desc",
  "description",
  fmta(
    [[
      \begin{description}
        \item[<desc>] <item>
      \end{description}
    ]],
    { desc = i(1), item = i(0) }
  )
)
snip(
  "bM",
  "ali",
  "align",
  fmta(
    [[
      \begin{align<star>}
        <input>
      \end{align<star>}
    ]],
    { star = toggle_text(1, "*"), input = i(2) }
  )
)
snip(
  "bM",
  "mlt",
  "multiline",
  fmta(
    [[
      \begin{multline<star>}
        <input>
      \end{multline<star>}
    ]],
    { star = toggle_text(1, "*"), input = i(2) }
  )
)

-- -----------------------------
-- |   Glossary and Acronyms   |
-- -----------------------------
snip(
  "bM",
  "glossary",
  "new glossary entry",
  fmta(
    [[
      \newglossaryentry{<id>}{%
        name={<name>},%
        description={<desc>}%
      }
    ]],
    { id = i(1, "id"), name = i(2, "name"), desc = i(3, "description") }
  )
)
snip(
  "bM",
  "acronym",
  "new acronym entry",
  fmta(
    [[\newacronym{<id>}{<name>}{<desc>}]],
    { id = i(1, "id"), name = i(2, "name"), desc = i(3, "description") }
  )
)

-- --------------------
-- |   Type Setting   |
-- --------------------
snip("wMS", "it", "italics", { t([[\textit{]]), i(1), t("}") })
snip("wMS", "bf", "boldface", { t([[\textbf{]]), i(1), t("}") })
snip("wMS", "em", "emphasis", { t([[\textem{]]), i(1), t("}") })

-- -----------------------
-- |   Enter Math mode   |
-- -----------------------
snip("wMA", "mk", "inline math", { t("$"), i(1), t("$") }, { prio = 100 })
snip(
  "rMAS",
  "([%w])mk",
  "inline math surround letter",
  { "$", cap(1), "$" },
  { prio = 200 }
)
snip(
  "wMA",
  "dm",
  "display math",
  { t({ "\\[", "\t" }), i(1), t({ "", "" }), toggle_text(2, ".", true), "\\]" }
)

-- -----------------
-- |   Fractions   |
-- -----------------
snip("imA", "//", "fraction", fmta([[\frac{<1>}{<2>}]], { i(1), i(2) }))
snip(
  "rmA",
  "([a-zA-Z0-9_^{}]+)/",
  "autofraction previous number",
  fmta([[\frac{<1>}{<2>}]], {
    cap(1),
    i(1),
  })
)
snip("rmA", "^(.*[%)%}])/", "auto fraction previous expression", {
  f(function(_, snp)
    local str = snp.captures[1]
    local idx = #str
    local depth = 0

    while idx > 0 do
      local char = str:sub(idx, idx)
      if char == ")" or char == "}" then
        depth = depth - 1
      end
      if char == "(" or char == "(" then
        depth = depth + 1
      end

      if depth == 0 then
        break
      end
      idx = idx - 1
    end

    return str:sub(0, idx - 1) .. [[\frac{]] .. str:sub(idx)
  end),
  t([[}{]]),
  i(1),
  t([[}]]),
})

-- -----------------------------
-- |   Chapters and Sections   |
-- -----------------------------
snip(
  "bMA",
  "chap",
  "chapter",
  { [[\chapter{]], i(1), t({ "}", [[\label{chap:]] }), to_snake(ai[1]), "}" }
)
snip(
  "bMA",
  "sec",
  "section",
  { [[\section{]], i(1), t({ "}", [[\label{sec:]] }), to_snake(ai[1]), "}" }
)
snip(
  "bMA",
  "ssec",
  "subsection",
  { [[\subsection{]], i(1), t({ "}", [[\label{ssec:]] }), to_snake(ai[1]), "}" }
)
snip("bMA", "sssec", "subsubsection", {
  [[\subsubsection{]],
  i(1),
  t({ "}", [[\label{sssec:]] }),
  to_snake(ai[1]),
  "}",
})
snip(
  "bMA",
  "par",
  "paragraph",
  { [[\paragraph{]], i(1), t({ "}", [[\label{par:]] }), to_snake(ai[1]), "}" }
)

-- ----------------
-- |   Matrices   |
-- ----------------
snip(
  "iA",
  "pmat",
  "round matrix",
  { t([[\begin{pmatrix} ]]), i(1), t([[ \end{pmatrix}]]) }
)
snip(
  "iA",
  "bmat",
  "square matrix",
  { t([[\begin{bmatrix} ]]), i(1), t([[ \end{bmatrix}]]) }
)

-- ----------------------------
-- |   Sub and Superscripts   |
-- ----------------------------
-- Subscript and superscript text.
snip("imA", "__", "subscript", { t("_{"), i(1), t("}"), i(0) })
snip("imA", "sts", "subscript text", { t([[_{\text{]]), i(1), t("}}"), i(0) })
snip("imA", "td", "superscript", { t("^{"), i(1), t("}"), i(0) })
snip("imA", "rd", "superscript", { t("^{("), i(1), t(")}"), i(0) })
snip("imA", "tt", "text", { t([[\text{]]), i(1), t("}"), i(0) })

-- Quick variable indices.
snip("imA", "xnn", "x subscript n", "x_{n}")
snip("imA", "ynn", "y subscript n", "y_{n}")
snip("imA", "xii", "x subscript i", "x_{i}")
snip("imA", "yii", "y subscript i", "y_{i}")
snip("imA", "xjj", "x subscript j", "x_{j}")
snip("imA", "yjj", "y subscript j", "y_{j}")
snip("imA", "xmm", "x subscript m", "x_{m}")
snip("imA", "xn1", "x subscript n plus one", "x_{n+1}")

-- Auto subscript two numbers
snip("rmA", "(%a)(%d)", "auto subscript number", { cap(1), t("_"), cap(2) })
snip(
  "rmA",
  "(%a_)(%d%d)",
  "auto subscript two numbers",
  { cap(1), t("{"), cap(2), t("}") }
)

-- Dot
snip("wmA", "dot", "dot variable", { "\\dot{", i(1), "}" }, { prio = 100 })
snip(
  "rmA",
  "(%a)dot",
  "dot previous variable",
  { "\\dot{", cap(1), "}" },
  { prio = 1000 }
)

-- Ddot
snip("wmA", "ddt", "ddot variable", { "\\ddot{", i(1), "}" }, { prio = 100 })
snip(
  "rmA",
  "(%a)ddt",
  "ddot previous variable",
  { "\\ddot{", cap(1), "}" },
  { prio = 1000 }
)

-- Math calligraphy
snip("wmA", "cal", "cal variable", { "\\mathcal{", i(1), "}" }, { prio = 100 })
snip(
  "rmA",
  "(%a)cal",
  "cal previous variable",
  { "\\mathcal{", cap(1), "}" },
  { prio = 1000 }
)

-- Math fraktal
snip(
  "wmA",
  "frak",
  "fraktal variable",
  { "\\mathfrak{", i(1), "}" },
  { prio = 100 }
)
snip(
  "rmA",
  "(%a)frak",
  "fraktal previous variable",
  { "\\mathfrak{", cap(1), "}" },
  { prio = 1000 }
)

-- Bar
snip("wmA", "bar", "bar variable", { "\\bar{", i(1), "}" }, { prio = 100 })
snip(
  "rmA",
  "(%a)bar",
  "bar previous variable",
  { "\\bar{", cap(1), "}" },
  { prio = 1000 }
)

-- Hat
snip("wmA", "hat", "hat variable", { "\\hat{", i(1), "}" }, { prio = 100 })
snip(
  "rmA",
  "(%a)hat",
  "hat previous variable",
  { "\\hat{", cap(1), "}" },
  { prio = 1000 }
)

-- Tilde
snip(
  "wmA",
  "tld",
  "tilde variable",
  { "\\widetilde{", i(1), "}" },
  { prio = 100 }
)
snip(
  "rmA",
  "(%a)tld",
  "tilde previous variable",
  { "\\widetilde{", cap(1), "}" },
  { prio = 1000 }
)

-- Wide tilde
snip(
  "wmA",
  "wld",
  "wide tilde variable",
  { "\\widetilde{", i(1), "}" },
  { prio = 100 }
)
snip(
  "rmA",
  "(%a)wld",
  "wide tilde previous variable",
  { "\\widetilde{", cap(1), "}" },
  { prio = 1000 }
)

-- Vector
snip("wmA", "vec", "vector", { "\\vec{", i(1), "}" }, { prio = 100 })
snip(
  "rmA",
  "(%a)vec",
  "vector previous",
  { "\\vec{", cap(1), "}" },
  { prio = 1000 }
)

-- Column vector
snip(
  "wmA",
  "cvec",
  "column vector",
  fmta(
    [[\begin{pmatrix} <1>_<2>\\\\ \vdots\\\\ <3>_<4> \end{pmatrix}]],
    { i(1, "x"), i(2, "1"), rep(1), i(3, "n") }
  )
)

-- -----------------
-- |   Operators   |
-- -----------------
snip("imA", "conj", "conjugate", { t([[\overline{]]), i(1), t([[}]]) })
snip("imA", "sum", "sum", {
  t([[\sum_{]]),
  i(1, [[n=1]]),
  t([[}^{]]),
  i(2, [[\infty]]),
  t([[} ]]),
  i(3, [[a_n]]),
})
snip(
  "imA",
  "taylor",
  "taylor series",
  fmta([[\sum_{<1>=<2>}^{<3>} <4> (x-a)^{<5>} ]], {
    i(1, [[k]]),
    i(2, [[1]]),
    i(3, [[\infty]]),
    i(4, [[c_]]),
    rep(1),
  })
)

snip(
  "wm",
  "lim",
  "limit",
  fmta([[\lim_{<1> \to <2>}]], { i(1, "n"), i(2, "\\infty") })
)
snip(
  "wm",
  "limsup",
  "limit superior",
  fmta([[\limsup_{<1> \to <2>}]], { i(1, "n"), i(2, "\\infty") })
)
snip(
  "wm",
  "prod",
  "product",
  fmta([[\prod_{<1>}^{<2>} <3>]], {
    sn(1, { i(1, "n"), t("="), i(2, "1") }),
    i(2, "\\infty"),
    i(3),
  })
)
snip(
  "wm",
  "part",
  "partial derivative",
  fmta([[\frac{\partial <1>}{\partial <2>}}]], { i(1, "V"), i(2, "x") })
)
snip("imA", "sq", "square root", { t([[\sqrt{]]), i(1), t([[}]]) })
snip("imA", "norm", "norm", { t([[\norm{]]), i(1), t("}") })
snip("imA", "abs", "absolute value", { t([[\abs{]]), i(1), t("}") })
snip("imA", "ip", "inner product", { t([[\ip{]]), i(1), t("}{"), i(2), t("}") })
snip(
  "imA",
  "dint",
  "definit integral",
  { "\\int_{", i(1, "-\\infty"), "}^{", i(2, "\\infty"), "} ", i(3), " ", i(0) }
)
snip("imA", "nnn", "big cap", { t([[\bigcap_{]]), i(1), t([[}]]) })
snip("imA", "uuu", "big cup", { t([[\bigcup_{]]), i(1), t([[}]]) })
snip(
  "wmA",
  "case",
  "case statement",
  fmta(
    [[
    \begin{cases}
      <1>
    \end{cases}
  ]],
    { i(1) }
  )
)
snip(
  "bm",
  "bigfun",
  "big function definition",
  fmta(
    [[
    \begin{align*}
      <1>: <2> &\longrightarrow <3> \\\\
      <4> &\longmapsto <5>(<6>) = <7>
    \end{align*}
  ]],
    { i(1), i(2), i(3), i(4), rep(1), rep(4), i(0) }
  )
)
snip("imA", "SI", "SI unit", { "\\SI{", i(1), "}{", i(2), "}" })
snip("wm", "set", "set definition", { "\\{ ", i(1), " \\} " })
snip(
  "wm",
  "bset",
  "big set definition",
  { "\\left\\{ ", i(1), " \\mid ", i(2), " \\right\\} " }
)
snip(
  "wM",
  "bigset",
  "big set definition",
  fmta(
    [[
      \[
        <1> = \left\{ <2> \mid <3> \right\}
      \]
    ]],
    { i(1), i(2), i(0) }
  )
)

-- -------------------
-- |   Parenthesis   |
-- -------------------
snip(
  "imA",
  "ceil",
  "ceiling",
  { t([[\left\lceil ]]), i(1), t([[ \right\rceil]]) }
)
snip(
  "imA",
  "floor",
  "floor",
  { t([[\left\lfloor ]]), i(1), t([[ \right\rfloor]]) }
)
snip("imA", "()", "parenthesis", { t([[\left(]]), i(1), t([[\right)]]) })
snip("mi", "lr", "parenthesis", { t([[\left(]]), i(1), t([[\right)]]) })
snip("imA", "lr(", "parenthesis", { t([[\left(]]), i(1), t([[\right)]]) })
snip("imA", "lr|", "parenthesis norm", { t([[\left|]]), i(1), t([[\right|]]) })
snip(
  "imA",
  "lrb",
  "parenthesis curly braces",
  { t([[\left{]]), i(1), t([[\right}]]) }
)
snip(
  "imA",
  "lr[",
  "parenthesis square brackets",
  { t([[\left[]]), i(1), t([=[\right]]=]) }
)
snip(
  "imA",
  "lra",
  "parenthesis angle brackets",
  { t([[\left\lange]]), i(1), t([[\right\rangle]]) }
)

-- ---------------
-- |   Symbols   |
-- ---------------
--
-- Dots
snip("imA", "...", "dots", t([[\ldots ]]))
snip("imA", "c..", "centered dots", t([[\cdots ]]))
snip("imA", "d..", "diagonal dots", t([[\ddots ]]))
snip("imA", "v..", "vertical dots", t([[\vdots ]]))

-- Logic
snip("imA", "=>", "implies", t([[\implies]]))
snip("imA", "=<", "implied by", t([[\impliedby]]))
snip("imA", "iff", "if and only iff", t([[\iff]]))
snip("imA", ":=", "definition equals", t([[\vcentcolon=]]))
snip("imA", "=:", "equals definition", t([[=\vcentcolon]]))
snip("imA", "==", "equals", { t([[&= ]]), t([[ \\\\]]) })
snip("imA", "!=", "not equals", t([[\neq]]))
snip("imA", "eE", "exists", [[\exists]])
snip("imA", "aA", "for all", [[\forall]])

-- Operations
snip("imA", "ooo", "infinity", [[\infty]])
snip("imA", "<=", "less than or equal to", [[\le]])
snip("imA", ">=", "greater than or equal to", [[\ge]])
snip("imA", "xx", "cross times", [[\times]])
snip("imA", "ox", "o cross times", [[\otimes]])
snip("imA", "op", "o plus", [[\oplus]])
snip("imA", "**", "center dot", [[\cdot]])
snip("imA", "->", "to", [[\to]], { prio = 100 })
snip("imA", "<->", "left right arrow", [[\leftrightarrow]], { prio = 200 })
snip("imA", "~>", "right squigly arrow", [[\rightsquigarrow]])
snip("imA", "!>", "maps to", [[\mapsto]])
snip("imA", "invs", "inverse", [[^{-1}]])
snip("imA", "compl", "complement", [[^{c}]])
snip("imA", ">>", "greater than", [[\gg]])
snip("imA", "<<", "less than", [[\ll]])
snip("imA", "~~", "similar", [[\sim]])
snip("imA", "||", "mid", [[\mid]])

-- Sets
snip("imA", "OO", "empty set", [[\varnothing]])
snip("imA", [[\\\]], "set minus", [[\setminus]])
snip("imA", "cc", "subset", [[\subset]])
snip("imA", "c=", "subset equal", [[\subseteq]])
snip("imA", "notin", "set not in", [[\not\in]])
snip("imA", "inn", "set in", [[\in]])
snip("imA", "nN", "cap", [[\cap]])
snip("imA", "uU", "cup", [[\cup]])

-- Symbols
snip("imA", "lll", "ell", [[\ell]])
snip("imA", "nabl", "nabla", [[\nabla]])
snip("imA", "<!", "normal", [[\triangleleft]])
snip("imA", "<>", "jokje", [[\diamond]])

-- Spacing
snip("imA", "qd", "quad", [[\quad]])
snip("imA", "Qd", "qquad", [[\qquad]])

-- Word functions
snip("wmA", "sin", "sin", [[\sin]], { prio = 100 })
snip("rmA", "ar?c?sin", "arcsin", [[\arcsin]], { prio = 200 })

snip("wmA", "cos", "cosin", [[\cos]], { prio = 100 })
snip("rmA", "ar?c?cos", "arccos", [[\arccos]], { prio = 200 })

snip("wmA", "tan", "tangent", [[\tan]], { prio = 100 })
snip("rmA", "ar?c?tan", "arctangent", [[\arctan]], { prio = 200 })

snip("wmA", "sec", "secant", [[\sec]], { prio = 100 })
snip("rmA", "ar?c?sec", "arcsecant", [[\arcsec]], { prio = 200 })

snip("wmA", "csc", "cosecant", [[\csc]], { prio = 100 })
snip("rmA", "ar?c?csc", "arccosecant", [[\arccsc]], { prio = 200 })

snip("wmA", "cot", "cotangent", [[\cot]], { prio = 100 })
snip("rmA", "ar?c?cot", "arccotangent", [[\arccot]], { prio = 200 })

snip("wmA", "ln", "natural logarithm", [[\ln]], { prio = 100 })
snip("wmA", "log", "logarithm", [[\log]], { prio = 100 })
snip("wmA", "exp", "exponential", [[\exp]], { prio = 100 })
snip("wmA", "star", "star", [[\star]], { prio = 100 })
snip("wmA", "perp", "perpendicular", [[\perp]], { prio = 100 })
snip("wmA", "max", "maximum", [[\max]], { prio = 100 })
snip("wmA", "min", "minimum", [[\min]], { prio = 100 })
snip("wmA", "sup", "supremum", [[\sup]], { prio = 100 })
snip("wmA", "inf", "infimum", [[\inf]], { prio = 100 })
snip("wmA", "get", "get", [[\get]], { prio = 100 })
snip("wmA", "int", "integral", [[\int]], { prio = 100 })

-- -------------------
-- |   Number Sets   |
-- -------------------
snip("imA", "NN", "natural numbers", [[\mathbb{N}]])
snip("imA", "CC", "complex numbers", [[\mathbb{C}]])
snip("imA", "RR", "real numbers", [[\mathbb{R}]])
snip("imA", "QQ", "rational numbers", [[\mathbb{Q}]])
snip("imA", "R0+", "rational numbers greater than zero", [[\mathbb{N}]])
snip("imA", "ZZ", "integers numbers", [[\mathbb{R}_0^+]])
snip("imA", "PP", "double stroke P", [[\mathbb{P}]])
snip("imA", "EE", "double stroke E", [[\mathbb{E}]])
snip("imA", "VV", "double stroke V", [[\mathbb{V}]])
snip("imA", "HH", "double stroke H", [[\mathbb{H}]])
snip("imA", "DD", "double stroke D", [[\mathbb{D}]])
snip("imA", "KK", "double stroke K", [[\mathbb{K}]])

-- ---------------------
-- |   Greek Letters   |
-- ---------------------
snip("wmA", "pi", "pi", [[\pi]], { prio = 100 })
snip("wmA", "zeta", "zeta", [[\zeta]], { prio = 100 })

local greek = function(symbol, name, latex)
  snip("imAS", "@" .. symbol, name, latex)
  snip("iMAS", "@" .. symbol, name, "$" .. latex .. "$")
end

greek("a", "alpha", [[\alpha]])
greek("A", "Alpha", [[\Alpha]])
greek("b", "beta", [[\beta]])
greek("B", "Beta", [[B]])
greek("g", "gamma", [[\gamma]])
greek("G", "Gamma", [[\Gamma]])
greek("d", "delta", [[\delta]])
greek("D", "Delta", [[\Delta]])
greek("e", "epsilon", [[\epsilon]])
greek("ve", "varepsilon", [[\varepsilon]])
greek("E", "Epsilon", [[\Epsilon]])
greek("z", "zeta", [[\zeta]])
greek("Z", "Zeta", [[\Zeta]])
greek("e", "eta", [[\eta]])
greek("E", "Eta", [[\Eta]])
greek("h", "theta", [[\theta]])
greek("vh", "vartheta", [[\vartheta]])
greek("H", "Theta", [[\Theta]])
greek("i", "iota", [[\iota]])
greek("I", "Iota", [[\Iota]])
greek("k", "kappa", [[\kappa]])
greek("K", "Kappa", [[\Kappa]])
greek("l", "lambda", [[\lambda]])
greek("L", "Lambda", [[\Lambda]])
greek("m", "mu", [[\mu]])
greek("M", "Mu", [[M]])
greek("n", "nu", [[\nu]])
greek("N", "Nu", [[N]])
greek("x", "xi", [[\xi]])
greek("X", "Xi", [[\Xi]])
greek("o", "o", [[o]])
greek("O", "O", [[O]])
greek("p", "pi", [[\pi]])
greek("P", "Pi", [[\Pi]])
greek("r", "rho", [[\rho]])
greek("vr", "varrho", [[\varrho]])
greek("R", "Rho", [[\Rho]])
greek("s", "sigma", [[\sigma]])
greek("S", "Sigma", [[\Sigma]])
greek("t", "pi", [[\tau]])
greek("T", "Pi", [[\Tau]])
greek("u", "upsilon", [[\upsilon]])
greek("U", "Upsilon", [[\Upsilon]])
greek("f", "phi", [[\phi]])
greek("vf", "varphi", [[\varphi]])
greek("f", "Phi", [[\Phi]])
greek("c", "chi", [[\chi]])
greek("C", "Chi", [[\Chi]])
greek("y", "psi", [[\psi]])
greek("Y", "Psi", [[\Psi]])
greek("w", "omega", [[\omega]])
greek("W", "Omega", [[\Omega]])

return snips, autosnips
