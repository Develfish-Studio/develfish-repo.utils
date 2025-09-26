--!strict

local Meta = require("./Meta")

local URI = {}

export type URI = typeof(URI) & URIProps

export type URIProps = {
  schema: string,
  username: string?,
  password: string?,
  hostname: string?,
  port: string?,
  path: string?,
  query: string?,
  fragment: string?,
}

function URI:new(o: any): URI
  return Meta:type(o, self, "URI")
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

function URI:parse_nested(schema: string, st: string): URI
  if st:find(schema .. ':') == 1 then
    return URI:parse(st:sub(#schema + 2))
  end
  error(`Invalid prefix: '{schema}'`)
end

function URI:parse_jdbc(st: string): URI
  return URI:parse_nested('jdbc', st)
end

function URI:userinfo(): string?
  local this = self::URI
  if this.username ~= nil and this.password ~= nil then
    return this.username .. ':' .. this.password
  elseif this.username ~= nil then
    return this.username
  end
  return nil
end

function URI:host(): string?
  local this = self::URI
  if this.hostname ~= nil and this.port ~= nil then
    return this.hostname .. ':' .. this.port
  elseif this.hostname ~= nil then
    return this.hostname
  end
  return nil
end

function URI:authority(): string?
  local this = self::URI
  local host = this:host()
  local userinfo = this:userinfo()
  if host ~= nil and userinfo ~= nil then
    return userinfo .. '@' .. host
  elseif host ~= nil then
    return host
  end
  return nil
end

function URI:query_params(): {[string]: any}
  local this = self::URI
  local result: { [string]: any } = {}
  if this.query ~= nil then
    for item in this.query:gmatch("([^&]+)") do
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

function URI:format(): string
  local this = self::URI
  local st = ''
  if this.schema ~= nil then
    st ..= this.schema .. ':'
  end
  local authority = this:authority()
  if authority ~= nil then
    st ..= '//' .. authority
  end
  if this.path ~= nil then
    st ..= this.path
  end
  if this.query ~= nil then
    st ..= ('?' .. this.query)
  end
  if this.fragment ~= nil then
    st ..= ('#' .. this.fragment)
  end
  return st
end

function URI:format_nested(schema: string): string
  local this = self::URI
  return schema .. ':' .. this:format()
end

function URI:format_jdbc(): string
  local this = self::URI
  return this:format_nested('jdbc')
end

function URI:with_schema(schema: string)
  local this = self::URI
  this.schema = schema
  return this
end

function URI:override_schema(overrides: {[string]: string}): URI
  local this = self::URI
  this.schema = overrides[this.schema] or this.schema
  return this
end

function URI:with_port(port: string): URI
  local this = self::URI
  this.port = port
  return this
end

function URI:with_hostname(hostname: string): URI
  local this = self::URI
  this.hostname = hostname
  return this
end

function URI:with_path(path: string?): URI
  local this = self::URI
  this.path = path
  return this
end

function URI:with_query(query: string?): URI
  local this = self::URI
  this.query = query
  return this
end

function URI:with_fragment(fragment: string?): URI
  local this = self::URI
  this.fragment = fragment
  return this
end

function URI:with_username(username: string?): URI
  local this = self::URI
  this.username = username
  return this
end

function URI:with_password(password: string?): URI
  local this = self::URI
  this.password = password
  return this
end

function URI:resolve(subpath: string): URI
  local this = self::URI
  if subpath == nil then
    return this:with_path(nil)
  end
  if subpath:find('^/') then
    return this:with_path(subpath)
  end
  if this.path == '' or this.path == nil then
    return this:with_path(subpath)
  end
  if this.path:find('/$') then
    return this:with_path(this.path .. subpath)
  end
  return this:with_path(this.path .. '/' .. subpath)
end

return URI
