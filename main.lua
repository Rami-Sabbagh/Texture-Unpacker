--SSHWorld By RamiLego4Game--
--Imports--
require "loveframes"
JSON = (loadfile "JSON.lua")()
  
--Classess Importes--
require "class"

function love.load(arg)
  saveDir = love.filesystem.getSaveDirectory().."/"
  workingDir = love.filesystem.getWorkingDirectory( ).."/"
  filePath = "Unpack.json"
  love.graphics.setBackgroundColor(250,250,250)
  
  _Timer = 0
  _Wait = 0.50
  unpacks = {}
  currentPack = 0
  
  fr = {}
  
  fr.exit = loveframes.Create("button")
  fr.exit:SetText("Cancel & Quit"):SetWidth(100):SetPos(5,love.graphics.getHeight()-fr.exit:GetHeight()-5)
  fr.exit.OnClick = function(object)
    love.event.quit()
  end
  
  fr.start = loveframes.Create("button")
  fr.start:SetText("Unpack Files"):SetWidth(100):SetPos(love.graphics.getWidth()-fr.start:GetWidth()-5,love.graphics.getHeight()-fr.start:GetHeight()-5)
  fr.start.OnClick = function(object)
    nextPack()
    object:SetClickable(false)
    fr.exit:SetText("Stop & Quit")
  end
  
  fr.current = loveframes.Create("progressbar")
  fr.current:SetWidth(love.graphics.getWidth()-10):SetPos(5,love.graphics.getHeight()-fr.exit:GetHeight()-fr.current:GetHeight()-10)
  fr.current.OnComplete = function(object)
    fr.exit:SetText("Quit")
    doneFrame()
  end
  
  fr.list = loveframes.Create("columnlist")
  fr.list:SetSize(love.graphics.getWidth()-10,love.graphics.getHeight()-fr.exit:GetHeight()-fr.current:GetHeight()-20)
  fr.list:SetPos(5,5):SetSelectionEnabled(false):AddColumn("Name"):AddColumn("Position"):AddColumn("Size")
  
  fr.author = loveframes.Create("text")
  fr.author:SetPos(110,love.graphics.getHeight()-fr.exit:GetHeight()):SetText("By: RamiLego4Game, Made For: Concerned Joe.")
  
  fr.wait = loveframes.Create("numberbox")
  fr.wait:SetSize(100,25):SetPos(590,love.graphics.getHeight()-fr.exit:GetHeight()-5)
  fr.wait:SetMinMax(0,60):SetValue(0.50):SetIncreaseAmount(1)
  fr.wait.OnValueChanged = function(object, value)
    _Wait = value
  end
  
  loadUnpacks(workingDir..filePath,workingDir)
end

function love.draw()
  if _Save then
    love.graphics.setBackgroundColor(0,0,0,0)
    love.graphics.draw(_Source,_Save.quad,0,0)
    if _Timer >= _Wait then
      screenshot = love.graphics.newScreenshot( true )
      screenshot:encode("/".._Save.filename)
      
      save = io.open(saveDir.._Save.filename,"rb")
      
      work = io.open(workingDir.."Unpacked/".._Save.filename,"wb")
      work:write(save:read("*all"))
      work:flush()
      work:close()
      
      save:close()
      
      love.filesystem.remove(_Save.filename)
      
      _Save = nil
    end
  else
    love.graphics.setBackgroundColor(250,250,250,255)
    loveframes.draw()
  end
end

function love.update(dt)
  _Timer = _Timer + dt
  if unpacks[currentPack] ~= nil and _Save == nil then
    quad = love.graphics.newQuad( unpacks[currentPack].x, unpacks[currentPack].y, unpacks[currentPack].width, unpacks[currentPack].height, _Source:getWidth(), _Source:getHeight() )
    _Save = { filename=unpacks[currentPack].filename,width=unpacks[currentPack].width,height=unpacks[currentPack].height,quad=quad }
    love.window.setMode(_Save.width, _Save.height, {})
    love.window.setTitle( _Save.filename )
    _Wait = fr.wait:GetValue()
    nextPack()
  elseif unpacks[currentPack] == nil and currentPack > 0 and _Timer > _Wait+1 and _Timer < _Wait+2 then
    love.window.setMode(800, 600, {})
    love.window.setTitle( "Textures Unpacker" )
    fr.current:SetValue(currentPack)
  end
  loveframes.update(dt)
end

function love.mousepressed( x, y, button )
  loveframes.mousepressed(x, y, button)
end

function love.mousereleased( x, y, button )
  loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  loveframes.keypressed(key, unicode)
end
 
function love.keyreleased(key)
  loveframes.keyreleased(key)
end

function love.textinput(text)
  loveframes.textinput(text)
end

function loadUnpacks(loadPath)
  local jsonfile = io.open(loadPath, "r")
  if jsonfile == nil then
    fr.exit:SetText("Quit")
    fr.start:SetClickable(false)
    infoFrame("Error","Can find Unpack.json",true)
    return
  end
  local json = jsonfile:read("*all")
  jsonfile:close()
  local map = JSON:decode(json)
  _Source = love.graphics.newImage("/"..map.meta.image)
  for k,data in ipairs(map.frames) do
    fr.list:AddRow(data.filename,data.frame.x.."x"..data.frame.y,data.frame.w.."x"..data.frame.h)
    table.insert(unpacks,#unpacks+1,{ filename=data.filename, x=data.frame.x, y=data.frame.y, width=data.frame.w, height=data.frame.h })
  end
  fr.current:SetMax(#unpacks)
end

function infoFrame(title,desc,closeable)
  title = title or "Unknown"
  desc = desc or ""
  
  fr.errorFrame = loveframes.Create("frame")
  fr.errorFrame:SetDraggable(false):SetAlwaysOnTop(true):SetModal(true):SetName(title)
  if not closeable then fr.errorFrame:ShowCloseButton(false) end
  fr.errorFrame:SetSize(500,300):SetPos(love.graphics.getWidth()/2,love.graphics.getHeight()/2,true)
  local text = loveframes.Create("text", fr.errorFrame)
    text:SetText(desc)
    text.Update = function(object, dt)
      object:CenterX()
      object:SetY(150)
    end
end

function doneFrame()
  fr.doneFrame = loveframes.Create("frame")
  fr.doneFrame:SetDraggable(false):SetAlwaysOnTop(true):SetModal(true):SetName("Finished Downloading")
  fr.doneFrame:SetSize(500,300):SetPos(love.graphics.getWidth()/2,love.graphics.getHeight()/2,true)
  local text = loveframes.Create("text", fr.doneFrame)
    text:SetText("Finished Unpacking.")
    text.Update = function(object, dt)
      object:CenterX()
      object:SetY(150)
    end
end

function nextPack()
  if currentPack > 0 then
    fr.current:SetValue(currentPack-1)
    _Timer = 0
  end
  currentPack = currentPack + 1
  if unpacks[currentPack] ~= nil then _Timer = 0 end
end