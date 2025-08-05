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

return Meta
