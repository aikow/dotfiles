local lfs = require("lfs")

---@class Path
---@field path string
local Path = {}

Path.cur_dir = "."
Path.parent_dir = ".."

---comment
---@param p string
---@return Path
function Path:new(p)
	local path
	if type(p) == "string" then
		path = {
			path = p,
		}
	elseif type(p) == "table" then
		path = p
	else
		error("invalid type for path")
	end

	setmetatable(path, {
		__index = self,
		__tostring = self.tostring,
		__div = Path.join,
	})

	return path
end

function Path:normalize() end

function Path:resolve() end

---comment
---@param other Path
function Path:join(other)
	return Path:new(self.path .. "/" .. other.path)
end

function Path:parent()
	local last = self.path:find("/+[^/]+/*$")
	return self:new(self.path:sub(1, last))
end

---comment
---@return boolean
function Path:is_dir()
	return true
end

function Path:tostring()
	return self.path
end

return Path
