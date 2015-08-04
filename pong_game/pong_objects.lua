local moduleName = ...
local M = {}
_G[moduleName] = M

gm = require("game_math")

local function Moveable(x, y)
  local self = {
    pos = gm.Vector2D(x, y),
    speed = 2,
    direction = gm.Vector2D(0, 0)
  }
  function self.update()
  end
  function self.draw()
  end
  return self
end

local function Paddle(x, y, w, h)
  local self = Moveable(x, y)
  self.size = gm.Vector2D(w, h)
  self.score = 0

  function self.draw()
    disp:drawBox(self.pos.x, self.pos.y, self.size.x, self.size.y)
  end
  
  return self
end

local function Ball(x, y, d, r)
  local self = Moveable(x, y)
  self.r = r
  self.direction = gm.Vector2D(d[1], d[2])
  function self.update(dt)
    self.pos = self.pos + self.direction*self.speed*dt
  end
  function self.draw()
    disp:drawDisc(math.floor(self.pos.x), math.floor(self.pos.y), self.r)
  end
  return self
end

M.Paddle = Paddle
M.Ball = Ball
return M
