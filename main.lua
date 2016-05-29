--TextureUnpacker By RamiLego4Game--
io.stdout:setvbuf("no")

local JSON = require("JSON")
local _Width, _Height = love.graphics.getDimensions()
local _Font, _Images, _Info, _Status, _Errmsg = {}, {}, "Please drop the sheet files into this window to extract", "Waiting for sheet files...", ""
local JobStarted, JobFrame, tArr, tSheet, tImage, JobThread = false, 1, nil, nil, nil, nil
local SDC = love.thread.getChannel("SDC") --Sheet Directory Channel
local SIC = love.thread.getChannel("SIC") --Sheet Image Channel
local JTC = love.thread.getChannel("JTC") --Job Target Channel
local RC = love.thread.getChannel("RC") --Results Channel

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
  love.graphics.printf("Press any key to open the extracted sheets directory",(_Height/16)*0.75,_Height-(_Height/8)*1.35,_Width-(_Height/8),"left")
  love.graphics.printf("This tool has been made by RamiLego4Game for MoveOrDie",(_Height/16)*0.75,_Height-(_Height/8)*0.75,_Width-(_Height/8),"left")
end

local function splitFilePath(path)
  return path:match("(.-)([^\\/]-%.?([^%.\\/]*))$")
end

local function startJob()
  tSheet = tArr.meta.image:sub(0,-5)
  tImage = _Images[tArr.meta.image]
  _Info = "Target Sheet: "..tSheet
  local tW, tH = tImage:getDimensions()
  if tW == tArr.meta.size.w and tH == tArr.meta.size.h then
    JobStarted = true
    JobThread = love.thread.newThread("/JobThread.lua")
    love.filesystem.createDirectory(tSheet)
    _Status = "Started Extracting Job"
    JobThread:start()
    SDC:push("/"..tSheet.."/")
    SIC:push(tImage)
    JTC:push(JSON:encode(tArr.frames[JobFrame]))
  else
    _Errmsg = "Error: Sheet image size doesn't match the size specified in the json file !"
    _Status = "Waiting for Sheet Image: "..tArr.meta.image
  end
end

function love.filedropped(file)
  if JobStarted then return end _Errmsg = ""
  local filePath, fileName, fileExtension = splitFilePath(file:getFilename())
  print(fileName.." ("..fileExtension..") has been dropped into the tool.")
  if fileExtension == "png" or fileExtension == "jpg" then
    assert(file:open("r")) local fileContent = file:read() file:close()
    local Filedata, err = love.filesystem.newFileData(fileContent,fileName) if err then error(err) end
    _Images[fileName] = love.image.newImageData(Filedata)
    if tArr then
      if tArr.meta.image == fileName then
        startJob()
      else
        _Status = "Loaded "..fileName..", Waiting for Sheet Image: "..tArr.meta.image
      end
    else
      _Status = "Loaded "..fileName..", Waiting for JSON file..."
    end
  elseif fileExtension == "json" then
    assert(file:open("r")) local jData = file:read() file:close()
    local jArr = JSON:decode(jData)
    if _Images[jArr.meta.image] then
      tArr = jArr
      startJob()
    else
      tSheet = jArr.meta.image:sub(0,-5)
      _Info = "Target Sheet: "..tSheet
      _Status = "Waiting for Sheet Image: "..jArr.meta.image
      tArr = jArr
    end
  end
end

function love.update(dt)
  local RN = RC:pop()
  if RN then
    _Status = "Extracted "..RN
    JobFrame = JobFrame + 1
    if tArr.frames[JobFrame] then
      JTC:push(JSON:encode(tArr.frames[JobFrame]))
    else
      _Info = "The sheet has been extracted successfully, Please drop the next sheet files into this window to extract."
      _Status = "Waiting for the next sheet files..."
      JobStarted, JobFrame, tArr, tSheet, tImage, JobThread = false, 1, nil, nil, nil, nil
      JTC:push(false)
    end
  end
end

function love.keyreleased(key)
  love.system.openURL("file://"..love.filesystem.getSaveDirectory())
end

function love.threaderror(thread,errmsg)
  _Info = "The Job Thread has crashed !"
  _Status = "Please report this issue in the github repository"
  _Errmsg = "ThreadError: "..errmsg
end