local pauseScreen = {
  x = 0,
  y = 700,
  rot = 45
}

local musicMan = require("musicMan")

function pauseScreen:loadGraphics(cam, debug)
  local screenGroup = display.newGroup()
  screenGroup.x = self.x
  screenGroup.y = self.y
  screenGroup.rotation = self.rot
  cam:insert(screenGroup)

  local titleText = display.newText({
    parent = screenGroup,
    x = display.contentCenterX,
    y = display.contentCenterY * 0.5,
    text = "PAUSED",
    font = "fonts/Alien-Encounters-Solid-Regular.ttf",
    fontSize = 128
  })
  titleText:setFillColor(1)

  if debug then
    local frame = display.newRect(screenGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    frame.strokeWidth = 8
    frame:setFillColor(1, 1, 1, 0.2)
    frame:setStrokeColor(1, 1, 1)
  end

  local widget = require("widget")

  local btn = widget.newButton({
    width = 900,
    height = 275,
    fontSize = 96,
    label = "RESUME",
    font = "fonts/LemonMilk.otf",
    labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1 } },
    defaultFile = "images/paperButtonUp.png",
    overFile = "images/paperButtonDown.png",
    onRelease = function()
      self.goBack()
    end
  })
  btn.x = display.contentCenterX
  btn.y = display.contentCenterY
  screenGroup:insert(btn)

  local btn = widget.newButton({
    width = 900,
    height = 275,
    fontSize = 96,
    label = "END GAME",
    font = "fonts/LemonMilk.otf",
    labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1 } },
    defaultFile = "images/paperButtonUp.png",
    overFile = "images/paperButtonDown.png",
    onRelease = function()
      local musicMan = require("musicMan")
      _G.gameWasPaused = false
      self.goToScreen("titleScreen")
    end
  })
  btn.x = display.contentCenterX
  btn.y = display.contentCenterY * 1.35
  screenGroup:insert(btn)

  -- Settings Button -------------------------------------
  local btn = widget.newButton({
    width = 200,
    height = 200,
    defaultFile = "images/gear.png",
    onRelease = function() self.goToScreen("settingsScreen") end
  })
  btn.x = display.contentCenterX + (display.viewableContentWidth / 2) - 200
  btn.y = display.contentCenterY + (display.viewableContentHeight / 2) - 150
  screenGroup:insert(btn)
  ----------------------------------------------------
end

return pauseScreen

