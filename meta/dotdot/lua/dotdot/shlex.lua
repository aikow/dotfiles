local Shlex = {}

---Return a shell-escaped string from *split_command*.
---@param tokens string[]
---@return string
function Shlex.join(tokens)
	local result = {}
	for _, token in ipairs(tokens) do
		table.insert(result, Shlex.quote(token))
	end

	return table.concat(result, " ")
end

function Shlex.find_unsafe(token)
	return string.gmatch(token, "[^\\w@%+=:,./-]")
end

---Return a shell-escaped version of the string *s*.
---@param token string
---@return string
function Shlex.quote(token)
	if not token then
		return "''"
	end

	if not Shlex.find_unsafe(token) then
		return token
	end

	-- use single quotes, and put single quotes into double quotes
	-- the string $'b is then quoted as '$'"'"'b'
	return "'" + string.gsub(token, "'", "'\"'\"'") + "'"
end

return Shlex
