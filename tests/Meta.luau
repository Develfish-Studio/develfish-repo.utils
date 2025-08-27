local describe = require("@lorry.testing/lib/describe")
local Meta = require("@root/lib/Meta")

describe("Meta Utils") (
  function (it)
    it("should provide ability to build indexed array") (
      function (check)
        local vector = Meta:array { 1, 2, 3 }
        check.eq(#vector, 3, "Invalid array size")
        check.eq(type(vector), "table", "Invalid type of constructed table")
        check.eq(typeof(vector), "table", "Invalid type of constructed table")
      end
    )

    it("should provide ability to build mapped table") (
      function (check)
        local dict = Meta:table { one = 1, two = 2 }
        check.eq(type(dict), "table", "Invalid type of constructed table")
        check.eq(typeof(dict), "table", "Invalid type of constructed table")
        check.eq(dict.one, 1, "Invalid element")
        check.eq(dict.two, 2, "Invalid element")
      end
    )

    it("should provide ability to build class") (
      function (check)
        type PersonProps = {
          first_name: string,
          last_name: string,
        }

        type PersonMethods = {
          full_name: (self: PersonProps & PersonMethods) -> string
        }

        local PersonMethodsImpl: PersonMethods = {
          full_name = function(self: PersonProps & PersonMethods)
            return self.first_name .. ' ' .. self.last_name
          end
        };

        local person = Meta:type({ first_name = 'Henry', last_name = 'Oscar' }, PersonMethodsImpl)
        check.eq(person:full_name(), "Henry Oscar", "Invalid full name")
      end
    )
  end
)

return {}