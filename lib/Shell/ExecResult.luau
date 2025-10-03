--!strict

local Meta = require('../Meta')
local Json = require('../Json')
local Yaml = require('../Yaml')

local ExecResult = {}

export type ExecResult = typeof(ExecResult) & ExecResultProps

export type ExecResultProps = {
  status: number?,
  stdout: string,
  stderr: string,
}

--- Creates an instance of Shell
--- @param o Shell properties
function ExecResult:new(o: ExecResultProps): ExecResult
  return Meta:type(o, self, 'Shell.ExecResult')
end

function ExecResult:parse_json_stdout<T>(): T
  local this = self::ExecResult
  return Json:parse(this.stdout)
end

function ExecResult:parse_yaml_stdout<T>(): T
  local this = self::ExecResult
  return Yaml:parse(this.stdout)
end

function ExecResult:parse_json_stderr<T>(): T
  local this = self::ExecResult
  return Json:parse(this.stderr)
end

function ExecResult:parse_yaml_stderr<T>(): T
  local this = self::ExecResult
  return Yaml:parse(this.stderr)
end

return ExecResult
