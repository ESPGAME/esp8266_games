local M = {}

local function Disp(i, sd, sc)
  local self = {
  }
  local SSD1306_DEFAULT_ADDRESS = 0x3C
  local SSD1306_SETCONTRAST = 0x81
  local SSD1306_DISPLAYALLON_RESUME = 0xA4
  local SSD1306_DISPLAYALLON = 0xA5
  local SSD1306_NORMALDISPLAY = 0xA6
  local SSD1306_INVERTDISPLAY = 0xA7
  local SSD1306_DISPLAYOFF = 0xAE
  local SSD1306_DISPLAYON = 0xAF
  local SSD1306_SETDISPLAYOFFSET = 0xD3
  local SSD1306_SETCOMPINS = 0xDA
  local SSD1306_SETVCOMDETECT = 0xDB
  local SSD1306_SETDISPLAYCLOCKDIV = 0xD5
  local SSD1306_SETPRECHARGE = 0xD9
  local SSD1306_SETMULTIPLEX = 0xA8
  local SSD1306_SETLOWCOLUMN = 0x00
  local SSD1306_SETHIGHCOLUMN = 0x10
  local SSD1306_SETSTARTLINE = 0x40
  local SSD1306_MEMORYMODE = 0x20
  local SSD1306_COLUMNADDR = 0x21
  local SSD1306_PAGEADDR =  0x22
  local SSD1306_COMSCANINC = 0xC0
  local SSD1306_COMSCANDEC = 0xC8
  local SSD1306_SEGREMAP = 0xA0
  local SSD1306_CHARGEPUMP = 0x8D
  local SSD1306_SWITCHCAPVCC = 0x2
  local SSD1306_NOP = 0xE3

  local id = i
  local sda = sd
  local scl = sc

  i2c.setup(id,sda,scl,i2c.SLOW)
  i2c.address(id, SSD1306_DEFAULT_ADDRESS, i2c.TRANSMITTER)

  local function sendData(...)
    i2c.start(id)
    i2c.address(id, SSD1306_DEFAULT_ADDRESS, i2c.TRANSMITTER)
    i2c.write(id, 0x40, arg)
    i2c.stop(id)
  end

  local function sendCommand(...)
    i2c.start(id)
    i2c.address(id, SSD1306_DEFAULT_ADDRESS, i2c.TRANSMITTER)
    i2c.write(id, 0x00, arg)
    i2c.stop(id)
  end

  function self.init()
    -- Turn display off
    sendCommand(SSD1306_DISPLAYOFF)
    sendCommand(SSD1306_SETDISPLAYCLOCKDIV)
    sendCommand(0x80)
    sendCommand(SSD1306_SETMULTIPLEX)
    sendCommand(0x3F)
    sendCommand(SSD1306_SETDISPLAYOFFSET)
    sendCommand(0x00)
    sendCommand(SSD1306_SETSTARTLINE)
    -- We use internal charge pump
    sendCommand(SSD1306_CHARGEPUMP)
    sendCommand(0x14)
    -- Horizontal memory mode
    sendCommand(SSD1306_MEMORYMODE)
    sendCommand(0x00)
    sendCommand(0xA1) -- edit
    sendCommand(SSD1306_COMSCANDEC)
    sendCommand(SSD1306_SETCOMPINS)
    sendCommand(0x12)
    -- Max contrast
    sendCommand(SSD1306_SETCONTRAST)
    sendCommand(0xCF)
    sendCommand(SSD1306_SETPRECHARGE)
    sendCommand(0xF1)
    sendCommand(SSD1306_SETVCOMDETECT)
    sendCommand(0x40)
    sendCommand(SSD1306_DISPLAYALLON_RESUME)
    -- Non-inverted display
    sendCommand(SSD1306_NORMALDISPLAY)
    -- Turn display back on
    sendCommand(SSD1306_DISPLAYON)
  end

  function self.invert(i)
    local c = SSD1306_NORMALDISPLAY
    if i then c = SSD1306_INVERTDISPLAY end
    sendCommand(c)
  end

  function self.cmd(c)
    sendCommand(c)
  end
  function self.dat(d)
    sendData(d)
  end

  function self.draw()
    sendCommand(SSD1306_COLUMNADDR)
    sendCommand(0x00)
    sendCommand(0x7F)

    sendCommand(SSD1306_PAGEADDR)
    sendCommand(0x00)
    sendCommand(0x07)

    p, b = 0, 0
    for p = 0, 64, 1 do
      --i2c.start(id)
      --i2c.address(id, SSD1306_DEFAULT_ADDRESS, i2c.TRANSMITTER)
      --i2c.write(id, 0x40)
      --for b = 0, 16, 1 do
      --  i2c.write(id, 0x00)
      --end
      --i2c.stop(id)
      sendData(0,0,0,0,0,0,0,0xFF,0,0,0,0,0,0,0,0xF)
    end
  end

  function self.clean(p)
    p = p or 0x00
    sendCommand(SSD1306_COLUMNADDR, 0x00, 0x7F)
    sendCommand(SSD1306_PAGEADDR, p, 0x07)
    c = 63
    if p > 0 then 
      c = 7 
    end
    i = 0
    for i = 0, c, 1 do
      sendData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
    end
  end

  function self.test()
    for k=0,7 do
      sendCommand(0x00, 0x10, 0xb0 + k)
      sendData(0xff)
      sendCommand(0x0f, 0x17, 0xb0 +k)
      sendData(0xff)
      sendCommand(0x0f, 0x13, 0xb0 +k)
      sendData(0x99)
    end
  end

  function self.test1(k, i, b)
    sendCommand(i%16, 0x10+math.floor(i/16), 0xb0 + k)
    --for k=0,7 do
    sendData(b, b, b, b, b, b, b, b)
    --end
  end
  return self
end

M.Disp = Disp
return M