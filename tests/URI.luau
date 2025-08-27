local describe = require("@lorry.testing/lib/describe")
local URI = require("@root/lib/URI")

describe("URI Utils") (
  function (it)
    it("should provide ability parse URI") (
      function (check)
        local uri = URI:parse('https://john.doe:123456@www.example.com:123/forum/questions/?tag=networking&order=newest#top')
        check.eq(uri.schema, 'https')
        check.eq(uri.username, 'john.doe')
        check.eq(uri.password, '123456')
        check.eq(uri.hostname, 'www.example.com')
        check.eq(uri.port, '123')
        check.eq(uri.path, '/forum/questions/')
        check.eq(uri.query, 'tag=networking&order=newest')
        check.eq(uri.fragment, 'top')
      end
    )

    it("should provide ability to format URIs") (
      function (check)
        local examples = {
          ['http://localhost'] = 'http://localhost',
          ['http://localhost:8080'] = 'http://localhost:8080',
          ['http://localhost:8080/path/to/route'] = 'http://localhost:8080/path/to/route',
          ['http://localhost/path/to/route'] = 'http://localhost/path/to/route',
          ['http://localhost/path/to/route?foo=1&bar=2'] = 'http://localhost/path/to/route?foo=1&bar=2',
          ['http://localhost/path/to/route?foo=1&bar=2#some'] = 'http://localhost/path/to/route?foo=1&bar=2#some',
          ['http://localhost/'] = 'http://localhost/',
          ['http://username@localhost:8080/path/to/route'] = 'http://username@localhost:8080/path/to/route',
          ['http://username@localhost/path/to/route'] = 'http://username@localhost/path/to/route',
          ['http://username:password@localhost:8080/path/to/route'] = 'http://username:password@localhost:8080/path/to/route',
          ['http://username:password@localhost/path/to/route'] = 'http://username:password@localhost/path/to/route',
          ['//localhost/path/to/route'] = '//localhost/path/to/route',
          ['//username:password@localhost/path/to/route'] = '//username:password@localhost/path/to/route',

          ['https://john.doe@www.example.com:123/forum/questions/?tag=networking&order=newest#top'] = 'https://john.doe@www.example.com:123/forum/questions/?tag=networking&order=newest#top',
          ['ldap://[2001:db8::7]/c=GB?objectClass?one'] = 'ldap://[2001:db8::7]/c=GB?objectClass?one',
          ['mailto:John.Doe@example.com'] = 'mailto:John.Doe@example.com',
          ['news:comp.infosystems.www.servers.unix'] = 'news:comp.infosystems.www.servers.unix',
          ['tel:+1-816-555-1212'] = 'tel:+1-816-555-1212',
          ['telnet://192.0.2.16:80/'] = 'telnet://192.0.2.16:80/',
          ['urn:oasis:names:specification:docbook:dtd:xml:4.1.2'] = 'urn:oasis:names:specification:docbook:dtd:xml:4.1.2',
        }

        for from, to in examples do
          local parsed = URI:parse(from)
          local formatted = parsed:format()
          check.eq(to, formatted, `Assertion failed. {to} ~= {formatted}`)
        end

      end
    )
  end
)

return {}