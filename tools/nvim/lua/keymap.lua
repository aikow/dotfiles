local M = {}

function M.map(lhs, rhs, opts)
	opts = opts or {}
	if type(rhs) == "function" and not opts.desc then
		print("Missing description for lua function")
	end
	vim.keymap.set("", lhs, rhs, opts)
end

function M.nmap(lhs, rhs, opts)
	opts = opts or {}
	if type(rhs) == "function" and not opts.desc then
		print("Missing description for lua function")
	end
	vim.keymap.set("n", lhs, rhs, opts)
end

function M.imap(lhs, rhs, opts)
	opts = opts or {}
	if type(rhs) == "function" and not opts.desc then
		print("Missing description for lua function")
	end
	vim.keymap.set("i", lhs, rhs, opts)
end

function M.cmap(lhs, rhs, opts)
	opts = opts or {}
	if type(rhs) == "function" and not opts.desc then
		print("Missing description for lua function")
	end
	vim.keymap.set("c", lhs, rhs, opts)
end

function M.vmap(lhs, rhs, opts)
	opts = opts or {}
	if type(rhs) == "function" and not opts.desc then
		print("Missing description for lua function")
	end
	vim.keymap.set("v", lhs, rhs, opts)
end

function M.xmap(lhs, rhs, opts)
	opts = opts or {}
	if type(rhs) == "function" and not opts.desc then
		print("Missing description for lua function")
	end
	vim.keymap.set("x", lhs, rhs, opts)
end

function M.smap(lhs, rhs, opts)
	opts = opts or {}
	if type(rhs) == "function" and not opts.desc then
		print("Missing description for lua function")
	end
	vim.keymap.set("s", lhs, rhs, opts)
end

function M.omap(lhs, rhs, opts)
	opts = opts or {}
	if type(rhs) == "function" and not opts.desc then
		print("Missing description for lua function")
	end
	vim.keymap.set("o", lhs, rhs, opts)
end

function M.tmap(lhs, rhs, opts)
	opts = opts or {}
	if type(rhs) == "function" and not opts.desc then
		print("Missing description for lua function")
	end
	vim.keymap.set("t", lhs, rhs, opts)
end

function M.lmap(lhs, rhs, opts)
	opts = opts or {}
	if type(rhs) == "function" and not opts.desc then
		print("Missing description for lua function")
	end
	vim.keymap.set("l", lhs, rhs, opts)
end

return M
