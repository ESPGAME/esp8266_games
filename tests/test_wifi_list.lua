wifi.setmode(wifi.STATION)
local ap_list = {}
local ap_list_length = 0
function listap(t) -- (SSID : Authmode, RSSI, BSSID, Channel)
  ap_list = {}
  --print("\n\t\t\tSSID\t\t\t\t\tBSSID\t\t\t  RSSI\t\tAUTHMODE\t\tCHANNEL")
  for bssid,v in pairs(t) do
    local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]+)")
    ap_list[ssid] = { ["rssi"] = tonumber(rssi), ["authmode"] = tonumber(authmode), ["channel"] = tonumber(channel)}
    --ap_list[ssid] = v
  end
  ap_list_length = tablelength(ap_list)
  update()
end

disp:firstPage()
repeat
  disp:drawStr(disp:getWidth()/2-6*5, disp:getHeight()/2, "Searching")
until disp:nextPage() == false

wifi.sta.getap(1, listap)

local wifi_type = {"Open", "WPA", "WPA2", "W2WA"}

local point = 0
local x_sel = 0

function draw()
  local x_pos = 10
  local y_pos = 10
  local i = 0
  disp:drawStr(2, 23, ">") 
  disp:drawStr(x_pos, y_pos, "SSID     Type  Pwr")
  for key,value in pairs(ap_list) do
    if x_sel < 0 then x_sel = ap_list_length-1; i = ap_list_length-1 end
    if ap_list_length <= x_sel then x_sel = 0; i = 0 end
    if i >= x_sel then
      y_pos = y_pos + 13
      local name = key
      if string.len(key) >= 8 then name = string.sub(key, 0, 6) .. '..' end

      disp:drawStr(x_pos, y_pos, name)
      disp:drawStr(x_pos+6*9, y_pos, wifi_type[value.authmode])
      disp:drawStr(x_pos+6*15, y_pos, tostring(value.rssi))
    end
    i = i + 1
    if y_pos > disp:getHeight() + disp:getHeight()/8 then break end
  end
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function update()
  disp:firstPage()
  repeat
    draw()
  until disp:nextPage() == false
end

gpio.mode(2, gpio.INT, gpio.PULLUP)
gpio.mode(4, gpio.INT, gpio.PULLUP)

function pin1cb(level)
  x_sel = x_sel + 1
  update()
end
function pin2cb(level)
  x_sel = x_sel - 1
  update()
end
gpio.trig(4, "down", pin2cb)
gpio.trig(2, "down", pin1cb)