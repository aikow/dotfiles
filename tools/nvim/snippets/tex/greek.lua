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

local math = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local notmath = function()
	return not math()
end

local comment = function()
	return vim.fn["vimtex#syntax_in_comment"]() == 1
end

local notcomment = function()
	return not comment()
end

local env = function(name)
	local bounds = vim.fn["vimtex#env#is_inside"](name)
	return bounds[1] ~= 0 and bounds[2] ~= 0
end

local notenv = function(name)
	return not env(name)
end

-- ----------------
-- |   Contexts   |
-- ----------------

local context = {
	math = function(callbacks)
		return {
			condition = math,
			show_condition = math,
			callbacks = callbacks,
		}
	end,
	notmath = function(callbacks)
		return {
			condition = notmath,
			show_condition = notmath,
			callbacks = callbacks,
		}
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
		-- Display math
		s({ trig = "mk", priority = 100 }, fmt([[${1}$]], { i(1) }), context.notmath(autoinsert_space)),

		s(
			{ trig = "([%w_]+)mk", regTrig = true, priority = 200 },
			f(function(_, snip)
				return "$" .. snip.captures[1] .. "$"
			end),
			context.notmath(autoinsert_space)
		),

		-- Inline math
		s(
			"dm",
			fmt(
				[[
          \[
            {1}
          \]
        ]],
				i(1)
			),
			context.notmath()
		),

		-- Fractions
		s({ trig = "//", wordTrig = false }, { t([[\frac{]]), i(1), t([[}{]]), i(2), t([[}]]) }, context.math()),
		s(
			{ trig = [=[([a-zA-Z0-9_^\{}]+)/]=], wordTrig = false, regTrig = true },
			{ t([[\frac{]]), f(function(_, snip)
				return snip.captures[1]
			end), t([[}{]]), i(1), t([[}]]) },
			context.math()
		),
		s(
			{ trig = [=[^(.*[%)%}])/]=], wordTrig = false, regTrig = true },
			{
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
			context.math()
		),

		-- Align environment
		s("ali", { t({ [[\begin{align}]], "  " }), i(1), t({ "", [[\end{align}]] }) }, context.notmath()),

		s("mlt", { t({ [[\begin{multline*}]], "  " }), i(1), t({ "", [[\end{multline*}]] }) }, context.notmath()),
	}
