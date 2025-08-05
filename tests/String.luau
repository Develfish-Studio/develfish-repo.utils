local describe = require("@develfish-repo.testing/lib/describe")
local String = require("@root/lib/String")

describe("String Utils") (
  function (it)
    it("should provide ability to split string by separator") (
      function (check)
        check.eq('one, two, three', table.concat(String:split('one.two.three', String.EXPR_DOT), ', '))
        check.eq('one, two, three', table.concat(String:split('one/two/three', String.EXPR_SLASH), ', '))
      end
    )
  end
)

return {}