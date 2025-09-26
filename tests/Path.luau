--!strict

local describe = require("@lorry.testing/lib/describe")
local Path = require("@root/lib/Path")

return describe("Path Utils") (
  function (it)
    it("should provide ability to parse path") (
      function (check)
        check.assert('' == Path:new():to_string())
        check.assert('path/to/smth' == Path:from_segments({ 'path', 'to', 'smth' }):to_string())
        check.assert('path/to/smth' == Path:from_string('path/to/smth'):to_string())
        check.assert('path/smth' == Path:from_string('path/./to/../smth'):normalize():to_string())
        check.assert('../path/to/smth' == Path:from_string('../path/to/smth'):normalize():to_string())
        check.assert('to/smth' == Path:from_string('path/../to/smth'):normalize():to_string())
        check.assert('../to/smth' == Path:from_string('path/../../to/smth'):normalize():to_string())
        check.assert('path/to/smth' == Path:from_string('path/./to/smth/'):normalize():to_string())
        check.assert('/' == Path:from_string('///'):normalize():to_string())
        check.assert('..' == Path:from_string('/../'):normalize():to_string())
        check.assert('..' == Path:from_string('../'):normalize():to_string())
        check.assert('..' == Path:from_string('/..'):normalize():to_string())
        check.assert('..' == Path:from_string('//..//'):normalize():to_string())

        check.assert('one/two/three/four' == Path:from_string('one/two'):join_string('three/four'):normalize():to_string())
        check.assert('one/two/three/four' == Path:from_string('one/two'):join_string('/three/four'):normalize():to_string())
        check.assert('one/two/three/four' == Path:from_string('one/two/'):join_string('three/four'):normalize():to_string())
        check.assert('one/two/three/four' == Path:from_string('one/two/'):join_string('/three/four'):normalize():to_string())

        local first, second, third = Path:parse('/first/second/third'):path()
        check.assert('first' == first)
        check.assert('second' == second)
        check.assert('third' == third)

      end
    )
  end
)
