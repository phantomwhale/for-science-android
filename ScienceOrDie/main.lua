-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)
system.setIdleTimer(false)

local settingsSaver = require("settingsSaver")
settingsSaver:load()

_G.gameWasPaused = false
_G.gameDuration = 15

local musicMan = require("musicMan")
_G.musicFile = "LongRoad"
if _G.settingsData.musicOn then
  musicMan:playMusic(_G.musicFile, _G.settingsData.musicVolume / 100)
end

math.randomseed(os.time())

-- Set up our background
local transCam = display.newGroup()
transCam.x = 0
transCam.y = 0
local rotCam = display.newGroup()
rotCam:insert(transCam)
local paperTexture = display.newImage("images/blueprint.jpg")
if system.getInfo("platformName") == "iPhone OS" then
  paperTexture:scale(10, 10)
else
  paperTexture:scale(5, 5)
end
transCam:insert(paperTexture)

-- Load up all our 'screens'
--local screensToLoad = {"titleScreen", "modeSelectScreen", "chaosSelectScreen", "settingSelectScreen", "settingsScreen", "timerScreen", "loseScreen", "winScreen"}
local screensToLoad = { "titleScreen", "modeSelectScreen", "chaosSelectScreen", "settingsScreen", "timerScreen", "loseScreen", "winScreen", "pauseScreen" }
local screenMap = {}
local currentScreen = nil
local screenHistory = {}

local function goToScreen(screenName)
  if currentScreen ~= nil then
    screenHistory[#screenHistory + 1] = currentScreen.screenName
    if currentScreen.onExit ~= nil then
      currentScreen:onExit()
    end
  end

  local screen = screenMap[screenName]
  currentScreen = screen
  local transitionTime = 1000
  transition.to(transCam, { time = transitionTime, x = -screen.x, y = -screen.y })
  transition.to(rotCam, { time = transitionTime, rotation = -screen.rot })
  if screen.preOnEnter ~= nil then
    screen:preOnEnter()
  end
  timer.performWithDelay(transitionTime, function() if screen.onEnter ~= nil then screen:onEnter() end end, 1)
end

local function goBack()
  goToScreen(screenHistory[#screenHistory])
  -- Calling goToScreen adds the screen we just backed to on the stack, so get rid of that
  screenHistory[#screenHistory] = nil
  -- Then get rid of the screen we came from, since that isn't really 'back' either
  screenHistory[#screenHistory] = nil
end

local function buildClipList(prefix, count)
  local list = {}
  for i = 1, count do
    list[i] = prefix .. i .. ".mp3"
  end
  list.prefix = prefix
  list.samples = count
  return list
end

local function playRandomClip(clipList, volume)
  local idx = math.random(1, #clipList)
  musicMan:playVoiceOver(clipList[idx], volume)

  if #clipList == 1 then
    return buildClipList(clipList.prefix, clipList.samples)
  else
    table.remove(clipList, idx)
    return clipList
  end
end

for i = 1, #screensToLoad do
  local scr = require(screensToLoad[i])
  scr.buildClipList = buildClipList
  scr.playRandomClip = playRandomClip
  scr:loadGraphics(transCam)
  scr.screenName = screensToLoad[i]
  scr.goToScreen = goToScreen
  scr.goBack = goBack
  screenMap[screensToLoad[i]] = scr
end

-- Called when a key event has been received
local function onKeyEvent(event)
  if (event.keyName == "back") then
    goBack()

    -- Prevent the key press from backing out of the app
    return true
  end

  return false
end

Runtime:addEventListener("key", onKeyEvent)

local function onSuspended(event)
  --Pause()
end
Runtime:addEventListener("onSuspended", onSuspended)


-- Demo mode
-- Chaos mode / win / default settings
--local screensToDemo = {"titleScreen", "modeSelectScreen", "chaosSelectScreen", "settingSelectScreen", "timerScreen", "winScreen"}
-- Standard mode / lose / change settings
--local screensToDemo = {"titleScreen", "modeSelectScreen", "settingSelectScreen", "settingsScreen", "timerScreen", "loseScreen"}
--local screensToDemo = {"titleScreen", "settingsScreen", "titleScreen", "modeSelectScreen", "chaosSelectScreen", "timerScreen", "loseScreen"}
--local screensToDemo = {"titleScreen", "timerScreen", "timerScreen"}
--local screensToDemo = {"winScreen", "loseScreen"}
--local screensToDemo = {"titleScreen", "modeSelectScreen", "chaosSelectScreen", "timerScreen", "pauseScreen", "settingsScreen", "pauseScreen", "timerScreen",  "loseScreen"}
if screensToDemo ~= nil then
  for rep = 1, 5 do
    for i = 1, #screensToDemo do
      timer.performWithDelay(((rep - 1) * #screensToDemo * 2000) + 2000 * i - 1000, function() goToScreen(screensToDemo[i]) end, 1)
    end
  end
end

goToScreen("titleScreen")

