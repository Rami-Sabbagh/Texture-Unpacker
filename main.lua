--TextureUnpacker By RamiLego4Game--
io.stdout:setvbuf("no")

local JSON = require("JSON")
local Font = {}

function love.load(arg)
  love.graphics.setBackgroundColor(250,250,250)
  Font[12] = love.graphics.newFont("NotoSans-Bold.ttf",12)
end

function love.draw()
  love.graphics.setColor(25,25,25,255)
  love.graphics.setFont(Font[12])
  love.graphics.printf(text,x,y,limit,align,r,sx,sy,ox,oy,kx,ky)
end

function love.update(dt)
  
end

function love.keypressed(key, unicode)
  
end
 
function love.keyreleased(key)
  
end