---Contains global lua definitions.

---Iterate over a list in reverse.
---@param ls table The list over which to iterate.
---@return function The iterator function.
---@return table The iterator list state.
---@return integer The iterator current position.
_G.rpairs = function(ls)
  if type(ls) ~= "table" then
    error(string.format("expected list, got %s instead", type(ls)))
  elseif not vim.tbl_islist(ls) then
    error("expected list, got table instead", 2)
  end

  local reversed_iter = function(t, i)
    i = i - 1
    if i ~= 0 then return i, t[i] end
  end

  return reversed_iter, ls, #ls + 1
end

---Pretty print an object.
---@param o any The object to print.
_G.pp = function(o) print(vim.inspect(o)) end

---Pretty print an object in a single line.
---@param o any The object to print.
_G.ppo = function(o) print(string.gsub(vim.inspect(o), "\n", " ")) end
