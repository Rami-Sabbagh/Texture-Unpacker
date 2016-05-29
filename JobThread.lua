--Texture Unpacker By RamiLego4Game--Github: https://github.com/RamiLego4Game/Texture-Unpacker .--
--[[
Copyright 2016 Rami Sabbagh

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]

require("love.thread")
require("love.image")

local JSON = require("JSON")

local SDC = love.thread.getChannel("SDC") --Sheet Directory Channel
local SIC = love.thread.getChannel("SIC") --Sheet Image Channel
local JTC = love.thread.getChannel("JTC") --Job Target Channel
local RC = love.thread.getChannel("RC") --Results Channel

local SheetDirectory = SDC:demand()
local SheetImage = SIC:demand() 
local JobTarget = JTC:demand()

while JobTarget do
  local Target = JSON:decode(JobTarget)
  --if Target.trimmed then Target.spriteSourceSize.x, Target.spriteSourceSize.y = Target.spriteSourceSize.x-1, Target.spriteSourceSize.y-1 end
  local Image = love.image.newImageData(Target.sourceSize.w,Target.sourceSize.h)
  for x = 0,Target.frame.w-1 do
    for y = 0,Target.frame.h-1 do
      Image:setPixel(x+Target.spriteSourceSize.x,y+Target.spriteSourceSize.y,
      SheetImage:getPixel(Target.frame.x+x,Target.frame.y+y))
    end
  end
  Image:encode("png",SheetDirectory..Target.filename)
  RC:push(Target.filename)
  
  JobTarget = JTC:demand()
end