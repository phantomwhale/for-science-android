local modeSelectScreen = {
  x = 3000,
  y = -1500,
  rot = 50
}

function modeSelectScreen:loadGraphics(cam, debug)
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
      text = "MODE SELECT",
      font = "fonts/Alien-Encounters-Solid-Regular.ttf",
      fontSize = 96
    })
    titleText:setFillColor(1)

    local frame = display.newRect(screenGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    frame.strokeWidth = 8
    frame:setFillColor(1, 0, 0, 0.2)
    frame:setStrokeColor(1, 0, 0)
  end

  local durationText = display.newText({
    parent = screenGroup,
    x = display.contentCenterX,
    y = display.contentCenterY * 0.5,
    text = "GAME LENGTH",
    font = "fonts/Alien-Encounters-Solid-Regular.ttf",
    fontSize = 128
  })
  durationText:setFillColor(1)

  screenGroup:insert(self:makeTimeButton("20", false, function() _G.gameDuration = 20 end, display.contentWidth * 0.25))
  screenGroup:insert(self:makeTimeButton("15", true, function() _G.gameDuration = 15 end, display.contentWidth * 0.35))
  screenGroup:insert(self:makeTimeButton("12", false, function() _G.gameDuration = 12 end, display.contentWidth * 0.45))
  screenGroup:insert(self:makeTimeButton("10", false, function() _G.gameDuration = 10 end, display.contentWidth * 0.55))
  screenGroup:insert(self:makeTimeButton("8.5", false, function() _G.gameDuration = 8.5 end, display.contentWidth * 0.65))
  screenGroup:insert(self:makeTimeButton("7.5", false, function() _G.gameDuration = 7.5 end, display.contentWidth * 0.75))

  screenGroup:insert(self:makeButton("Standard Mode", "No Events", function() self.goToScreen("timerScreen") end, display.contentHeight * 0.55))
  screenGroup:insert(self:makeButton("Chaos Mode", "Has Events", function() self.goToScreen("chaosSelectScreen") end, display.contentCenterY * 1.45))
  
  -- Back Button -------------------------------------
  local widget = require("widget")
  local btn = widget.newButton({
    width = 200,
    height = 200,
    defaultFile = "images/backButton.png",
    overFile = "images/backButtonDown.png",
    onRelease = function() self.goBack() end
  })
  btn.x = display.contentCenterX - (display.viewableContentWidth / 2) + 200
  btn.y = display.contentCenterY + (display.viewableContentHeight / 2) - 150
  screenGroup:insert(btn)
  ----------------------------------------------------  
end

function modeSelectScreen:onEnter()
  _G.settingsData.difficulty = 0
end

function modeSelectScreen:makeTimeButton(text, state, callback, xPos)
  local widget = require("widget")
    
  local timeBtnSheet = graphics.newImageSheet("images/timeButtonSheet.png", {
    width = 203,
    height = 202,
    numFrames = 2,
    sheetContentWidth = 406,
    sheetContentHeight = 202
  })
  local btn = widget.newSwitch({
    sheet = timeBtnSheet,
    frameOff = 1,
    frameOn = 2,
    width = 203,
    height = 202,
    initialSwitchState = state,
    style = "radio",
    onPress = callback
  })
  btn.x = xPos
  btn.y = display.contentHeight * 0.37

  local btnText = display.newText({
    parent = btn,
    text = text,
    font = "fonts/LemonMilk.otf",
    fontSize = 76
  })
  btnText.x = 203/2
  btnText.y = 202/2
  btnText:setFillColor(0)

  return btn
end

function modeSelectScreen:makeButton(text, textToo, callback, yPos)
  local widget = require("widget")
  local btn = widget.newButton({
    width = 900,
    height = 275,
    defaultFile = "images/paperButtonUp.png",
    overFile = "images/paperButtonDown.png",
    onRelease = callback
  })
  btn.x = display.contentCenterX
  btn.y = yPos

  local btnWidth = btn.width
  local btnHeight = btn.height

  local maintext = display.newText({
    parent = btn,
    text = text,
    font = "fonts/LemonMilk.otf",
    fontSize = 78
  })
  maintext.x = btnWidth/2
  maintext.y = btnHeight * 0.4

  local subtext = display.newText({
    parent = btn,
    text = textToo,
    font = "fonts/LemonMilk.otf",
    fontSize = 64
  })
  subtext.x = btnWidth/2
  subtext.y = btnHeight * 0.65

  return btn
end

return modeSelectScreen
