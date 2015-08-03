-- from http://loadingdata.nl/lua-classes/
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


Paddle = {}  
Paddle = Class({  
  __init = function(self, x, y)
    self.x, self.y = x, y
    self.width, self.height = 2, 20
    self.score = 0
  end,
  
  draw = function(self)
    disp:drawBox(self.x, self.y, self.width, self.height)
  end,

  -- etc
})

Ball = {}  
Ball = Class({  
  __init = function(self, x, y)
    self.x, self.y = x, y
    self.vx, self.vy = 2, 2
    self.r = 2
  end,
  update = function(self)
    self.x = self.x + self.vx
    self.y = self.y + self.vy
    -- print(self.x, self.y)
  end, 
  
  draw = function(self)
    disp:drawDisc(self.x, self.y, self.r)
    --disp:drawPixel(self.x, self.y)
  end,

  -- etc
})

function init_i2c_display()
     -- SDA and SCL can be assigned freely to available GPIOs
     local sda = 5 -- GPIO14
     local scl = 6 -- GPIO12
     local sla = 0x3c
     i2c.setup(0, sda, scl, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(sla)
end

function init_game()
    height = disp:getHeight()
    width = disp:getWidth()
    first_player = Paddle(2, 0)
    first_player.y = height/2 - first_player.height/2
    second_player = Paddle(width - 2 - 2, 0)
    second_player.y = height/2 - first_player.height/2

    ball = Ball(width/2, height/2)

    loopcnt = 0
    old = tmr.time()
    now = 0
    fps = 0
end

function update_game()
   now = tmr.time()
   if now - old >= 1 then
    --print(old)
    old = now
    first_player.score = fps
    fps = 0 
   end
   loopcnt = loopcnt + 1
   if loopcnt > 50 then
    tmr.stop(1)
   end
    ball.update(ball)
    if (ball.x >  width-ball.r*2 or ball.x - ball.r < 0) then
        ball.vx = - ball.vx
    elseif (ball.y >  height-ball.r*2 or ball.y - ball.r < 0) then
        ball.vy = - ball.vy
    end
end

function draw_game()
    first_player.draw(first_player)
    second_player.draw(second_player)
    -- ball
    ball.draw(ball)
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

function game_loop()
    local loopcnt
    fps = 0
    for loopcnt = 1, 200, 1 do
        disp:firstPage()
        update_game()
        repeat
            draw_game()
        until disp:nextPage() == false
        tmr.delay(20)
        fps = fps +1
        tmr.wdclr()
    end
end

init_i2c_display()
init_game()
--game_loop()

tmr.alarm(1, 500, 1, function() 
   update_game()
   disp:firstPage()
   repeat
    draw_game()
   until disp:nextPage() == false
   --if disp:nextPage() then draw_game() end
   
   tmr.wdclr()
   fps = fps +1
end )
