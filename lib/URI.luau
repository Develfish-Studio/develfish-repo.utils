local Meta = require("./Meta")

type URI = {
  schema: string,
  username: string?,
  password: string?,
  hostname: string?,
  port: string?,
  path: string?,
  query: string?,
  fragment: string?,

  with_port: (self: URI, port: string?) -> URI,
  with_hostname: (self: URI, hostname: string?) -> URI,
  with_path: (self: URI, path: string?) -> URI,
  with_query:(self: URI, query: string?) -> URI,
  with_fragment: (self: URI, fragment: string?) -> URI,
  with_username: (self: URI, username: string?) -> URI,
  with_password: (self: URI, password: string?) -> URI,

  resolve: (self: URI, subpath: string) -> URI,

  userinfo: (self: URI) -> string?,
  authority: (self: URI) -> string?,
  host: (self: URI) -> string?,
  query_params: (self: URI) -> table,
  format: (self: URI) -> string,
  format_nested: (self: URI, schema: string) -> string,
  format_jdbc: (self: URI) -> string,
}

type table = {
  [any]: any
}

local URI = {
  schema = nil,
  username = nil,
  password = nil,
  hostname = nil,
  port = nil,
  path = nil,
  query = nil,
  fragment = nil,
}

URI.__index = URI

function URI:new(o: any): URI
  return Meta:type(o, self)
end

--- Parses a string into URI
function URI:parse(st: string): URI
  local schema: string? = nil
  local without_schema: string? = nil
  local authority = nil
  local without_authority = nil
  local userinfo = nil
  local username = nil
  local password = nil
  local host = nil
  local hostname = nil
  local port = nil
  local path = nil
  local without_path = nil
  local query = nil
  local without_query = nil
  local fragment = nil

  if st:sub(1,2) == '//' then
    without_schema = ':' .. st
  else
    schema, without_schema = st:match("([^:]*)(.*)")
  end
  if without_schema and #without_schema then
    if without_schema:sub(1, 3) == '://' then
      authority, without_authority = without_schema:match("://([^/]*)(.*)")
      if authority and #authority then
        if authority:find('@') then
          userinfo, host = authority:match("([^@]*)@(.*)")
        else
          host = authority
        end
        if userinfo and #userinfo then
          if userinfo:find(':') then
            username, password = userinfo:match("([^:]*):(.*)")
          else
            username = userinfo
          end
        end
        if host and #host then
          if host:find(':') then
            hostname, port = host:match("([^:]*):(.*)")
          else
            hostname = host
          end
        end
      end
      if without_authority and #without_authority then
        path, without_path = without_authority:match("([^?]*)(.*)")
      end
      if without_path and #without_path then
        query, without_query = without_path:match("?([^#]*)(.*)")
      end
      if without_query and #without_query then
        fragment = without_query:sub(1):match("#(.*)")
      end
    elseif without_schema:sub(1,1) == ':' then
      path = st:match(":(.*)")
    end
  end

  return URI:new({
    schema = schema,
    username = username,
    password = password,
    hostname = hostname,
    port = port,
    path = path,
    query = query,
    fragment = fragment,
  })
end

function URI:parse_nested(schema: string, st: string)
  if st:find(schema .. ':') == 1 then
    return URI:parse(st:sub(#schema + 2))
  end
  error(`Invalid prefix: '{schema}'`)
end

function URI:parse_jdbc(st: string): URI
  return URI:parse_nested('jdbc', st)
end

function URI.userinfo(self: URI): string?
  if self.username ~= nil and self.password ~= nil then
    return self.username .. ':' .. self.password
  elseif self.username ~= nil then
    return self.username
  end
  return nil
end

function URI.host(self: URI): string?
  if self.hostname ~= nil and self.port ~= nil then
    return self.hostname .. ':' .. self.port
  elseif self.hostname ~= nil then
    return self.hostname
  end
  return nil
end

function URI.authority(self: URI): string?
  local host = self:host()
  local userinfo = self:userinfo()
  if host ~= nil and userinfo ~= nil then
    return userinfo .. '@' .. host
  elseif host ~= nil then
    return host
  end
  return nil
end

function URI.query_params(self: URI): table
  local result: { [string]: any } = {}
  if self.query ~= nil then
    for item in self.query:gmatch("([^&]+)") do
      if item:find('=') then
        local name, value = item:match("([^=]*)=(.*)")
        result[name::string] = value
      else
        result[item] = true
      end
    end
  end
  return result
end

function URI.format(self: URI): string
  local st = ''
  if self.schema ~= nil then
    st ..= self.schema .. ':'
  end
  local authority = self:authority()
  if authority ~= nil then
    st ..= '//' .. authority
  end
  if self.path ~= nil then
    st ..= self.path
  end
  if self.query ~= nil then
    st ..= ('?' .. self.query)
  end
  if self.fragment ~= nil then
    st ..= ('#' .. self.fragment)
  end
  return st
end

function URI.format_nested(self: URI, schema: string): string
  return schema .. ':' .. self:format()
end

function URI.format_jdbc(self: URI): string
  return self:format_nested('jdbc')
end

function URI.with_schema(self: URI, schema: string)
  self.schema = schema
  return self
end

function URI.override_schema(self: URI, overrides: table): URI
  self.schema = overrides[self.schema] or self.schema
  return self
end

function URI.with_port(self: URI, port: string): URI
  self.port = port
  return self
end

function URI.with_hostname(self: URI, hostname: string): URI
  self.hostname = hostname
  return self
end

function URI.with_path(self: URI, path: string?): URI
  self.path = path
  return self
end

function URI.with_query(self: URI, query: string?): URI
  self.query = query
  return self
end

function URI.with_fragment(self: URI, fragment: string?): URI
  self.fragment = fragment
  return self
end

function URI.with_username(self: URI, username: string?): URI
  self.username = username
  return self
end

function URI.with_password(self: URI, password: string?): URI
  self.password = password
  return self
end

function URI.resolve(self: URI, subpath: string): URI
  if subpath == nil then
    return self:with_path(nil)
  end
  if subpath:find('^/') then
    return self:with_path(subpath)
  end
  if self.path == '' or self.path == nil then
    return self:with_path(subpath)
  end
  if self.path:find('/$') then
    return self:with_path(self.path .. subpath)
  end
  return self:with_path(self.path .. '/' .. subpath)
end

return URI
