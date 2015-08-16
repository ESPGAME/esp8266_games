local function Game_Loop()
  local self = {
  }
  local ONE_SEC_US = 1000000
  local FPS = 25
  local TICKS = 1000/FPS

  local play = false

  local loopcnt = 0
  local old = 0
  local old_dt = 0
  local fps = 0
  local fps_count = 0
  local d = 0

  function self.play()
    play = true
    old = tmr.now()
    old_dt = old
  end

  function self.pause()
    play = false
    old = 0
    old_dt = 0
  end

  function self.load(game)
    self.game = require(game)
    self.play()
  end

  function self.unload()
    self.game = nil
    self.pause()
  end

  function self.update()
    if play then:
      now = tmr.now()
      dt = now - old_dt
      old_dt = now
      if now - old >= ONE_SEC_US then
        old = now
        fps_count = fps
        fps = 0
      end
      self.game.update(dt)
    end
  end

  function self.draw()
    if play then:
      disp:firstPage()
      repeat
        self.game.draw()
      until disp:nextPage() == false
      tmr.wdclr()
      fps = fps + 1
    end
  end
  return self
end

return Game_Loop