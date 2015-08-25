print("--- Init game loop ---")
print(node.heap())

game_loop = require("game_loop")

function init_i2c_display()
  local sda = 5 -- GPIO14
  local scl = 6 -- GPIO12
  local sla = 0x3c
  i2c.setup(0, sda, scl, i2c.SLOW)
  disp = u8g.ssd1306_128x64_i2c(sla)
end

init_i2c_display()

game = game_loop(true)
game.load('pong.lua')
game.play()

print("--- Start game ---")
print(node.heap())

local loop = 0

for loop = 1, 20, 1 do
  game.update()
  game.draw()
end

game.pause()
game.unload()

print("--- Stop game & unload ---")
print(node.heap())
