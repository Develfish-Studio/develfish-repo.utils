--!strict

local describe = require("@lorry.testing/lib/describe")
local Shell = require("@root/lib/Shell")

return describe("Shell Utils") (
  function (it)
    it("should provide ability to exec command") (
      function (check)
        check.eq(Shell:default():exec('echo "Hello"').stdout, 'Hello')
      end
    )
  end
)
