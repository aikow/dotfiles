local lfs = require("lfs")

local not_implemented = function()
	error("not implemented!", 2)
end

---@class Path
---@field path string
local Path = {}

---@alias RawPath { path: string }
---@alias PathLike string | RawPath | Path

Path.root_dir = "/"
Path.path_sep = "/"
Path.cur_dir = "."
Path.parent_dir = ".."

-- ------------------------------------------------------------------------
-- | Private Helper Methods
-- ------------------------------------------------------------------------

local startswith = function(s, t)
	return string.sub(s, 1, string.len(t)) == t
end

local endswith = function(s, t)
	return string.sub(s, -string.len(t)) == t
end

---comment
---@param path string
---@param ... string
---@return string
local join = function(path, ...)
	if not path or path == "" then
		path = Path.cur_dir
	else
		for _, p in ipairs(table.pack(...)) do
			if startswith(p, Path.path_sep) then
				path = p
			elseif not path or path == "" or endswith(path, Path.path_sep) then
				path = path .. p
			else
				path = path .. Path.path_sep .. p
			end
		end
	end

	return path
end

---comment
---@param path string
---@return string
local normalize = function(path)
	local parts = {}

	for part in path:gmatch("[^/]+") do
		if part == Path.parent_dir and #parts > 0 then
			-- Only remove a component if we have at least one part left.
			table.remove(parts, #parts)
		elseif part ~= Path.cur_dir then
			-- Ignore parts that are just a current dir.
			table.insert(parts, part)
		end
	end

	local joined = join(table.unpack(parts))
	if startswith(path, Path.path_sep) then
		if joined == "." then
			joined = Path.root_dir
		else
			joined = Path.root_dir .. joined
		end
	end

	return joined
end

---Converts a PathLike type into an actual raw path.
---@param pathlike PathLike
---@return RawPath
local pathlike_to_raw_path = function(pathlike)
	if type(pathlike) == "string" then
		return {
			path = pathlike,
		}
	elseif type(pathlike) == "table" and pathlike.path ~= nil then
		return pathlike
	else
		error("invalid type for path")
	end
end

-- ------------------------------------------------------------------------
-- | Constructor
-- ------------------------------------------------------------------------

---comment
---@param ... PathLike
---@return Path
function Path:new(...)
	local paths = table.pack(...)
	local raw_paths = {}
	for _, path in ipairs(paths) do
		local p = pathlike_to_raw_path(path)
		table.insert(raw_paths, normalize(p.path))
	end
	local obj = { path = join(table.unpack(raw_paths)) }

	obj.path = normalize(obj.path)

	setmetatable(obj, {
		__index = self,
		__tostring = self.tostring,
		__div = self.join,
		__concat = self.join,
	})

	return obj
end

---@return Path
function Path.cwd()
	local cwd = lfs.currentdir()
	if cwd == nil then
		error("Unable to get current working directory")
	end

	return Path:new(cwd)
end

---@return Path
function Path.home()
	local home_dir = os.getenv("HOME")
	if home_dir == nil then
		error("HOME not set in environment")
	end

	return Path:new(home_dir)
end

-- ------------------------------------------------------------------------
-- | Path Operations
-- ------------------------------------------------------------------------

---comment
---@param ... PathLike[]
---@return Path
function Path:join(...)
	return Path:new(...)
end

---comment
---@param other PathLike Unless walk_up is set to true, other must be a prefix
---of the current path.
---@param opts {walk_up: boolean}
---@return Path
function Path:relative_to(other, opts)
	if opts then
		opts.walk_up = opts.walk_up == nil and false or opts.walk_up
	else
		opts = { walk_up = true }
	end

	not_implemented()
end

-- ------------------------------------------------------------------------
-- | Part Operations
-- ------------------------------------------------------------------------

function Path:parts()
	not_implemented()
end

function Path:parent()
	local last = self.path:find("/+[^/]+/*$")
	if last == nil then
		return self:new("/")
	else
		return self:new(self.path:sub(1, last - 1))
	end
end

---Returns a list of all parents of the current path.
---@return Path[]
function Path:parents()
	local path = self
	local parents = {}

	while path ~= "/" do
		path = path:parent()
		table.insert(parents, path)
	end

	return parents
end

function Path:name()
	not_implemented()
end

function Path:stem()
	not_implemented()
end

function Path:suffix()
	not_implemented()
end

function Path:suffixes()
	not_implemented()
end

-- ------------------------------------------------------------------------
-- | Modify Parts
-- ------------------------------------------------------------------------

function Path:with_name()
	not_implemented()
end

function Path:with_stem()
	not_implemented()
end

function Path:with_suffix()
	not_implemented()
end

-- ------------------------------------------------------------------------
-- | Attributes
-- ------------------------------------------------------------------------

---comment
---@return LfsAttributes
function Path:stat()
	return lfs.attributes(self.path)
end

---If the current path is a symlink, reeturn the attributes of the symlink
---itself, not the file it points to.
---@return LfsSymlinkAttributes
function Path:lstat()
	return lfs.symlinkattributes(self.path)
end

---comment
---@return boolean
function Path:exists()
	not_implemented()
end

---comment
---@return boolean
function Path:is_file()
	not_implemented()
end

---comment
---@return boolean
function Path:is_dir()
	not_implemented()
end

---comment
---@return boolean
function Path:is_symlink()
	not_implemented()
end

---comment
---@return boolean
function Path:is_socket()
	not_implemented()
end

---comment
---@return boolean
function Path:is_fifo()
	not_implemented()
end

---comment
---@return boolean
function Path:is_block_device()
	not_implemented()
end

---comment
---@return boolean
function Path:is_char_device()
	not_implemented()
end

---comment
---@return boolean
function Path:is_executable()
	not_implemented()
end

---comment
---@param other PathLike
---@return boolean
function Path:is_samefile(other)
	not_implemented()
end

---comment
---@return boolean
function Path:is_absolute()
	not_implemented()
end

---comment
---@return boolean
function Path:is_relative()
	not_implemented()
end

---comment
---@param other PathLike
---@return boolean
function Path:is_relative_to(other)
	not_implemented()
end

-- ------------------------------------------------------------------------
-- | Symlink Operations
-- ------------------------------------------------------------------------

---Read the value of the symlink if the current path is a symlink.
---@return Path
function Path:readlink()
	not_implemented()
end

---comment
---@return Path
function Path:resolve()
	not_implemented()
end

---comment
---@return Path
function Path:expand_user()
	not_implemented()
end

---comment
---@return Path
function Path:absolute()
	not_implemented()
end

-- ------------------------------------------------------------------------
-- | File System Exploration
-- ------------------------------------------------------------------------

---Return the contents of the directory if the current path is a directory.
---@return Path[]
function Path:dir()
	not_implemented()
end

---Return the contents of the directory and all child directories if the current
---path is a directory.
---@return Path[]
function Path:walk()
	not_implemented()
end

-- ------------------------------------------------------------------------
-- | File System Operations
-- ------------------------------------------------------------------------

function Path:chmod() end

function Path:touch()
	not_implemented()
end

function Path:rmdir()
	not_implemented()
end

---comment
---@param opts {parents: boolean, exists_ok: boolean}
function Path:mkdir(opts)
	not_implemented()
end

---comment
---@param target PathLike
function Path:symlink_to(target)
	not_implemented()
end

---comment
---@param target PathLike
function Path:link_to(target)
	not_implemented()
end

function Path:unlink()
	not_implemented()
end

function Path:rename(target)
	not_implemented()
end

function Path:replace(target)
	not_implemented()
end

---comment
---@param contents string
function Path:write(contents)
	not_implemented()
end

-- ------------------------------------------------------------------------
-- | Glob Matching
-- ------------------------------------------------------------------------

---Match the current path against the glob pattern.
---@param glob string
function Path:match(glob)
	not_implemented()
end

---Glob the given relative pattern in the directory represented by this path,
---retiring a list of all matching files.
---@param glob string
function Path:glob(glob)
	not_implemented()
end

-- ------------------------------------------------------------------------
-- | Path Object Meta
-- ------------------------------------------------------------------------

---comment
---@return string
function Path:tostring()
	return self.path
end

-- ------------------------------------------------------------------------
-- | Path Table Meta
-- ------------------------------------------------------------------------

setmetatable(Path, {
	__call = Path.new,
})

return {
	Path = Path,
}
