local Meta = {}

function Meta:array<T>(array)
  setmetatable(array, array_mt)
  return (array::unknown)::T
end

function Meta:table<T>(array)
  setmetatable(array, {})
  return (array::unknown)::T
end

function Meta:type<T>(object: any, type: any, name: string?)
  object = object or {}
  setmetatable(object, type)
  type.__index = type
  if (name ~= nil) then
    type.__type = name
  end
  return (object::unknown)::T
end

function Meta:typeof(object: any)
  local type_name = typeof(object)
  if type_name == 'table' and object.__type ~= nil then
    return object.__type
  end
  return type_name
end

return Meta
