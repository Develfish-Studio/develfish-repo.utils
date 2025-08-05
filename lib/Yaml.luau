local Yaml = {}

function Yaml:stringify(obj): string
  return yaml:stringify(obj)
end

return Yaml
