local function XO()
  local self = {
  }
  local height = disp:getHeight()
  local width = disp:getWidth()
  local ONE_CELL = height/4
  local LINE = ONE_CELL*3
  local DELAY_X = (width-LINE)/2
  local DELAY_Y = (height-LINE)/2

  function self.update(dt)
  end
  
  function self.draw()
    -- v lines
    disp:drawLine(DELAY_X+ONE_CELL, DELAY_Y, DELAY_X+ONE_CELL, DELAY_Y+LINE);
    disp:drawLine(DELAY_X+ONE_CELL*2, DELAY_Y, DELAY_X+ONE_CELL*2, DELAY_Y+LINE);
    -- h lines
    disp:drawLine(DELAY_X, DELAY_Y+ONE_CELL, DELAY_X+LINE, DELAY_Y+ONE_CELL);
    disp:drawLine(DELAY_X, DELAY_Y+ONE_CELL*2, DELAY_X+LINE, DELAY_Y+ONE_CELL*2);
  end

  return self
end

return XO