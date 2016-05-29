--TextureUnpacker By RamiLego4Game--
io.stdout:setvbuf("no")

local JSON = require("JSON")
local _Width, _Height = love.graphics.getDimensions()
local _Font, _Images, _Info, _Status, _Errmsg = {}, {}, "Please drop the sheet files into this window", "Waiting for sheet files...", ""
local StartJob, tArr = false, nil

function love.load(arg)
  love.graphics.setBackgroundColor(255,255,255)
  _Font[12] = love.graphics.newFont("NotoSans-Regular.ttf",12)
end

function love.draw()
  love.graphics.setFont(_Font[12])
  
  love.graphics.setColor(100,100,100,255)
  love.graphics.printf(_Info.."\n".._Status,_Width/8,_Height/4,(_Width/8)*6,"center")
  
  love.graphics.setColor(200,0,0,255)
  love.graphics.printf(_Errmsg,_Width/8,_Height/2,(_Width/8)*6,"center")
  
  love.graphics.setColor(150,150,150,255)
  love.graphics.printf("This tool has been made by RamiLego4Game for MoveOrDie.",(_Height/16),_Height-(_Height/8),_Width-(_Height/8),"left")
end

local function splitFilePath(path)
  return path:match("(.-)([^\\/]-%.?([^%.\\/]*))$") --("^.+/(.+)$")
end

local function startJob()
  _Info = "Target Sheet: "..tArr.meta.image:sub(0,-5)
  
end

function love.filedropped(file)
  local filePath, fileName, fileExtension = splitFilePath(file:getFilename())
  print(fileName.." ("..fileExtension..") has been dropped into the tool.")
  if fileExtension == "png" or fileExtension == "jpg" then
    assert(file:open("r")) local fileContent = file:read() file:close()
    local Filedata, err = love.filesystem.newFileData(fileContent,fileName) if err then error(err) end
    _Images[fileName] = love.graphics.newImage(Filedata)
    _Status = "Loaded "..fileName..", Waiting for JSON file..."
  elseif fileExtension == "json" then
    assert(file:open("r")) local jData = file:read() file:close()
    local jArr = JSON:decode(jData)
    if _Images[jArr.meta.image] then
      tArr = jArr
      startJob()
    else
      _Info = "Loaded Sheet JSON: "..fileName
      _Status = "Waiting for Sheet Image: "..jArr.meta.image
      tArr = jArr
    end
  end
end

function love.update(dt)
  
end

function love.keypressed(key, unicode)
  
end
 
function love.keyreleased(key)
  
end