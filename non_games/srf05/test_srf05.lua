srf05 = require("srf05")

trig = 5 -- GPIO14
echo = 6 -- GPIO12
lock = 0
start = tmr.now()
range = srf05(trig, echo, function(l, d) print('range:'..l..', dt:'..d) lock = 0 end)

tmr.alarm(1, 2000, 1, function() 
  if lock == 0 then
    if pcall(range.getRange) then
      print("getRange OK")
    else
      print("getRange err" )
    end 
    lock = 1
    start = tmr.now()
  end
  if tmr.now() - start > 3000000 then lock = 0 end
  tmr.wdclr()
end)
