local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local events = require("luasnip.util.events")
local fmt = require("luasnip.extras.fmt").fmt

-- ----------------------
-- |   Vimtex Regions   |
-- ----------------------

local ctx = {
  math = function()
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
  end,
  not_math = function()
    return vim.fn["vimtex#syntax#in_mathzone"]() ~= 1
  end,
  comment = function()
    return vim.fn["vimtex#syntax_in_comment"]() == 1
  end,
  notcomment = function()
    return vim.fn["vimtex#syntax_in_comment"]() ~= 1
  end,
  env = function(name)
    local bounds = vim.fn["vimtex#env#is_inside"](name)
    return bounds[1] ~= 0 and bounds[2] ~= 0
  end,
  notenv = function(name)
    local bounds = vim.fn["vimtex#env#is_inside"](name)
    return bounds[1] == 0 or bounds[2] == 0
  end,
}

-- ------------------------
-- |   Helper Functions   |
-- ------------------------

local autoinsert_space = {
  -- index `-1` means the callback is on the snippet as a whole
  [-1] = {
    [events.leave] = function()
      vim.api.nvim_create_autocmd("InsertCharPre", {
        buffer = 0,
        once = true,
        callback = function()
          if string.find(vim.v.char, "%a") then
            vim.v.char = " " .. vim.v.char
          end
        end,
      })
    end,
  },
}

-- ----------------
-- |   Snippets   |
-- ----------------

return {},
    {
      -- -----------------------
      -- |   Enter Math mode   |
      -- -----------------------
      -- Inline math
      s(
        { trig = "mk", priority = 100 },
        fmt([[${1}$]], { i(1) }),
        {
          condition = ctx.math,
          show_condition = ctx.math,
          callbacks = autoinsert_space
        }
      ),

      s(
        { trig = "([%w_]+)mk", regTrig = true, priority = 200 },
        f(function(_, snip)
          return "$" .. snip.captures[1] .. "$"
        end),
        {
          condition = ctx.not_math,
          show_condition = ctx.not_math,
          callbacks = autoinsert_space,
        }
      ),

      -- Display math
      s(
        "dm",
        fmt(
          [[
          \[
            {1}
          \]
        ]] ,
          i(1)
        ),
        {
          condition = ctx.not_math,
          show_condition = ctx.not_math,
        }
      ),

      -- -----------------
      -- |   Fractions   |
      -- -----------------
      s(
        { trig = "//", wordTrig = false },
        { t([[\frac{]]), i(1), t([[}{]]), i(2), t([[}]]) },
        {
          condition = ctx.math,
          show_condition = ctx.math,
        }
      ),
      s({ trig = [=[([a-zA-Z0-9_^\{}]+)/]=], wordTrig = false, regTrig = true }, {
        t([[\frac{]]),
        f(function(_, snip)
          return snip.captures[1]
        end),
        t([[}{]]),
        i(1),
        t([[}]]),
      },
        {
          condition = ctx.math,
          show_condition = ctx.math,
        }
      ),
      s({ trig = [=[^(.*[%)%}])/]=], wordTrig = false, regTrig = true }, {
        f(function(_, snip)
          local str = snip.captures[1]
          local idx = #str
          print(idx)
          local depth = 0

          while idx > 0 do
            local char = str:sub(idx, idx)
            print(char)
            if char == ")" or char == "}" then
              depth = depth - 1
            end
            if char == "(" or char == "(" then
              depth = depth + 1
            end

            print(depth)
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
      },
        {
          condition = ctx.math,
          show_condition = ctx.math,
        }
      ),

      -- -------------------------
      -- |   Math Environments   |
      -- -------------------------
      s(
        "ali",
        { t({ [[\begin{align}]], "  " }), i(1), t({ "", [[\end{align}]] }) },
        {
          condition = ctx.not_math,
          show_condition = ctx.not_math,
        }
      ),

      s(
        "mlt",
        { t({ [[\begin{multline*}]], "  " }), i(1), t({ "", [[\end{multline*}]] }) },
        {
          condition = ctx.not_math,
          show_condition = ctx.not_math,
        }
      ),
    }
