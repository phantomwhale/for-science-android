local settingSelectScreen = {
  x = 4500,
  y = 1800,
  rot = 10
}

function settingSelectScreen:loadGraphics(cam, debug)
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
      text = "SETTING SELECT",
      font = "fonts/Alien-Encounters-Solid-Regular.ttf",
      fontSize = 96
    })
    titleText:setFillColor(1)

    local frame = display.newRect(screenGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    frame.strokeWidth = 8
    frame:setFillColor(1, 1, 1, 0.2)
    frame:setStrokeColor(1, 1, 1)
  end

  screenGroup:insert(self:makeButton("Begin the game", "using standard settings", function() self.goToScreen("timerScreen") end, display.contentCenterY * 0.5))
  screenGroup:insert(self:makeButton("Custom settings", "(Audio/video)", function() self.goToScreen("settingsScreen") end, display.contentCenterY * 1.5))

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

function settingSelectScreen:makeButton(text, textToo, callback, yPos)
  local widget = require("widget")
  local btn = widget.newButton({
    width = 900,
    height = 275,
    fontSize = 64,
    label = text,
    font = "fonts/LemonMilk.otf",
    labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1 } },
    defaultFile = "images/paperButtonUp.png",
    overFile = "images/paperButtonDown.png",
    onRelease = callback
  })
  btn.x = display.contentCenterX
  btn.y = yPos

  return btn
end

return settingSelectScreen

