local describe = require("@develfish-repo.testing/lib/describe")
local Meta = require("@root/lib/Meta")
local Table = require("@root/lib/Table")

describe("Table Utils") (
  function (it)
    it("should provide ability to compare tables") (
      function (check)
        check.assert(Table:compare(Meta:table { one = 1, two = 2 }, Meta:table { one = 1, two = 2 }), "This two tables should be equal")
        check.assert(Table:compare(Meta:table { one = 1, two = 2 }, Meta:table { two = 2, one = 1 }), "This two tables should be equal")

        check.assert(not Table:compare(Meta:table { one = 1, two = 2 }, Meta:table { one = 1, two = 2, three = 3 }), "This two tables should not be equal")
        check.assert(not Table:compare(Meta:table { one = 1, two = 2, three = 3 }, Meta:table { one = 1, two = 2 }), "This two tables should not be equal")
        check.assert(not Table:compare(Meta:table { one = 1, two = 222 }, Meta:table { one = 1, two = 2 }), "This two tables should not be equal")
      end
    )

    it("should provide ability to copy table") (
      function (check)
        local table1 = Meta:table { five = 5, six = 6, seven = 7 }
        local table2 = Table:copy(table1)
        check.assert(Table:compare(table1, table2), "This two tables should be equal")
        table2.five = 55
        check.assert(not Table:compare(table1, table2), "This two tables should not be equal anymore")
      end
    )

    it("should provide ability to deep copy table") (
      function (check)
        local table = Meta:table {
          nine = 9,
          ten = Meta:table { one = 1, zero = 0 },
          eleven = Meta:array { 1, 1 }
        }
        check.eq(json:stringify(Table:deep_copy(table)), json:stringify(table), "This two tables should be equal")
      end
    )

    it("should provide ability to merge tables") (
      function (check)
        local table1 = Meta:table { two = 2, three = 3, four = 4 }
        local table2 = Meta:table { five = 5, six = 6 }
        local result = Table:merge(table1, table2)
        local expected = Meta:table { two = 2, three = 3, four = 4, five = 5, six = 6 }
        check.assert(Table:compare(result, expected), "This two arrays should be equal")
      end
    )
  end
)

return {}