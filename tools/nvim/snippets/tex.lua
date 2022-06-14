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
local fmta = require("luasnip.extras.fmt").fmta
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l

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

-- Register an auto-command to insert a space after a snippet if the following
-- character is a letter.
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

-- return the capture group at index.
local captures = function(index)
	return f(function(_, snip)
		return snip.captures[index]
	end)
end

-- Duplicate the insert node at the index.
local same = function(index)
	return f(function(args)
		return args[1][1]
	end, { index })
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

-- Show text if node at index is not empty
local show_not_empty = function(index, text)
	return f(function(args)
		if #args[1] == 0 then
			return ""
		end
		if args[1][1]:len() == 0 then
			return ""
		end
		return text
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

-- Recursive list using snippet node.
local recursive_list
recursive_list = function(text)
	return sn(nil, {
		c(1, {
			-- Important: text node has to be first, otherwise there will be infinite
			-- recursion.
			t({ "" }),
			sn(nil, {
				t({ "", "\t\\" .. text .. " " }),
				i(1),
				d(2, recursive_list, {}),
			}),
		}),
	})
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

-- =========================
-- |=======================|
-- ||                     ||
-- ||   Manual Snippets   ||
-- ||                     ||
-- |=======================|
-- =========================
return {
	s(
		{ trig = "table" },
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
		),
		{ condition = ctx.not_math, show_condition = ctx.not_math }
	),

	s(
		{ trig = "fig" },
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
		),
		{ condition = ctx.not_math, show_condition = ctx.not_math }
	),

	s(
		{ trig = "enum" },
		fmta(
			[[
        \begin{enumerate}
          \item <item>
        \end{enumerate}
      ]],
			{ item = i(1) }
		),
		{ condition = ctx.not_math, show_condition = ctx.not_math }
	),

	s(
		{ trig = "item" },
		fmta(
			[[
        \begin{itemize}
          \item <item>
        \end{itemize}
      ]],
			{ item = i(1) }
		),
		{ condition = ctx.not_math, show_condition = ctx.not_math }
	),

	s(
		{ trig = "desc" },
		fmta(
			[[
        \begin{description}
          \item[<desc>] <item>
        \end{description}
      ]],
			{ desc = i(1), item = i(2) }
		),
		{ condition = ctx.not_math, show_condition = ctx.not_math }
	),

	s(
		{ trig = "ali" },
		fmta(
			[[
        \begin{align<star>}
          <input>
        \end{align<star>}
      ]],
			{ star = toggle_text(1, "*"), input = i(2) }
		),
		{ condition = ctx.not_math, show_condition = ctx.not_math }
	),

	s(
		{ trig = "mlt" },
		fmta(
			[[
        \begin{multline<star>}
          <input>
        \end{multline<star>}
      ]],
			{ star = toggle_text(1, "*"), input = i(2) }
		),
		{ condition = ctx.not_math, show_condition = ctx.not_math }
	),
},
	{
		-- ======================
		-- |====================|
		-- ||                  ||
		-- ||   Autosnippets   ||
		-- ||                  ||
		-- |====================|
		-- ======================
		--
		-- All these snippets will expand automatically without requiring an expand
		-- trigger.
		--
		-- -----------------------------
		-- |   Chapters and Sections   |
		-- -----------------------------
		s(
			{ trig = "^(%s)chap", regTrig = true },
			fmta(
				[[
          \chapter{<name>}
          \label{<label>}
        ]],
				{
					name = i(1),
					label = c(2, {
						sn(nil, { t("chap:"), to_snake(ai[1]) }),
						i(1, "label"),
					}),
				}
			)
		),

		-- --------------------
		-- |   Environments   |
		-- --------------------
		s(
			{ trig = "^(%s*)beg", regTrig = true },
			fmta(
				[[
          <spacing>\begin{<name>}<leftpar><options><rightpar>
            <spacing><stop>
          <spacing>\end{<name2>}
        ]],
				{
					spacing = captures(1),
					name = i(1),
					name2 = same(1),
					options = i(2),
					leftpar = show_not_empty(2, "{"),
					rightpar = show_not_empty(2, "}"),
					stop = i(0),
				}
			),
			{ condition = ctx.not_math, show_condition = ctx.not_math }
		),

		-- -----------------------
		-- |   Enter Math mode   |
		-- -----------------------
		-- Inline math
		s({ trig = "mk", priority = 100 }, fmta([[$<1>$]], { i(1) }), {
			condition = ctx.math,
			show_condition = ctx.math,
			callbacks = autoinsert_space,
		}),

		-- Surround letter with inline math
		s(
			{ trig = "([%w])mk", regTrig = true, priority = 200 },
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
			{ trig = "dm" },
			fmta(
				[[
          \[
            <1>
          <2>\]
        ]],
				{ i(1), toggle_text(2, ".", true), }
			),
			{ condition = ctx.not_math, show_condition = ctx.not_math }
		),

		-- -----------------
		-- |   Fractions   |
		-- -----------------
		s(
			{ trig = "//", wordTrig = false },
			fmta([[\frac{<1>}{<2>}]], { i(1), i(2) }),
			{ condition = ctx.math, show_condition = ctx.math }
		),

		s(
			{ trig = [=[([a-zA-Z0-9_^\{}]+)/]=], wordTrig = false, regTrig = true },
			fmta([[\frac{<1>}{<2>}]], {
				f(function(_, snip)
					return snip.captures[1]
				end),
				i(1),
			}),
			{ condition = ctx.math, show_condition = ctx.math }
		),

		s({ trig = [=[^(.*[%)%}])/]=], regTrig = true }, {
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
		}, { condition = ctx.math, show_condition = ctx.math }),

		-- ---------------------------------------------
		-- |   Super and Subscripts and Text in Math   |
		-- ---------------------------------------------
		s(
			{ trig = "_", wordTrig = false },
			{ t("_{"), i(1), t("}"), i(0) },
			{ condition = ctx.math, show_condition = ctx.math }
		),

		s(
			{ trig = "sts", wordTrig = false },
			{ t([[_{\text{]]), i(1), t("}}"), i(0) },
			{ condition = ctx.math, show_condition = ctx.math }
		),

		s(
			{ trig = "td", wordTrig = false },
			{ t("^{"), i(1), t("}"), i(0) },
			{ condition = ctx.math, show_condition = ctx.math }
		),

		s(
			{ trig = "tt", wordTrig = false },
			{ t([[\text{]]), i(1), t("}"), i(0) },
			{ condition = ctx.math, show_condition = ctx.math }
		),
	}
