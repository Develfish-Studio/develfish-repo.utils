local Meta = require("./Meta")
local Array = require('./Array')

export type Path = {
  --- An array of path entries
  entries: { [number]: { type: number, value: string } },

  --- Normalize path
  normalize: (self: Path) -> Path,
  --- Join another path
  join_path: (self: Path, other: Path) -> Path,
  --- Join string segment
  join_string: (self: Path, st: string) -> Path,
  --- Get an array of segments
  path_array: (self: Path) -> {[number]: string},
  --- Format path to string
  to_string: (self: Path) -> string,
  --- Get a sequence of segments
  path: (self: Path) -> ...string,
}

type table = {
  [any]: any
}

local Path = {
  entries = {},
}

Path.__index = Path

local TYPE_SEPARATOR = 0;
local TYPE_SEGMENT = 1;
local TYPE_CURRENT = 2;
local TYPE_PARENT = 3;

function Path:new(o: any): Path
  return Meta:type(o, self)
end

function Path:from_segments(segments: {[number]: string}): Path
  local entries = {}
  for i, segment in segments do
    if i > 1 then
      entries[#entries + 1] = { type = TYPE_SEPARATOR, value = '/' }
    end
    entries[#entries + 1] = { type = TYPE_SEGMENT, value = segment }
  end
  return Path:new({ entries = entries })
end

function Path:from_string(st: string): Path
  local entries = {}
  for separator, segment in st:gmatch("([/]*)([^/]*)") do
    if separator ~= '' then
      entries[#entries + 1] = { type = TYPE_SEPARATOR, value = '/' }
    end
    if segment ~= '' then
      if segment == '.' then
        entries[#entries + 1] = { type = TYPE_CURRENT, value = '.' }
      elseif segment == '..' then
        entries[#entries + 1] = { type = TYPE_PARENT, value = '..' }
      else
        entries[#entries + 1] = { type = TYPE_SEGMENT, value = `{segment}` }
      end
    end
  end
  return Path:new({ entries = entries })
end

function Path:parse(st: string): Path
  return Path:from_string(st)
end

function Path.join_path(self: Path, other: Path): Path
  local entries = nil
  if #self.entries > 0 and #other.entries > 0 and self.entries[#self.entries].type ~= TYPE_SEPARATOR and other.entries[1].type ~= TYPE_SEPARATOR then
    entries = Array:concat(Array:concat(self.entries, {{ type = TYPE_SEPARATOR, value = '/' }}), other.entries)
  else
    entries = Array:concat(self.entries, other.entries)
  end
  return Path:new({ entries = entries })
end

function Path.join_string(self: Path, st: string): Path
  local other = Path:from_string(st)
  return self:join_path(other)
end

function Path.path_array(self: Path): {[number]: string}
  local array = {}
  for item in self:to_string():gmatch("([^/]+)") do
    array[#array + 1] = item
  end
  return array
end

function Path.path(self: Path)
  return table.unpack(self:path_array())
end

function Path.to_string(self: Path): string
  local st = ''
  for _, entry in self.entries do
    st ..= entry.value
  end
  return st
end

function Path.normalize(self: Path): Path
  local entries = {}
  local is_absolute = if #self.entries > 0 and self.entries[1].type == TYPE_SEPARATOR then true else false
  for i, entry in self.entries do
    if entry.type == TYPE_CURRENT then
      -- do nothing
    elseif entry.type == TYPE_PARENT then
      if #entries > 1 and entries[#entries].type == TYPE_SEPARATOR and entries[#entries - 1].type == TYPE_SEGMENT then
        table.remove(entries, #entries) -- remove separator
        table.remove(entries, #entries) -- remove segment
      elseif #entries == 1 and entries[#entries].type == TYPE_SEPARATOR then
        table.remove(entries, #entries) -- remove separator
        entries[#entries + 1] = entry
      else
        entries[#entries + 1] = entry
      end
    elseif entry.type == TYPE_SEGMENT then
      entries[#entries + 1] = entry
    elseif entry.type == TYPE_SEPARATOR then
      if #entries > 0 and entries[#entries].type ~= TYPE_SEPARATOR then
        entries[#entries + 1] = entry
      elseif #entries == 0 and is_absolute then
        entries[#entries + 1] = entry
      else
        -- do nothing
      end
    end
  end
  if #entries > 1 and entries[#entries].type == TYPE_SEPARATOR then
    table.remove(entries, #entries) -- remove trailing separator
  end
  return Path:new({ entries = entries })
end

return Path
