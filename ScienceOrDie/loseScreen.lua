local loseScreen = {
  x = -2700,
  y = 0,
  rot = 15
}

local musicMan = require("musicMan")

local loseFlavorTexts = {
  "Civilization is collapsing. But on the bright side, no more pressure!",
  "SciStack would like to congratulate you on cleverly eliminating our competitors! Sadly, it seems we're about to follow.",
  "Okay, so Plan A failed. Plan B: build an emergency bunker in the next 5 minutes.",
  "Okay, so Plan A failed. Plan B: genetically modify yourselves to hibernate out the coming apocalypse.",
  "Okay, so Plan A failed. Plan B: build an expedition to Mars that can launch from SciStack HQ.",
  "Okay, so Plan A failed. Plan B: hope the viruses are friendly?",
  "Okay, so Plan A failed. Plan B: lock yourselves in the clean room with plenty of snacks.",
  "Okay, so Plan A failed. Plan B: build a time machine.",
  "Okay, so Plan A failed. Plan B: hold your breath for the next 3 years.",
  "Oh dear. That didn't go as well as we'd hoped.",
  "HEADLINE: Crack Stackers Slacked, Sacked",
  "Doomed! We're all dooooooomed! Doom!",
  "We at SciStack appreciate your hard work! Sadly, sometimes hard work just isn't enough.",
  "ERROR: Overpressurized geniuses. Brain leakage critical. Shutdown imminent.",
  "We here at SciStack apologize for stocking insufficient coffee for your team. Our bad!",
  "If you harbor residual guilt about dooming humanity, remember: SciStack offers free therapy services every afternoon!",
  "We really must have a word with our negotiation team to make sure our contracts have less aggressive timetables.",
  "But everyone's fine! It was just a drill! Really, not lying, we swear!",
  "We expect your team to tackle future multipandemics more effectively. Practice! But not by releasing more diseases, that's bad!",
  "Please take a moment to sit with your feelings about this. Remember, SciStack cares!",
  "Please submit feedback to your supervisors about how SciStack could better have supported you in this frenzied crisis.",
  "Don't forget, you're still geniuses! Just... probably-doomed geniuses!",
  "Failure leads to learning, learning leads to success!",
  "Clearly we need to re-imagine our mission statement to better expedite our process initiatives.",
  "But though our reputation is in shambles, we will press onward, for SCIENCE!"
}

function loseScreen:loadGraphics(cam, debug)
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
      text = "LOSE",
      font = "fonts/Alien-Encounters-Solid-Regular.ttf",
      fontSize = 96
    })
    titleText:setFillColor(1)

    local frame = display.newRect(screenGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    frame.strokeWidth = 8
    frame:setFillColor(1, 1, 1, 0.2)
    frame:setStrokeColor(1, 1, 1)
  end

  local titleText = display.newText({
    parent = screenGroup,
    x = display.contentCenterX,
    y = display.contentCenterY * 0.6,
    text = "DEFEAT!",
    font = "fonts/Alien-Encounters-Solid-Regular.ttf",
    fontSize = 200
  })
  titleText:setFillColor(1)

  local flavorText = display.newText({
    parent = screenGroup,
    x = display.contentCenterX,
    y = display.contentCenterY * 0.95,
    font = "fonts/LemonMilk.otf",
    text = loseFlavorTexts[math.random(#loseFlavorTexts)],
    width = display.contentWidth * 0.8,
    align = "center",
    fontSize = 56
  })
  flavorText:setFillColor(1)
  self.flavorText = flavorText

  screenGroup:insert(self:makeButton("Title Screen", function() self.goToScreen("titleScreen") end, display.contentCenterX * 0.5))
  screenGroup:insert(self:makeButton("Play Again", function() self.goToScreen("timerScreen") end, display.contentCenterX * 1.5))
end

function loseScreen:preOnEnter()
  _G.gameWasPaused = false
  if _G.settingsData.gameOverSoundsOn then
    musicMan:playSoundEffect("Failure.mp3", _G.settingsData.gameOverVolume / 100)
    if _G.settingsData.musicOn then
      musicMan:stopMusic()
      local lengthOfFanfare = 6414
      timer.performWithDelay(lengthOfFanfare, function() musicMan:playMusic(_G.musicFile, _G.settingsData.musicVolume / 100) end, 1)
    end
  end
  self.flavorText.text = loseFlavorTexts[math.random(#loseFlavorTexts)]
end

function loseScreen:makeButton(text, callback, xPos)
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
  btn.x = xPos
  btn.y = display.contentCenterY * 1.4

  return btn
end

return loseScreen

