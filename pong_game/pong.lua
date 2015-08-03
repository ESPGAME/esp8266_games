obj = require("pong_objects")
local BALL_R = 2
local PAD_W = 2
local PAD_H = 20
local ONE_SEC_US = 1000000

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
    first_player = obj.Paddle(PAD_W, PAD_H)
    first_player.x = 2
    first_player.y = height/2 - first_player.size[2]/2
    second_player = obj.Paddle(PAD_W, PAD_H)
    second_player.x = width - 2 - 2
    second_player.y = height/2 - second_player.size[2]/2

    ball = obj.Ball(BALL_R)
    ball.x = width/2
    ball.y = height/2
    ball.direction = {1, 1}
    loopcnt = 0
    old = tmr.now()
    now = 0
    fps = 0
end

function update_game()
    now = tmr.now()
    local dt = now - old
    --print(dt)
    if dt >= ONE_SEC_US then
        old = now
        first_player.score = fps
        fps = 0 
    end
    loopcnt = loopcnt + 1
    if loopcnt > 50 then
        tmr.stop(1)
    end
    ball.update(1)
    if (ball.x >  width-ball.r*2 or ball.x - ball.r < 0) then
        ball.direction[1] = - ball.direction[1]
    elseif (ball.y >  height-ball.r*2 or ball.y - ball.r < 0) then
        ball.direction[2] = - ball.direction[2]
    end
    --print('update:', tmr.now()-now)
end

function draw_game()
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

init_i2c_display()
init_game()

tmr.alarm(1, 5, 1, function() 
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
