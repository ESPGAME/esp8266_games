local moduleName = ...
local M = {}
_G[moduleName] = M

function Class(...)  
  local cls  = {}
  local inst = { [cls] = true }

  for _, base in ipairs({...}) do
    inst[base] = true
    for k, v in pairs(base) do
      cls[k] = v
    end
  end

  cls.__index = cls
  cls.instance_of = inst

  setmetatable(cls, {
    __call = function(c, ...)
      local instance = setmetatable({}, c)
      if instance.__init then
        instance:__init(...)
      end
      return instance
    end
  })

  return cls
end  
  
local Vector2D = {}  
Vector2D = Class({  
  __init = function(self, x, y)
    self.x, self.y = x, y
  end,

  __tostring = function(self)
    return "Vector2D(" .. self.x .. ", " .. self.y .. ")"
  end,

  __add = function(self, other)
    return Vector2D(self.x + other.x, self.y + other.y)
  end,
  
  __sub = function(self, other)
    return Vector2D(self.x - other.x, self.y - other.y)
  end,  
  
  __mul = function(self, other)
    return Vector2D(self.x*other, self.y*other)
  end
})

M.Vector2D = Vector2D
return M