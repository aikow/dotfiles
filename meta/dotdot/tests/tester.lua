local Tester = {}

function Tester.assert_eq(expected, actual, message)
	if expected ~= actual then
		local msg = string.format(
			[[Assertion error: '%s' ~= '%s'
  Expected: '%s'
  Actual: '%s'
  Message: %s]],
			expected,
			actual,
			expected,
			actual,
			message
		)
		error(msg, 2)
	end
end

---Test a method for all given parameters.
---@param fn function
---@param arguments { ["1"]: any, ["2"]: any[] }[]
---@param opts { format: string }?
function Tester.test_function_arguments(fn, arguments, opts)
	for i, testcase in ipairs(arguments) do
		local expected, args = table.unpack(testcase)
		local actual = fn(table.unpack(args))
    Tester.assert_eq(expected, actual, )
	end
end

return Tester
