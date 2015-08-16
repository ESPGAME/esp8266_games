obj = require("pong_objects")

local function Pong()
  local self = {
  }
  local BALL_R = 2
  local PAD_W = 2
  local PAD_H = 20
  local FPS = 25
  local TICKS = 1000/FPS
  local TEST_LOOPS = 50

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
  
  local loopcnt = 0
  local old = tmr.now()
  local now = 0
  local fps = 0

  function self.update()
    now = tmr.now()
    local dt = now - old
    --print(dt)
    if dt >= ONE_SEC_US then
      old = now
      first_player.score = fps
      fps = 0 
    end
    loopcnt = loopcnt + 1
    if loopcnt > TEST_LOOPS then
      pause_game()
    end
    ball.update(dt/ONE_SEC_US)
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
    --print('update:', tmr.now()-now) 
  end

  function self.draw(dt)
    first_player.draw()
    second_player.draw()
    -- ball
    ball.draw()
    -- score
    disp:setFont(u8g.font_6x10)
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

  function self.start_game()
    old = tmr.now()
    tmr.start(1)
    loopcnt = 0
  end

  function self.pause_game()
    tmr.stop(1)
  end
end

init_i2c_display()
init_game()

tmr.alarm(1, TICKS, 1, function() 
  update_game()
   
  --local now_draw = tmr.now()
  disp:firstPage()
  repeat
    draw_game()
  until disp:nextPage() == false
  --print("upd", tmr.now() - now_draw)
   
  tmr.wdclr()
  fps = fps +1
end )
