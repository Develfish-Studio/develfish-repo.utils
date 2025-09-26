--!strict

local Meta = {}

export type Some = {} | number | string | boolean | thread | vector | buffer

function Meta:array<T>(array): T
  setmetatable(array, array_mt)
  return (array::unknown)::T
end

function Meta:table<T>(array): T
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

function Meta:coalesce<T>(...: T?): T?
  for _, item in {...} do
    if item ~= nil then
      return item
    end
  end
  return nil
end

function Meta:merge(...: {}?): {}
  local merged = Meta:table {}
  for _, item in {...} do
    if item ~= nil then
      for k, v in item do
        merged[k] = v
      end
    end
  end
  return merged
end

function Meta:append<P, Q>(one: (P & {})?): ((Q & {})?) -> P & Q
  return function(another: (Q & {})?): (P & Q & {})
    return Meta:merge(another, one)::(P & Q & {})
  end
end

function Meta:prepend<P, Q>(one: (P & {})?): ((Q & {})?) -> {}
  return function(another: (Q & {})?): (P & Q & {})
    return Meta:merge(one, another)::(P & Q & {})
  end
end

function Meta:merge2<P, Q>(
  one: (P & {})?,
  two: (Q & {})?
): P & Q & {}
  return Meta:merge(one, two)::(P & Q & {})
end

function Meta:merge3<P, Q, R>(
  one: (P & {})?,
  two: (Q & {})?,
  three: (R & {})?
): P & Q & {}
  return Meta:merge(one, two, three)::(P & Q & R & {})
end

function Meta:merge4<P, Q, R, S>(
  one: (P & {})?,
  two: (Q & {})?,
  three: (R & {})?,
  four: (S & {})?
): P & Q & {}
  return Meta:merge(one, two, three, four)::(P & Q & R & S & {})
end

export type AnyTable = {
  [any]: any
}

function Meta:or_default<T>(value: T?, fallback: T): T
  if value == nil then
    return fallback
  else
    return value
  end
end

function Meta:or_object_defaults<T>(value: AnyTable?, defaults: T & AnyTable): T
  return Meta:merge(value, defaults)::(T & AnyTable)
end

function Meta:apply_default<T>(value: T?): (T) -> T
  return function(fallback: T): T
    return Meta:or_default(value, fallback)
  end
end

function Meta:apply_object_defaults<T>(value: AnyTable?): (T & AnyTable) -> T
  return function(defaults: T & AnyTable): T
    return Meta:or_object_defaults(value, defaults)
  end
end

function Meta:map_array<V, R>(array: {V}, mapper: (v: V, i: number) -> R): {R}
  local result = Meta:array {}
  for i, v in array do
    result[#result + 1] = mapper(v, i)
  end
  return result
end

function Meta:to_sequence<V>(array: {V}): ...V
  return table.unpack(array)
end

function Meta:map_values<K, V, R>(dict: {[K]: V}, mapper: (v: V, k: K) -> R): {[K]: R}
  local result = Meta:table {}
  for k, v in dict do
    result[k] = mapper(v, k)
  end
  return result
end

function Meta:map_keys<K, V, R>(dict: {[K]: V}, mapper: (k: K, v: V) -> R): {[R]: V}
  local result = Meta:table {}
  for k, v in dict do
    result[mapper(k, v)] = v
  end
  return result
end

function Meta:associate<K, V, NK>(dict: {[K]: V}, compute_key: (v: V, k: K) -> NK): {[NK]: V}
  local result: {[NK]: V} = Meta:table {}
  for k, v in dict do
    local nk = compute_key(v, k)
    result[nk] = v
  end
  return result
end

function Meta:associate_by<K, V, NK>(dict: {[K]: V}, field: string): {[NK]: V}
  return Meta:associate(dict, function (v, k) return ((v::unknown)::{})[field] end)
end

return Meta
