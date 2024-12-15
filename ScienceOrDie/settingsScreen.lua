local settingsScreen = {
  x = -500,
  y = -2300,
  rot = 60
}

local musicMan = require("musicMan")

local sliderOpts = {
  frames = {
    {
      x = 0,
      y = 0,
      width = 22,
      height = 78
    },
    {
      x = 22,
      y = 0,
      width = 22,
      height = 78
    },
    {
      x = 44,
      y = 0,
      width = 22,
      height = 78
    },
    {
      x = 66,
      y = 0,
      width = 22,
      height = 78
    },
    {
      x = 94,
      y = 0,
      width = 30,
      height = 78
    }
  }
}
--local imageSheet = graphics.newImageSheet( "characterSheet.png", options )

function settingsScreen:loadGraphics(cam, debug)
  local screenGroup = display.newGroup()
  screenGroup.x = self.x
  screenGroup.y = self.y
  screenGroup.rotation = self.rot
  cam:insert(screenGroup)

  if debug then
    local titleText = display.newText({
      parent = screenGroup,
      x = display.contentCenterX,
      y = display.contentCenterY * 0.5,
      text = "SETTINGS",
      font = "fonts/Alien-Encounters-Solid-Regular.ttf",
      fontSize = 64
    })
    titleText:setFillColor(1)

    local frame = display.newRect(screenGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    frame.strokeWidth = 8
    frame:setFillColor(1, 1, 1, 0.2)
    frame:setStrokeColor(1, 1, 1)
  end
  
  local audioText = display.newText({
    parent = screenGroup,
    x = display.contentCenterX - display.viewableContentWidth * 0.2,
    y = display.contentCenterY - display.viewableContentHeight * 0.35,
    text = "AUDIO",
    font = "fonts/Alien-Encounters-Solid-Regular.ttf",
    fontSize = 98
  })
  audioText:setFillColor(1)
  local videoText = display.newText({
    parent = screenGroup,
    x = display.contentCenterX - display.viewableContentWidth * 0.2,
    y = display.contentCenterY + display.viewableContentHeight * 0.35,
    text = "VIDEO",
    font = "fonts/Alien-Encounters-Solid-Regular.ttf",
    fontSize = 98
  })
  videoText:setFillColor(1)
  
  screenGroup:insert(self:makeSlider("musicVolume", "Music Volume",
    display.contentCenterX + display.viewableContentWidth * 0.25, 
    display.contentCenterY - display.viewableContentHeight * 0.35))
  screenGroup:insert(self:makeSlider("warningVolume", "Countdown Volume", 
    display.contentCenterX - display.viewableContentWidth * 0.25, 
    display.contentCenterY - display.viewableContentHeight * 0.14))
  screenGroup:insert(self:makeSlider("eventVolume", "Events Volume", 
    display.contentCenterX - display.viewableContentWidth * 0.25, 
    display.contentCenterY + display.viewableContentHeight * 0.07))
  screenGroup:insert(self:makeSlider("gameOverVolume", "Game Over Volume", 
    display.contentCenterX + display.viewableContentWidth * 0.25, 
    display.contentCenterY + display.viewableContentHeight * 0.07))
  screenGroup:insert(self:makeSlider("doomQuoteVolume", "Lab Quotes Volume", 
    display.contentCenterX + display.viewableContentWidth * 0.25, 
    display.contentCenterY - display.viewableContentHeight * 0.14))
--[[
  screenGroup:insert(self:makeSetting("musicOn", "Soundtrack", 
    display.contentCenterX + display.viewableContentWidth * 0.25, 
    display.contentCenterY - display.viewableContentHeight * 0.35))
  screenGroup:insert(self:makeSetting("warningSoundsOn", "Countdown SFX", 
    display.contentCenterX - display.viewableContentWidth * 0.25, 
    display.contentCenterY - display.viewableContentHeight * 0.15))
  screenGroup:insert(self:makeSetting("eventSoundsOn", "Events SFX", 
    display.contentCenterX - display.viewableContentWidth * 0.25, 
    display.contentCenterY + display.viewableContentHeight * 0.05))
  screenGroup:insert(self:makeSetting("gameOverSoundsOn", "Game Over SFX", 
    display.contentCenterX + display.viewableContentWidth * 0.25, 
    display.contentCenterY + display.viewableContentHeight * 0.05))
  screenGroup:insert(self:makeSetting("doomQuoteSoundsOn", "Lab Quotes SFX", 
    display.contentCenterX + display.viewableContentWidth * 0.25, 
    display.contentCenterY - display.viewableContentHeight * 0.15))
    
    ]]
  screenGroup:insert(self:makeSetting("flashingEventsOn", "Flash on event", 
    display.contentCenterX + display.viewableContentWidth * 0.25, 
    display.contentCenterY + display.viewableContentHeight * 0.35))
  
  -- Back Button -------------------------------------
  local widget = require("widget")
  local btn = widget.newButton({
    width = 200,
    height = 200,
    defaultFile = "images/backButton.png",
    overFile = "images/backButtonDown.png",
    onRelease = function() self.goBack() end
  })
  btn.x = display.contentCenterX - (display.viewableContentWidth / 2) + 100
  btn.y = display.contentCenterY + (display.viewableContentHeight / 2) - 100
  screenGroup:insert(btn)
  ----------------------------------------------------  
end

function settingsScreen:makeSlider(dataName, displayName, xPos, yPos)
  local settingsSaver = require("settingsSaver")
  local widget = require("widget")
  local sliderSheet = graphics.newImageSheet("images/sliderSheet.png", sliderOpts)
  local setting = display.newGroup()
  setting.x = xPos
  setting.y = yPos

  local function sliderListener(event)
    _G.settingsData[dataName] = event.value
    settingsSaver:save()

    if dataName == "musicVolume" then
      musicMan:setMusicVolume(event.value/100)
    elseif event.phase == "ended" and dataName:sub(-6) == "Volume" then
      musicMan:playSoundEffect("bloop.mp3", event.value/100)
    end
  end

  local slider = widget.newSlider(
    {
      sheet = sliderSheet,
      leftFrame = 1,
      middleFrame = 2,
      rightFrame = 3,
      fillFrame = 4,
      frameWidth = 22,
      frameHeight = 78,
      handleFrame = 5,
      handleWidth = 30,
      handleHeight = 78,
      x = 0,
      y = 50,
      orientation = "horizontal",
      width = 800,
      listener = sliderListener,
      value = _G.settingsData[dataName]
    }
  )
  setting:insert(slider)
  
  local displayText = display.newText({
    parent = screenGroup,
    text = displayName,
    font = "fonts/Alien-Encounters-Solid-Regular.ttf",
    fontSize = 78,
  })
  displayText.x = displayText.width/2
  displayText.y = -50
  displayText.anchorX = 1
  displayText:setFillColor(0.7)
  setting:insert(displayText)

  return setting
end

function settingsScreen:makeSetting(dataName, displayName, xPos, yPos)
  local settingsSaver = require("settingsSaver")
  local widget = require("widget")

  local setting = display.newGroup()
  setting.x = xPos
  setting.y = yPos

  local checkboxSheet = graphics.newImageSheet("images/checkbox.png", {
    width = 100,
    height = 100,
    numFrames = 2,
    sheetContentWidth = 200,
    sheetContentHeight = 100
  })
  local checkbox = widget.newSwitch({
    sheet = checkboxSheet,
    frameOff = 1,
    frameOn = 2,
    width = 200,
    height = 200,
    initialSwitchState = _G.settingsData[dataName],
    style = "checkbox",
    onPress = function(event) 
      _G.settingsData[dataName] = event.target.isOn
      settingsSaver:save()

      if dataName == "musicOn" then
        if event.target.isOn then
          musicMan:playMusic(_G.musicFile, _G.settingsData.musicVolume/100)
        else
          musicMan:stopMusic()
        end
      elseif dataName == "flashingEventsOn" then
      end
    end
  })
  checkbox.x = 300
  checkbox.y = 0
  setting:insert(checkbox)

  local displayText = display.newText({
    parent = screenGroup,
    text = displayName,
    font = "fonts/Alien-Encounters-Solid-Regular.ttf",
    fontSize = 78,
  })
  displayText.x = 200
  displayText.y = 0
  displayText.anchorX = 1
  displayText:setFillColor(0.7)
  setting:insert(displayText)

  return setting
end

return settingsScreen