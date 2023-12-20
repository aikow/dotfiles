local Test = {}

Test.new = function()
	local P = require("path").Path
	local testcases = {
		{ ".", "" },
		{ ".", "." },
		{ ".", "./" },
		{ ".", "./." },
		{ ".", "././" },
		{ "/", "/" },
		{ "/", "//" },
		{ "/", "///." },
		{ "/", "///./" },
	}

	for i, testcase in ipairs(testcases) do
		assert_eq(testcase[1], P(testcase[2]).path, string.format([[(%s) - Path("%s")]], i, testcase[2]))
	end
end

Test.parent = function()
	local P = require("path").Path
	local testcases = {
		{ "/", "/" },
		{ "/", "//" },
		{ "/", "///" },
		{ "/", "/./" },
		{ "/", "/a" },
		{ "/", "/a/" },
		{ "/a/b", "/a/b/c.d" },
		{ "/a/b", "/a/b/c.d/" },
	}

	for i, testcase in ipairs(testcases) do
		assert_eq(
			testcase[1],
			P(testcase[2]):parent().path,
			string.format([[(%s) - Path("%s"):parent()]], i, testcase[2])
		)
	end
end

Test.join = function()
	local P = require("path").Path
	local testcases = {
		{ "/path/to/d/e/f.txt", { "/path/to", "/d/e/f.txt" } },
	}

	for i, testcase in ipairs(testcases) do
		local x, y = table.unpack(testcase[2])
		assert_eq(testcase[1], P(x):join(y).path, string.format([[(%s) - Path("%s"):join("%s")]], i, x, y))
	end
end

-- Run all tests
for name, test in pairs(Test) do
	local success, err_msg = pcall(test)
	if success then
		print(string.format("Running tests for %s: passed", name))
	else
		print(string.format("Running tests for %s: failed - %s", name, err_msg))
	end
end

return Test
