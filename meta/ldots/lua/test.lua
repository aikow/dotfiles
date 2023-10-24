local assert_eq = function(lhs, rhs, message)
	if lhs ~= rhs then
		error(string.format("%s ~= %s : %s", lhs, rhs, message), 2)
	end
end

local Test = {}

Test.join = function()
	local path = require("path")

	local a = path:new("/path/to")
	local b = path:new("/d/e/f.txt")

	assert_eq("/path/to//d/e/f.txt", (a / b).path)
end

-- Run all tests
for name, test in pairs(Test) do
	local success = pcall(test)
	print(name, success)
end

return Test
