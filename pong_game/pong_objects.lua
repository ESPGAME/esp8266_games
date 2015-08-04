local moduleName = ...
local M = {}
_G[moduleName] = M

local function Moveable()
  local self = {
    x = 0,
    y = 0,
    speed = 2,
    direction = {0, 0}
  }
  function self.update()
  end
  function self.draw()
  end
  return self
end

local function Paddle(w, h)
  local self = Moveable()
  self.size = {w, h}
  self.score = 0

  function self.draw()
    disp:drawBox(self.x, self.y, self.size[1], self.size[2])
  end
  
  return self
end

local function Ball(r)
  local self = Moveable()
  self.r = r
  function self.update(dt)
    self.x = self.x + self.speed*self.direction[1]*dt
    self.y = self.y + self.speed*self.direction[2]*dt
  end
  function self.draw()
    disp:drawDisc(self.x, self.y, self.r)
  end
  return self
end

M.Paddle = Paddle
M.Ball = Ball
return M
