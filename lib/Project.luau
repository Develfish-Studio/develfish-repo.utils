local Meta = require('./Meta')

export type Project = {
  __type: 'Project',
  name: string?,

  unwrap_project: (self: Project) -> UnwrappedProject,
  unwrap: (self: Project) -> { project: UnwrappedProject },
}

export type UnwrappedProject = {
  name: string?,
}

export type Unwrapped = {
  project: UnwrappedProject,
}

local Project = {
  __type = 'Project',

  name = nil,
}

Project.__index = Project

function Project:new(o: any): Project
  return Meta:type(o, self)
end

function Project:from(name: string): Project
  return Project:new({
    name = name,
  })
end

function Project.unwrap_project(self: Project): UnwrappedProject
  return {
    name = self.name
  }
end

function Project.unwrap(self: Project): { project: UnwrappedProject }
  return {
    project = self:unwrap_project(),
  }
end

return Project
