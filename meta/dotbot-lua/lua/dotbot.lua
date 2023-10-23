local lfs = require("lfs")

local dotbot = {}

dotbot.ensure = function(condition)
	if not condition then
		os.exit(0)
	end
end

dotbot.run = function(script)
	local success, exitcode, code = os.execute(script)
end

dotbot.link = function(links, opts)
	if type(links) ~= "table" then
		error("links should be a table of links", 2)
	end

	opts = opts or {}

	for target, source in pairs(links) do
	end
end

return dotbot
