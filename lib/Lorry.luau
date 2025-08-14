local Template = require('./Template')
local Json = require('./Json')
local Yaml = require('./Yaml')

local Lorry = {
  Template = Template,
  Json = Json,
  Yaml = Yaml,
}

function Lorry:generate(scroll_name: string)
  return function (config: { target: string?, target_path: string?, variables: any })
    local target = {
      target_name = config and config.target or nil,
      target_path = config and config.target_path or nil
    }
    local vars = config and config.variables or {}
    if typeof(vars) == 'table' and typeof(vars.unwrap) == 'function' then
      engine:generate(scroll_name, target, vars:unwrap())
    else
      engine:generate(scroll_name, target, vars)
    end
  end
end

function Lorry:variables<T>()
  return variables :: T
end

return Lorry
