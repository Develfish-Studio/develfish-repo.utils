--!strict

local Json = {}

function Json:stringify(obj): string
  return json:stringify(obj)
end

function Json:parse<T>(st: string): T
  return json:parse(st)
end

return Json