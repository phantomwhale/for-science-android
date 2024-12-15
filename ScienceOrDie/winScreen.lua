local winScreen = {
  x = -2200,
  y = 3000,
  rot = -30
}

local musicMan = require("musicMan")

local victoryFlavorTexts = {
  -- Great 100-50%
  {
    "That was SO efficient that the Org Group Reorganization Committee has nominated you for management. Yay?",
    "Your expertise is astounding. You... weren't the ones to release those diseases, were you?",
    "Y'all were so good, nobody believes you did any work of consequence. Whoops.",
    "Amazingly fast! Incredibly efficient! We'll have to give you twice as much to tackle next time!",
    "Egads! Are you sure you're not illegally augmented? If you are, please talk to HR."
  },
  -- Better 50-25%
  {
    "FABULOUS! Care to pick a name for your team of super-scientists?",
    "You have done great good for the citizenry of the world. Also, incidentally, for our stock price.",
    "Wow, you made that look easy! It was hard, right? We got paid like it was hard.",
    "HEADLINE: Crack Stackers Pack a Knack For SCIENCE!",
    "Can't... stop... applauding!...",
    "We here at SciStack thank you for your genius. Please don't use it for evil.",
    "Bravo! For an encore, can you create a new form of life for our next Board Meeting?"
  },
  -- Good 25-10%
  {
    "Nicely done, scientists! You've averted global catastrophe!",
    "We hope you're pleased with yourself. We think you're fantastic!",
    "You are cordially invited to a celebration in honor of your heroism.",
    "In good news, you've still got a job! In even better news, you've saved the world!",
    "CONGRATULATIONS from all of SciStack! Please submit your promotion paperwork after decontamination.",
    "Tense, but we had the utmost faith that you would pull through! Excellently done.",
    "You are CHAMPIONS. Like, sports stars - not French mushrooms. Those are spelled differently, right?"
  },
  -- OK <10%
  {
    "Whew, that was a close one - but you made it!",
    "Just in time! SciStack thanks you for skipping your lunch break!",
    "We never stopped believing in you, even when our AIs told us we should! Bravo!",
    "YES! We are SO PSYCHED to NOT BE DEAD!",
    "We may have panicked for a minute there. We're okay now. Great job!",
    "We sob with joy at the lack of our imminent demise. THANK YOU.",
    "Last-minute heroism - that's the SciStack way! Go, team!"
  }
}

function winScreen:loadGraphics(cam, debug)
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
      text = "WIN",
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
    text = "VICTORY!",
    font = "fonts/Alien-Encounters-Solid-Regular.ttf",
    fontSize = 200
  })
  titleText:setFillColor(1)

  local flavorText = display.newText({
    parent = screenGroup,
    x = display.contentCenterX,
    y = display.contentCenterY * 0.95,
    text = victoryFlavorTexts[1][math.random(#victoryFlavorTexts)],
    font = "fonts/LemonMilk.otf",
    width = display.contentWidth * 0.8,
    align = "center",
    fontSize = 56
  })
  flavorText:setFillColor(1)
  self.flavorText = flavorText

  self.winClips = self.buildClipList("voice/game-won-", 4)

  screenGroup:insert(self:makeButton("Title Screen", function() self.goToScreen("titleScreen") end, display.contentCenterX * 0.5))
  screenGroup:insert(self:makeButton("Play Again", function() self.goToScreen("timerScreen") end, display.contentCenterX * 1.5))
end

function winScreen:preOnEnter()
  _G.gameWasPaused = false
  
  if _G.settingsData.gameOverSoundsOn then
    musicMan:playSoundEffect("VictoryFanfare.mp3", _G.settingsData.gameOverVolume/100)
    if _G.settingsData.musicOn then
      musicMan:stopMusic()
      local lengthOfFanfare = 9500
	    timer.performWithDelay(lengthOfFanfare, function() musicMan:playMusic(_G.musicFile, _G.settingsData.musicVolume/100) end, 1)
    end
    self.winClips = self.playRandomClip(self.winClips, _G.settingsData.gameOverVolume/100)
  end

  local winType = 1
  if _G.percentTimeRemaining < 0.5 and _G.percentTimeRemaining >= 0.25 then
    winType = 2
  elseif _G.percentTimeRemaining < 0.25 and _G.percentTimeRemaining >= 0.1 then
    winType = 3
  elseif _G.percentTimeRemaining < 0.1 then
    winType = 4
  end

  self.flavorText.text = victoryFlavorTexts[winType][math.random(#victoryFlavorTexts)]
end

function winScreen:makeButton(text, callback, xPos)
  local widget = require("widget")
  local btn = widget.newButton({
    width = 900,
    height = 275,
    fontSize = 64,
    label = text,
    font = "fonts/LemonMilk.otf",
    labelColor = { default={1,1,1}, over={1,1,1} },
    defaultFile = "images/paperButtonUp.png",
    overFile = "images/paperButtonDown.png",
    onRelease = callback
  })
  btn.x = xPos
  btn.y = display.contentCenterY * 1.4
  
  return btn
end

return winScreen