print("--- Init game loop ---")
print(node.heap())

game_loop = require("game_loop")

game = game_loop(true)
game.load('xo_game.lua')
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
