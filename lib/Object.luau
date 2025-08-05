local Meta = require('./Meta')

local Object = {}

type table = { [any]: any }

function Object:spread(template)
  return function(table)
    local result = Meta:table {}
    for key, value in pairs(template) do
        result[key] = value
    end
    for key, value in pairs(table) do
        result[key] = value
    end
    return result
  end
end

return Object
