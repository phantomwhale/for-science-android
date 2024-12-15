local titleScreen = {
  x = 0,
  y = 0,
  rot = 0
}

function titleScreen:loadGraphics(cam, debug)
  local screenGroup = display.newGroup()
  screenGroup.x = self.x
  screenGroup.y = self.y
  screenGroup.rotation = self.rot
  cam:insert(screenGroup)

  if debug then
    local titleText = display.newText({
      parent = screenGroup,
      x = self.x + display.contentCenterX,
      y = self.y + display.contentCenterY * 0.5,
      text = "Title",
      font = "fonts/Alien-Encounters-Solid-Regular.ttf",
      fontSize = 128
    })
    titleText:setFillColor(1)

    local frame = display.newRect(screenGroup, self.x + display.contentCenterX, self.y + display.contentCenterY, display.contentWidth, display.contentHeight)
    frame.strokeWidth = 8
    frame:setFillColor(1, 1, 0, 0.2)
    frame:setStrokeColor(1, 1, 0)
  end

  local titleImg = display.newImage(screenGroup, "images/ForScience.png")
  titleImg.x = display.contentCenterX
  titleImg.y = display.contentCenterY - 150
  titleImg:scale(1.75, 1.75)
  
  local widget = require("widget")
  local btn = widget.newButton({
    width = 900,
    height = 275,
    fontSize = 96,
    label = "NEW GAME",
    font = "fonts/LemonMilk.otf",
    labelColor = { default={1,1,1}, over={1,1,1} },
    defaultFile = "images/paperButtonUp.png",
    overFile = "images/paperButtonDown.png",
    onRelease = function() self.goToScreen("modeSelectScreen") end
  })
  btn.x = display.contentCenterX
  btn.y = display.contentCenterY * 1.4
  screenGroup:insert(btn)

  -- Settings Button -------------------------------------
  btn = widget.newButton({
    width = 200,
    height = 200,
    defaultFile = "images/gear.png",
    --overFile = "images/backButtonDown.png",
    onRelease = function() self.goToScreen("settingsScreen") end
  })
  btn.x = display.contentCenterX + (display.viewableContentWidth / 2) - 200
  btn.y = display.contentCenterY + (display.viewableContentHeight / 2) - 150
  screenGroup:insert(btn)
  ----------------------------------------------------  
end

return titleScreen