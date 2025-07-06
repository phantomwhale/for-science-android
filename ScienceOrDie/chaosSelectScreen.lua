local chaosSelectScreen = {
  x = 5000,
  y = 1000,
  rot = 80
}

function chaosSelectScreen:loadGraphics(cam, debug)
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
      text = "CHAOS SELECT",
      font = "fonts/Alien-Encounters-Solid-Regular.ttf",
      fontSize = 96
    })
    titleText:setFillColor(1)

    local frame = display.newRect(screenGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    frame.strokeWidth = 8
    frame:setFillColor(1, 0, 1, 0.2)
    frame:setStrokeColor(1, 0, 1)
  end

  screenGroup:insert(self:makeButton("stable", "1 event every 3-5 minutes", function() self:advance(1) end, display.contentWidth * 0.27, display.contentHeight * 0.4))
  screenGroup:insert(self:makeButton("unstable", "1 event every 2-3 minutes", function() self:advance(2) end, display.contentWidth * 0.27, display.contentHeight * 0.6))
  screenGroup:insert(self:makeButton("chaotic", "1 event every 1.5-2.5 minutes", function() self:advance(3) end, display.contentWidth * 0.73, display.contentHeight * 0.4))
  screenGroup:insert(self:makeButton("crisis", "1 event every 1-2 minutes", function() self:advance(4) end, display.contentWidth * 0.73, display.contentHeight * 0.6))

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

function chaosSelectScreen:advance(difficulty)
  _G.settingsData.difficulty = difficulty
  --self.goToScreen("settingSelectScreen")
  self.goToScreen("timerScreen")
end

function chaosSelectScreen:makeButton(text, textToo, callback, xPos, yPos)
  local widget = require("widget")
  local btn = widget.newButton({
    width = 900,
    height = 275,
    defaultFile = "images/paperButtonUp.png",
    overFile = "images/paperButtonDown.png",
    onRelease = callback
  })
  btn.x = xPos
  btn.y = yPos

  local btnWidth = btn.width
  local btnHeight = btn.height

  local maintext = display.newText({
    parent = btn,
    text = text,
    font = "fonts/LemonMilk.otf",
    fontSize = 78
  })
  maintext.x = btnWidth / 2
  maintext.y = btnHeight * 0.4

  local subtext = display.newText({
    parent = btn,
    text = textToo,
    font = "fonts/LemonMilk.otf",
    fontSize = 48
  })
  subtext.x = btnWidth / 2
  subtext.y = btnHeight * 0.65

  return btn
end

return chaosSelectScreen

