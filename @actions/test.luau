local Suite = require('@lorry.testing/lib/suite')

Suite("Utils") {
  require('../tests/Meta'),
  require('../tests/Case'),
  require('../tests/Array'),
  require('../tests/Table'),
  require('../tests/Object'),
  require('../tests/String'),
  require('../tests/Path'),
  require('../tests/URI'),
  require('../tests/Shell'),
}
