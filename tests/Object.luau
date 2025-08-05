local describe = require("@develfish-repo.testing/lib/describe")
local Meta = require("@root/lib/Meta")
local Object = require("@root/lib/Object")
local Table = require("@root/lib/Table")

describe("Object Utils") (
  function (it)
    it("should provide spread factory method") (
      function (check)
        local spread = Object:spread({ other = "other", data = "data" })
        local obj1 = spread({ foo = "foo" })
        local obj2 = spread({ bar = "bar" })
        check.assert(Table:compare(obj1, Meta:table { foo = "foo", other = "other", data = "data" }))
        check.assert(Table:compare(obj2, Meta:table { bar = "bar", other = "other", data = "data" }))
      end
    )
  end
)

return {}