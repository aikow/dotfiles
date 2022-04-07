local Set = {}

Set.mt = {}

function Set.new(t)
  local set = {}
  setmetatable(set, Set.mt)

  for _, v in ipairs(t) do
    set[v] = true
  end

  return set
end

function Set.union(a, b)
  local res = Set.new({})

  for k in pairs(a) do
    res[k] = true
  end
  for k in pairs(b) do
    res[k] = true
  end

  return res
end

function Set.intersection(a, b)
  local res = Set.new({})

  for k in pairs(a) do
    res[k] = b[k]
  end

  return res
end

function Set.tostring(set)
  local s = "{"
  local sep = ""
  for e in pairs(set) do
    s = s .. sep .. e
    sep = ", "
  end
  return s .. "}"
end

function Set.print(s)
  print(Set.tostring(s))
end

Set.mt.__add = Set.union
Set.mt.__mul = Set.intersection

return Set
