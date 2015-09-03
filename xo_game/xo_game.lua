local function XO()
  local self = {
  }
  local height = disp:getHeight()
  local width = disp:getWidth()
  local ONE_CELL = height/4
  local LINE = ONE_CELL*3
  local DELAY_X = (width-LINE)/2
  local DELAY_Y = (height-LINE)/2
  local X = 1
  local O = 2
  local EMPTY = 0
  local idx = {1, 1}
  local cells = {0, 1, 0, 1, 0, 0, 0, 0, 2}

  local function set(x, y, t)
    local x_sel = DELAY_X+ONE_CELL*x
    local y_sel = DELAY_Y+ONE_CELL*y
    if t == EMPTY then
      return
    elseif t == X then
      x_sel = x_sel + 1
      y_sel = y_sel + 1
      disp:drawLine(x_sel, y_sel, x_sel+ONE_CELL-2, y_sel+ONE_CELL-2);
      disp:drawLine(x_sel, y_sel+ONE_CELL-2, x_sel+ONE_CELL-2, y_sel);
    elseif t == O then
      x_sel = x_sel + ONE_CELL/2
      y_sel = y_sel + ONE_CELL/2
      disp:drawCircle(x_sel, y_sel, (ONE_CELL-4)/2)
    end
  end

  function self.update(dt)
    -- check cursor bound
    if idx[1] > 2 then idx[1] = 0 end
    if idx[2] > 2 then idx[2] = 0 end
    if idx[1] < 0 then idx[1] = 2 end
    if idx[2] < 0 then idx[2] = 2 end
  end

  function self.draw()
    -- v lines
    disp:drawLine(DELAY_X+ONE_CELL, DELAY_Y, DELAY_X+ONE_CELL, DELAY_Y+LINE);
    disp:drawLine(DELAY_X+ONE_CELL*2, DELAY_Y, DELAY_X+ONE_CELL*2, DELAY_Y+LINE);
    -- h lines
    disp:drawLine(DELAY_X, DELAY_Y+ONE_CELL, DELAY_X+LINE, DELAY_Y+ONE_CELL);
    disp:drawLine(DELAY_X, DELAY_Y+ONE_CELL*2, DELAY_X+LINE, DELAY_Y+ONE_CELL*2);
    -- draw selector
    local x_sel = DELAY_X+ONE_CELL*idx[1] + 1
    local y_sel = DELAY_Y+ONE_CELL*idx[2] + 1
    disp:drawFrame(x_sel,y_sel,ONE_CELL-2,ONE_CELL-2);
    -- draw xo
    for x = 0, 2 do
      for y = 0, 2 do
        set(x, y, cells[x+y*3+1])
      end
    end
  end
  
  return self
end

return XO