--!strict

local describe = require("@lorry.testing/lib/describe")
local Meta = require("@root/lib/Meta")
local Array = require("@root/lib/Array")

return describe("Array Utils") (
  function (it)
    it("should provide ability to compare arrays") (
      function (check)
        check.assert(Array:compare(Meta:array {1, 2, 3}, Meta:array {1, 2, 3}), "This two arrays should be equal")
        check.assert(not Array:compare(Meta:array {1, Meta:array {2, 3}, 4, 5}, Meta:array {1, Meta:array {2, 3}, 4, 5}), "This two arrays should be equal")
        check.assert(not Array:compare(Meta:array {1, 2, 3, 4}, Meta:array {1, 2, 3}), "This two arrays should not be equal (compare is a shallow operation)")
        check.assert(not Array:compare(Meta:array {1, Meta:array {2}, 3}, Meta:array {1, 2, 3}), "This two arrays should not be equal")
        check.assert(not Array:compare(Meta:array {2, 3, 1}, Meta:array {1, 2, 3}), "This two arrays should not be equal")
      end
    )

    it("should provide ability to copy array") (
      function (check)
        local arr1 = Meta:array { 5, 6, 7 }
        local arr2 = Array:copy(arr1)
        check.assert(Array:compare(arr1, arr2), "This two arrays should be equal")
        arr2[1] += 1
        check.assert(not Array:compare(arr1, arr2), "This two arrays should not be equal anymore")
      end
    )

    it("should provide ability to concat arrays") (
      function (check)
        local arr1 = Meta:array { 2, 3, 4 }
        local arr2 = Meta:array { 5, 6 }
        check.assert(Array:compare(Meta:array { 2, 3, 4, 5, 6 }, Array:concat(arr1, arr2)), "This two arrays should be equal")
      end
    )
  end
)
