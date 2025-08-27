local describe = require("@lorry.testing/lib/describe")
local Case = require("@root/lib/Case")

describe("Case Utils") (
  function (it)
    it("should provide ability to convert strings in snake case") (
      function (check)
        check.eq(Case:snake_to_title('some_long'), 'Some Long')
        check.eq(Case:snake_to_camel('some_long'), 'someLong')
        check.eq(Case:snake_to_kebab('some_long'), 'some-long')
        check.eq(Case:snake_to_pascal('some_long'), 'SomeLong')
        check.eq(Case:snake_to_prop('some_long'), 'some.long')

        check.eq(Case:snake_to_title('some_long_string'), 'Some Long String')
        check.eq(Case:snake_to_camel('some_long_string'), 'someLongString')
        check.eq(Case:snake_to_kebab('some_long_string'), 'some-long-string')
        check.eq(Case:snake_to_pascal('some_long_string'), 'SomeLongString')
        check.eq(Case:snake_to_prop('some_long_string'), 'some.long.string')
      end
    )

    it("should provide ability to convert strings in prop case") (
      function (check)
        check.eq(Case:prop_to_path('some.long'), 'some/long')
        check.eq(Case:prop_to_snake('some.long'), 'some_long')

        check.eq(Case:prop_to_path('some.long.string'), 'some/long/string')
        check.eq(Case:prop_to_snake('some.long.string'), 'some_long_string')
      end
    )
  end
)

return {}