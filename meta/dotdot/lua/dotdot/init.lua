local Path = require("dotdot.path")
local Shlex = require("dotdot.shlex")

local Dotdot = {}

Dotdot.Path = Path
Dotdot.Shlex = Shlex

---Checks whether a given command can be found on PATH
---@param cmd string
---@return boolean
function Dotdot.executable(cmd)
	local success = os.execute(string.format("command -v '%s'", cmd))

	return success or false
end

---Capture command output as a single string with newlines.
---@param cmd string The command to run
---@param opts {trim: "none" | "all" | "right" | "left" | nil, normalize_line_endings: boolean?}?
---@return string
function Dotdot.run(cmd, opts)
	opts = opts or {}
	opts.trim = opts.trim == nil and "none" or opts.trim
	opts.normalize_line_endings = opts.normalize_line_endings == nil and true or opts.normalize_line_endings

	local process, errmsg = io.popen(cmd, "r")
	if process == nil then
		error(errmsg, 2)
	end

	local out = process:read("*a")
	process:close()

	-- Trim each line and normalize new line characters.
	if opts.trim == "all" or opts.trim == "left" then
		out = string.gsub(out, "^%s+", "")
	end

	if opts.trim == "all" or opts.trim == "right" then
		out = string.gsub(out, "%s+$", "")
	end

	if opts.normalize_line_endings then
		out = string.gsub(out, "[\n\r]+", "\n")
	end

	return out
end

---Create all directories in the given list.
---@param dirs PathLike[]
---@param opts {parents: boolean, exists_ok: boolean}?
function Dotdot.create(dirs, opts)
	if type(dirs) ~= "table" then
		error("dirs should be a list of paths", 2)
	end

	for _, dir in ipairs(dirs) do
		Path(dir):mkdir(opts)
	end
end

---Create all links in the table
---@param links { [string]: string }
function Dotdot.link(links)
	if type(links) ~= "table" then
		error("links should be a table of links", 2)
	end

	for target, source in pairs(links) do
		Path(source):symlink_to(target)
	end
end

return Dotdot
