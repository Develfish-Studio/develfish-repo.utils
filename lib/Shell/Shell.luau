--!strict

local Meta = require('../Meta')
local ExecResult = require('./ExecResult')

local Shell = {
  ExecResult = ExecResult,
}

export type Shell = typeof(Shell)

export type ShellProps = {
  cwd: string,
  trace: boolean?
}

export type ShellImpl = Shell & ShellProps

--- Creates an instance of Shell
--- @param o Shell properties
function Shell:new(o: ShellProps): Shell
  return Meta:type(o, self, 'Shell')
end

--- Creates default instance of Shell
function Shell:default(): Shell
  return Shell:new({
    cwd = '.'
  })
end

function Shell:with_trace(trace: boolean?): Shell
  local this = self::ShellImpl
  this.trace = trace == nil or trace == true
  return this
end

--- Execute shell command
--- @param command Shell command to execute
function Shell:exec(command: string): ExecResult.ExecResult
  local this = self::ShellImpl
  if this.trace == true then
    print(`[TRACE] Exec`)
    print(command)
  end
  local result = shell:exec(this.cwd, command)
  return ExecResult:new({
    status = result.status,
    stdout = result.stdout,
    stderr = result.stderr,
  })
end

function Shell:clean_sh(st: string): string
  st = string.gsub(st, '([\"])', '\\"')
  st = string.gsub(st, '([\`])', '\\`')
  return st
end

return Shell
