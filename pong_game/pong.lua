local function Pong()
  local self = {
  }
  local obj = dofile("pong_objects.lua")
  local BALL_R = 2
  local PAD_W = 2
  local PAD_H = 20

  local height = disp:getHeight()
  local width = disp:getWidth()
  db = {1, 0}
  x = 2
  y = height/2 - PAD_H/2
  local first_player = obj.Paddle(x, y, PAD_W, PAD_H)
  
  x = width - 2 - 2
  y = height/2 - PAD_H/2
  local second_player = obj.Paddle(x, y, PAD_W, PAD_H)
  
  x = width/2
  y = height/2
  local ball = obj.Ball(x, y, db, BALL_R)
  ball.speed = 4

  disp:setFont(u8g.font_6x10)
  
  function self.update(dt)
    ball.update(dt)
    if (ball.pos.y >  height-ball.r*2 or ball.pos.y - ball.r < 0) then
      ball.direction.y = - ball.direction.y
    end
    
    local vb = ball.direction*ball.speed

    if ball.direction.x > 0  then
      if second_player.pos.x <= ball.pos.x + ball.r*2 and
        second_player.pos.x > ball.pos.x - vb.x + ball.r*2 then
        local collision_diff = ball.pos.x + ball.r*2 - second_player.pos.x
        local k = collision_diff/vb.x
        local y = vb.x*k + (ball.pos.y - vb.y)
        if y >= second_player.pos.y and 
         y + ball.r*2 <= second_player.pos.y + second_player.size.y then
          ball.x = second_player.pos.x - ball.r*2
          ball.y = math.floor(ball.pos.y - vb.y + vb.y*k)
          ball.direction.x = - ball.direction.x
        end
      end 
    else
      if first_player.pos.x + first_player.size.x >= ball.pos.x then
        local collision_diff = first_player.pos.x + first_player.size.x - ball.pos.x
        local k = collision_diff/-vb.x
        local y = vb.y*k + (ball.pos.y - vb.y)
        if y >= first_player.pos.y and  
         y + ball.r*2 <= first_player.pos.y + second_player.size.y then
          ball.pos.x = first_player.pos.x + first_player.size.x
          ball.pos.y = math.floor(ball.pos.y - vb.y + vb.y*k)
          ball.direction.x = - ball.direction.x  
        end
      end
    end   
  end

  function self.draw()
    first_player.draw()
    second_player.draw()
    -- ball
    ball.draw()
    -- score
    disp:drawStr(width/2 - 10, height/8, tostring(first_player.score))
    disp:drawStr(width/2 + 10, height/8, tostring(second_player.score))
    -- frame
    disp:drawFrame(0,0,width,height);
    -- delay
    local dot
    for dot = 1, height, 16 do
      disp:drawLine(width/2, dot, width/2, dot+10);
    end
  end
  function self.unload()
    obj = nil
  end
  return self
end

return Pong
