--!strict

local Yaml = {}

function Yaml:stringify(obj): string
  return yaml:stringify(obj)
end

function Yaml:parse<T>(st: string): T
  return yaml:parse(st)
end

return Yaml
