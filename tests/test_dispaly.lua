local obj = dofile("display.lua")

draw = obj.Disp(0, 5, 6)

draw.init()
draw.clean()

function test(f, arg)
  print('--start--')
  old = tmr.now()
  f(arg)
  calc = (tmr.now() - old)/1000000
  print('--stop--')
  print('time:'..calc)
end

--for loop = 1, 4, 1 do
--  draw.invert(true)
--  tmr.delay(500000)
--  tmr.wdclr()
--  draw.invert()
--  tmr.delay(500000)
--  tmr.wdclr()
--end