local Meta = require('./Meta')
local Array = {}

function Array:concat(a, b)
  local result = {table.unpack(a)}
  table.move(b, 1, #b, #result + 1, result)
  return result
end

function Array:copy(array)
  local result = Meta:array {}
  for i, item in array do
    result[i] = item
  end
  return result
end

function Array:is_array(array)
  local mt = getmetatable(array)
  return type(array) == "table" and (mt == array_mt or not mt)
end

function Array:is_empty(array)
  assert(Array:is_array(array))
  return #array == 0
end

function Array:compare(array1, array2)
  if not Array:is_array(array1) then
    return false
  end
  if not Array:is_array(array2) then
    return false
  end
  if #array1 ~= #array2 then
    return false
  end
  for i,v in pairs(array1) do
    if v ~= array2[i] then
      return false
    end
  end
  return true
end

return Array
