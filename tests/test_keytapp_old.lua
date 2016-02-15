function init_i2c_display()
     -- SDA and SCL can be assigned freely to available GPIOs
     local sda = 5 -- GPIO14
     local scl = 6 -- GPIO12
     local sla = 0x3c
     i2c.setup(0, sda, scl, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(sla)
end

init_i2c_display()
disp:setFont(u8g.font_6x10)

--alp_list = "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890. -"
--for i = 1, string.len(str) do
--    print( string.sub(str, i, i) )
--end
x_sel = 0
y_sel = 0

uart.on("data", 4, 
  function(data)
    print(data)
    if data=="qqqq" then 
      uart.on("data") 
    end
    if data=="aaaa" then 
      x_sel = x_sel - 1
    end 
    if data=="dddd" then 
      x_sel = x_sel + 1
    end
    if data=="wwww" then 
      y_sel = y_sel - 1
    end   
    if data=="ssss" then 
      y_sel = y_sel + 1
    end
    if x_sel < 0 then
        x_sel = 0
    end
    if x_sel > 20 then
        x_sel = 20
    end
    if y_sel < 0 then
        y_sel = 0
    end
    if y_sel > 5 then
        y_sel = 5
    end
    update()
  end, 
0)

function draw()
  disp:drawStr(disp:getWidth()/4, 12, "___________")
  --disp:drawStr( 0+2, 20+16, "Hello!")
  disp:drawFrame(0, 0, disp:getWidth(), disp:getHeight()/8*2)
  disp:drawFrame(0, disp:getHeight()/8*2, disp:getWidth(), disp:getHeight()/8*6)
  local y,x = 0,0
  for i = 42, 122, 1 do
    x_pos = 4+(i-42)*6-y*20*6
    y_pos = disp:getHeight()/8*2+9+y*10
    disp:drawStr(x_pos, y_pos, string.char(i))
    x = x + 1
    if x>=20 then  y = y + 1; x = 0 end
  end
  disp:drawFrame(4-1+x_sel*6, disp:getHeight()/8*2+2-1+y_sel*10, 8, 10)
end

function update()
  disp:firstPage()
  repeat
    draw()
  until disp:nextPage() == false
end

update()

gpio.mode(0, gpio.INT)

function pin1cb(level)
  print('up')
  y_sel = y_sel + 1
  update()
end
gpio.trig(1, "up", pin1cb)
