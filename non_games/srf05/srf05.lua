-- Library for communication with HC-SRF05 (Ultra-Sonic Ranger)
local function SRF05(t, e, c)
  local self = {}

  local NO_OBJECT = 30000
  local MIN_LENGTH = 100
  local MAX_LENGTH = 25000

  local callback = c
  local trig = t
  local div = 0
  local start = 0

  function self.getRange(t)
    gpio.mode(trig, gpio.OUTPUT)
    gpio.mode(e, gpio.INT)
    gpio.trig(e, "both", self.interrupt)
    if t == 1 then 
      div = 148 -- inches
    else 
      div = 59 -- cm
    end
    gpio.write(trig, gpio.HIGH) -- UP
    tmr.delay(10)
    gpio.write(trig, gpio.LOW) -- DOWN
  end

  function self.interrupt(l)
    out = 0
    if l == 1 then 
      start = tmr.now()
    else 
      dt = tmr.now() - start
      if dt >= NO_OBJECT then
        out = -1  -- no answer
      elseif  dt > MAX_LENGTH then
        out = MAX_LENGTH/div
      elseif  dt < MIN_LENGTH then
        out = MIN_LENGTH/div
      else
        out = dt/div
      end
      callback(out, dt)
    end
  end
  return self
end
return SRF05
