c = dofile("config.lua")
function init_i2c_display(sda, scl, sla)
     i2c.setup(0, sda, scl, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(sla)
     disp:setFont(u8g.font_6x10)
end
init_i2c_display(c.lcd.sda, c.lcd.scl, c.lcd.addr)
print('Init console ver:', c.ver)