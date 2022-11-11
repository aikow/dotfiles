local M = {}

---@param t table
---@return boolean
M.isdict = function(t)
  return type(t) == "table" and (not vim.tbl_islist(t) or vim.tbl_isempty(t))
end

---@param t1 table
---@param t2 table
---@return table
M.deep_type_extend = function(t1, t2)
  t1 = vim.deepcopy(t1)
  t2 = vim.deepcopy(t2)

  if vim.tbl_islist(t1) and vim.tbl_islist(t2) then
    -- list + list
    vim.list_extend(t1, t2)
    return t1
  end

  if M.isdict(t1) and M.isdict(t2) then
    -- dict + dict
    t1 = vim.tbl_deep_extend("keep", t1, t2)
    return t1
  end

  if
    (vim.tbl_islist(t1) and M.isdict(t2))
    or (M.isdict(t1) and vim.tbl_islist(t2))
  then
    -- list + dict
    -- dict + list
    vim.notify("Cannot merge list and table", vim.log.levels.WARN)
  end
  return t1
end

return M
