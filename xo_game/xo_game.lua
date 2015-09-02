local function XO()
  local self = {
  }
  local height = disp:getHeight()
  local width = disp:getWidth()
  local ONE_CELL = height/4
  local LINE = ONE_CELL*3
  local DELAY_X = (width-LINE)/2
  local DELAY_Y = (height-LINE)/2
  local idx = {1, 1}

  local function set_x(x, y)
    local x_sel = DELAY_X+ONE_CELL*(x-1) + 1
    local y_sel = DELAY_Y+ONE_CELL*(y-1) + 1
    disp:drawLine(x_sel, y_sel, x_sel+ONE_CELL-2, y_sel+ONE_CELL-2);
    disp:drawLine(x_sel, y_sel+ONE_CELL-2, x_sel+ONE_CELL-2, y_sel);
  end

  local function set_o(x, y)
    local x_sel = DELAY_X+ONE_CELL*(x-1) + ONE_CELL/2
    local y_sel = DELAY_Y+ONE_CELL*(y-1) + ONE_CELL/2
    disp:drawCircle(x_sel, y_sel, (ONE_CELL-4)/2)
  end

  function self.update(dt)
    -- check cursor
    if idx[1] > 3 then idx[1] = 1 end
    if idx[2] > 3 then idx[2] = 1 end
    if idx[1] < 1 then idx[1] = 3 end
    if idx[2] < 1 then idx[2] = 3 end
  end

  function self.draw()
    -- v lines
    disp:drawLine(DELAY_X+ONE_CELL, DELAY_Y, DELAY_X+ONE_CELL, DELAY_Y+LINE);
    disp:drawLine(DELAY_X+ONE_CELL*2, DELAY_Y, DELAY_X+ONE_CELL*2, DELAY_Y+LINE);
    -- h lines
    disp:drawLine(DELAY_X, DELAY_Y+ONE_CELL, DELAY_X+LINE, DELAY_Y+ONE_CELL);
    disp:drawLine(DELAY_X, DELAY_Y+ONE_CELL*2, DELAY_X+LINE, DELAY_Y+ONE_CELL*2);
    -- test selector
    local x_sel = DELAY_X*idx[1] + 1
    local y_sel = DELAY_Y*idx[2] + 1
    disp:drawFrame(x_sel,y_sel,ONE_CELL-2,ONE_CELL-2);
    -- test xo
    set_o(1, 1)
    set_o(2, 3)
    set_x(2, 1)
    set_x(2, 2)
    set_o(1, 2)
    set_x(3, 3)
    set_x(3, 1)
    set_o(3, 2)
    set_o(1, 3)
  end

  return self
end

return XO