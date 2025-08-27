local Meta = require('./Meta')
local Table = {}

function Table:merge(a, b)
  assert(Table:is_table(a))
  assert(Table:is_table(b))
  local result = Meta:table {}
  for k, v in a do
    result[k] = v
  end
  for k, v in b do
    result[k] = v
  end
  return result
end

function Table:copy(table)
  assert(Table:is_table(table))
  local result = Meta:table {}
  for i, item in table do
    result[i] = item
  end
  return result
end

function Table:deep_copy(obj: any, seen: ({ [any]: {} })?)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end

  local s = seen or ({} :: { [any]: {} })
  local res = {}
  s[obj] = res
  for k, v in pairs(obj) do res[Table:deep_copy(k, s)] = Table:deep_copy(v, s) end
  return setmetatable(res, getmetatable(obj) or nil)
end

function Table:is_table(table)
  -- local mt = getmetatable(table)
  -- return type(table) == "table" and type(mt) == "table"
  return type(table) == "table"
end

function Table:is_empty(table)
  assert(Table:is_table(table), "Actual type: " .. typeof(table))
  return next(table) == nil
end

function Table:compare(table1, table2)
  if not Table:is_table(table1) then
    return false
  end
  if not Table:is_table(table2) then
    return false
  end

  for i,v in pairs(table1) do
    if v ~= table2[i] then
      return false
    end
  end

  for i,v in pairs(table2) do
    if v ~= table1[i] then
      return false
    end
  end

  return true
end

return Table
