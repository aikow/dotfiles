local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local extras = require("luasnip.extras")
local rep = extras.rep
local autoinsert_space = require("aiko.luasnip.callbacks").autoinsert_space

-- ---------------------------
-- |   Define math regions   |
-- ---------------------------
local in_math = function()
  local query = vim.treesitter.query.parse(
    "norg",
    [[;;query
    [
     (inline_math)
     (ranged_verbatim_tag name: (tag_name) @_tag (#eq? @_tag "math"))
    ] @math
   ]]
  )
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr, "norg", {})
  local tree = parser:parse()[1]
  local root = tree:root()

  -- Get cursor line and column position and offset them by one so that they're
  -- also zero-indexed like the tree-sitter ranges.
  local line = vim.fn.line(".") - 1
  local col = vim.fn.col(".") - 1

  -- Iterate through all captures
  for id, node, _ in query:iter_captures(root, bufnr, 0, -1) do
    if query.captures[id] == "math" then
      local row1, col1, row2, col2 = node:range()

      -- Check whether the cursor is in the range.
      if
        (line == row1 and line == row2 and col > col1 and col < col2)
        or (line > row1 and line < row2)
        or (line == row1 and row1 ~= row2 and col > col1)
        or (line == row2 and row1 ~= row2 and col < col2)
      then
        return true
      end
    end
  end

  return false
end

local x = {
  --- Returns true if the cursor is currently in a math zone.
  -- @return boolean
  m = function()
    return in_math()
  end,

  --- Returns true if the cursor is not currently in a math zone.
  -- @return boolean
  M = function()
    return not in_math()
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

-- --------------------------------
-- |   Snippet Helper Functions   |
-- --------------------------------

local snips = {}

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
  local word_trig = true
  local trig_engine = "plain"
  local condition_table = {}
  local show_condition_table = {}
  local autoexpand = false
  local callbacks = nil

  local modeopts = {
    r = function()
      trig_engine = "pattern"
    end,
    i = function()
      word_trig = false
    end,
    w = function()
      word_trig = true
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

  -- Build condition functions by joining both tables.
  local condition = x.join(condition_table)
  local show_condition = x.join(show_condition_table)

  -- Create the snippet.
  local node = s(
    {
      trig = trig,
      wordTrig = word_trig,
      trigEngine = trig_engine,
      dscr = desc,
      snippetType = autoexpand and "autosnippet" or "snippet",
      priority = prio,
      condition = condition,
      show_condition = show_condition,
    },
    nodes,
    {
      callbacks = callbacks,
    }
  )

  table.insert(snips, node)
end

-- =====================================
-- |===================================|
-- ||                                 ||
-- ||     LaTeX Snippet Definitions   ||
-- ||                                 ||
-- |===================================|
-- =====================================

-- Math
snip("wMAS", "mk", "inline math", { t("$"), i(1), t("$") })
snip(
  "wMA",
  "dm",
  "display math",
  { t({ "@math ", "" }), i(0, ""), t({ "", "@end" }) }
)

-- Code
snip("wMAS", "nk", "inline code", { t("`"), i(1), t("`") })
snip(
  "wMA",
  "dn",
  "display code",
  { t("@code "), i(1, "lang"), t({ "", "" }), i(0, ""), t({ "", "@end" }) }
)

-- Text formatting
snip("MAS", "ii", "italics", { t("/"), i(1), t("/") })
snip("MAS", "bb", "boldface", { t("*"), i(1), t("*") })

-- Symbols
snip("MAS", "->", "right arrow", t("→"))
snip("MAS", "<-", "left arrow", t("←"))

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

-- Quick powers.
snip("imA", "sr", "superscript", "^2")
snip("imA", "cb", "superscript", "^3")

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
snip("imAS", "ooo", "infinity", [[\infty]])
snip("imAS", "<=", "less than or equal to", [[\le]])
snip("imAS", ">=", "greater than or equal to", [[\ge]])
snip("imAS", "xx", "cross times", [[\times]])
snip("imAS", "ox", "o cross times", [[\otimes]])
snip("imAS", "op", "o plus", [[\oplus]])
snip("imAS", "**", "center dot", [[\cdot]])
snip("imAS", "->", "to", [[\to]], { prio = 100 })
snip("imAS", "<->", "left right arrow", [[\leftrightarrow]], { prio = 200 })
snip("imAS", "~>", "right squigly arrow", [[\rightsquigarrow]])
snip("imAS", "!>", "maps to", [[\mapsto]])
snip("imAS", "invs", "inverse", [[^{-1}]])
snip("imAS", "compl", "complement", [[^{c}]])
snip("imAS", ">>", "greater than", [[\gg]])
snip("imAS", "<<", "less than", [[\ll]])
snip("imAS", "~~", "similar", [[\sim]])
snip("imAS", "||", "mid", [[\mid]])

-- Sets
snip("imAS", "OO", "empty set", [[\varnothing]])
snip("imAS", [[\\\]], "set minus", [[\setminus]])
snip("imAS", "cc", "subset", [[\subset]])
snip("imAS", "c=", "subset equal", [[\subseteq]])
snip("imAS", "notin", "set not in", [[\not\in]])
snip("imAS", "inn", "set in", [[\in]])
snip("imAS", "nN", "cap", [[\cap]])
snip("imAS", "uU", "cup", [[\cup]])

-- Symbols
snip("imAS", "lll", "ell", [[\ell]])
snip("imAS", "nabl", "nabla", [[\nabla]])
snip("imAS", "<!", "normal", [[\triangleleft]])
snip("imAS", "<>", "jokje", [[\diamond]])

-- Spacing
snip("imAS", "qd", "quad", [[\quad]])
snip("imAS", "Qd", "qquad", [[\qquad]])

-- Word functions
snip("wmAS", "sin", "sin", [[\sin]], { prio = 100 })
snip("rmAS", "ar?c?sin", "arcsin", [[\arcsin]], { prio = 200 })

snip("wmAS", "cos", "cosin", [[\cos]], { prio = 100 })
snip("rmAS", "ar?c?cos", "arccos", [[\arccos]], { prio = 200 })

snip("wmAS", "tan", "tangent", [[\tan]], { prio = 100 })
snip("rmAS", "ar?c?tan", "arctangent", [[\arctan]], { prio = 200 })

snip("wmAS", "sec", "secant", [[\sec]], { prio = 100 })
snip("rmAS", "ar?c?sec", "arcsecant", [[\arcsec]], { prio = 200 })

snip("wmAS", "csc", "cosecant", [[\csc]], { prio = 100 })
snip("rmAS", "ar?c?csc", "arccosecant", [[\arccsc]], { prio = 200 })

snip("wmAS", "cot", "cotangent", [[\cot]], { prio = 100 })
snip("rmAS", "ar?c?cot", "arccotangent", [[\arccot]], { prio = 200 })

snip("wmAS", "ln", "natural logarithm", [[\ln]], { prio = 100 })
snip("wmAS", "log", "logarithm", [[\log]], { prio = 100 })
snip("wmAS", "exp", "exponential", [[\exp]], { prio = 100 })
snip("wmAS", "star", "star", [[\star]], { prio = 100 })
snip("wmAS", "perp", "perpendicular", [[\perp]], { prio = 100 })
snip("wmAS", "max", "maximum", [[\max]], { prio = 100 })
snip("wmAS", "min", "minimum", [[\min]], { prio = 100 })
snip("wmAS", "sup", "supremum", [[\sup]], { prio = 100 })
snip("wmAS", "inf", "infimum", [[\inf]], { prio = 100 })
snip("wmAS", "get", "get", [[\get]], { prio = 100 })
snip("wmAS", "int", "integral", [[\int]], { prio = 100 })

-- -------------------
-- |   Number Sets   |
-- -------------------
snip("imAS", "NN", "natural numbers", [[\mathbb{N}]])
snip("imAS", "CC", "complex numbers", [[\mathbb{C}]])
snip("imAS", "RR", "real numbers", [[\mathbb{R}]])
snip("imAS", "QQ", "rational numbers", [[\mathbb{Q}]])
snip("imAS", "R0+", "rational numbers greater than zero", [[\mathbb{N}]])
snip("imAS", "ZZ", "integers numbers", [[\mathbb{R}_0^+]])
snip("imAS", "PP", "double stroke P", [[\mathbb{P}]])
snip("imAS", "EE", "double stroke E", [[\mathbb{E}]])
snip("imAS", "VV", "double stroke V", [[\mathbb{V}]])
snip("imAS", "HH", "double stroke H", [[\mathbb{H}]])
snip("imAS", "DD", "double stroke D", [[\mathbb{D}]])
snip("imAS", "KK", "double stroke K", [[\mathbb{K}]])

-- ---------------------
-- |   Greek Letters   |
-- ---------------------
snip("wmAS", "pi", "pi", [[\pi]], { prio = 100 })
snip("wmAS", "zeta", "zeta", [[\zeta]], { prio = 100 })

local greek = function(symbol, name, latex)
  snip("imAS", "@" .. symbol, name, latex)
  -- snip("iMAS", "@" .. symbol, name, "$" .. latex .. "$")
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

return snips
