local timerScreen = {
  x = 500,
  y = 3000,
  rot = 30,
  popupShowing = false,
  filterOn = false
}

local eventTitles = {
  "Uh-Oh.",
  "Aaaaaaagh!",
  "No! Nonono!",
  "Nooooooooo!",
  "What now?!",
  -- "Everyone start cursing",
  -- "So there's this...issue...",
  "Doesn't that figure?",
  "Complication alert!",
  "Crud crud crud crud",
  "We have a problem.",
  "Incoming headache!"
}

local musicMan = require("musicMan")

function timerScreen:loadGraphics(cam, debug)
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
      text = "TIMER",
      font = "fonts/Alien-Encounters-Solid-Regular.ttf",
      fontSize = 96
    })
    titleText:setFillColor(1)

    local frame = display.newRect(screenGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    frame.strokeWidth = 8
    frame:setFillColor(1, 1, 1, 0.2)
    frame:setStrokeColor(1, 1, 1)
  end

  local clockWidget = require("clockWidget")
  clockWidget:createVisuals(screenGroup)
  clockWidget.eventCallback = function() self:showEvent() end
  clockWidget.doomCallback = function() self:DOOM() end
  clockWidget.timeOverCallback = function()
    self.goToScreen("loseScreen")
  end
  self.clockWidget = clockWidget

  local gameWon = false
  local needsToConfirm = true

  local function resetWinButton()
    needsToConfirm = true
    self.winButton.maintext.text = "Mission"
    self.winButton.subtext.text = "Accomplished"
    self.winButton.maintext:setFillColor(1)
    self.winButton.subtext:setFillColor(1)
    if not gameWon then
      self.clockWidget:unpause()
      gameWon = false
    end
  end
  local function onTapWin()
    if not self.popupShowing then
      if needsToConfirm then
        needsToConfirm = false
        self.winButton.maintext.text = "REALLY?"
        self.winButton.subtext.text = "You did it?"
        self.winButton.maintext:setFillColor(232 / 255, 239 / 255, 127 / 255)
        self.winButton.subtext:setFillColor(232 / 255, 239 / 255, 127 / 255)
        timer.performWithDelay(4000, resetWinButton, 1)
        self.clockWidget:pause()
      else
        gameWon = true
        self.goToScreen("winScreen")
      end
    end
  end
  self.winButton = self:makeButton("Mission", "Accomplished", onTapWin, display.contentCenterY * 0.6)
  screenGroup:insert(self.winButton)

  -- Pause Button -------------------------------------
  local widget = require("widget")
  local btn = widget.newButton({
    width = 300,
    height = 300,
    defaultFile = "images/pauseButton.png",
    overFile = "images/pauseButtonDown.png",
    onRelease = function() self.goToScreen("pauseScreen") end
  })
  btn.x = display.contentCenterX - (display.viewableContentWidth / 2) + 200
  btn.y = display.contentCenterY + (display.viewableContentHeight / 2) - 200
  screenGroup:insert(btn)
  ----------------------------------------------------

  self.generalClips = self.buildClipList("voice/doom-general-", 12)
  self.earlyClips = self.buildClipList("voice/doom-early-", 5)
  self.midClips = self.buildClipList("voice/doom-mid-", 6)
  self.lateClips = self.buildClipList("voice/doom-late-", 5)
  self.eventClips = self.buildClipList("voice/event-done-", 5)

  self:buildPopup()
end

function timerScreen:preOnEnter()
  if not _G.gameWasPaused then
    -- TODO: Clear already played clips list
    self.clockWidget:setTimer(_G.gameDuration)
    self.clockWidget:setNextEventIn(self:getNextEventTime(true))
    self.clockWidget:setNextDoomIn(self:getNextDoomTime(true))
    _G.isMidEvent = false
  end

  self.clockWidget.displayGroup.y = display.contentCenterY * 0.6 + 450

  _G.musicFile = "Beginning"
  if _G.settingsData.musicOn then
    musicMan:playMusic(_G.musicFile, _G.settingsData.musicVolume / 100)
  end
end

function timerScreen:onEnter()
  self.clockWidget:unpause()

  if _G.settingsData.flashingEventsOn then
    timer.resume(self.flasher)
  else
    timer.pause(self.flasher)
    self.popupBg.fill.effect = ""
  end
end

function timerScreen:onExit()
  self:hideEvent(false)
  _G.musicFile = "LongRoad"
  if _G.settingsData.musicOn then
    musicMan:playMusic(_G.musicFile, _G.settingsData.musicVolume / 100)
  end
  self.clockWidget:pause()
end

function timerScreen:showEvent()
  local transitionTime = 400
  local popup = self.eventPopup
  popup.alpha = 1
  transition.to(popup, { time = transitionTime, y = display.contentCenterY - 250 })
  self.popupShowing = true

  self.eventTitle.text = eventTitles[math.random(#eventTitles)]

  transition.to(self.clockWidget.displayGroup, {
    time = transitionTime,
    y = (display.contentCenterY + 350),
    xScale = 0.45,
    yScale = 0.45
  })

  if _G.settingsData.eventSoundsOn then
    musicMan:playSoundEffect("EventSound.mp3", _G.settingsData.eventVolume / 100)
  end

  _G.isMidEvent = true
  self.clockWidget:setNextEventIn(self:getNextEventTime())
end

function timerScreen:hideEvent(playSound)
  local transitionTime = 400
  local popup = self.eventPopup
  transition.to(popup, { time = transitionTime, y = -display.contentCenterY })
  timer.performWithDelay(transitionTime, function() popup.alpha = 0 end, 1)

  transition.to(self.clockWidget.displayGroup, { time = transitionTime, y = display.contentCenterY * 0.6 + 450, xScale = 1, yScale = 1 })

  if playSound and _G.settingsData.eventSoundsOn then
    self.eventClips = self.playRandomClip(self.eventClips, _G.settingsData.eventVolume / 100)
  end

  -- Always push a little bit after the event
  self.clockWidget:delayEventTime()
  self.clockWidget:delayDoomTime()

  _G.isMidEvent = false
  self.popupShowing = false
end

function timerScreen:DOOM()
  self.clockWidget:setNextDoomIn(self:getNextDoomTime())
  if _G.settingsData.doomQuoteSoundsOn then
    if math.random(1, 5) >= 3 then
      -- Use a general sound
      self.generalClips = self.playRandomClip(self.generalClips, _G.settingsData.doomQuoteVolume / 100)
    else
      -- Use a time specific sound
      if _G.percentTimeRemaining >= 0.66 then
        self.earlyClips = self.playRandomClip(self.earlyClips, _G.settingsData.eventVolume / 100)
      elseif _G.percentTimeRemaining >= 0.33 then
        self.midClips = self.playRandomClip(self.midClips, _G.settingsData.eventVolume / 100)
      else
        self.lateClips = self.playRandomClip(self.lateClips, _G.settingsData.eventVolume / 100)
      end
    end
  end
end

function timerScreen:makeButton(text, textToo, callback, yPos)
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
    fontSize = 72
  })
  maintext.x = btnWidth / 2
  maintext.y = btnHeight * 0.4
  btn.maintext = maintext

  local subtext = display.newText({
    parent = btn,
    text = textToo,
    font = "fonts/LemonMilk.otf",
    fontSize = 72
  })
  subtext.x = btnWidth / 2
  subtext.y = btnHeight * 0.67
  btn.subtext = subtext

  return btn
end

function timerScreen:buildPopup()
  local popup = display.newGroup()
  local popupBg = display.newImage(popup, "images/popup.png")
  popupBg.y = -100
  self.popupBg = popupBg

  self.flasher = timer.performWithDelay(250, function()
    if self.filterOn == false then
      popupBg.fill.effect = "filter.invert"
    else
      popupBg.fill.effect = ""
    end

    self.filterOn = not self.filterOn
  end, -1)
  if not _G.settingsData.flashingEventsOn then
    timer.pause(self.flasher)
  end

  local popupTitleText = display.newText({
    parent = popup,
    text = "WARNING",
    y = -150,
    font = "fonts/Alien-Encounters-Regular.ttf",
    fontSize = 124,
    width = display.contentWidth * 0.7,
    align = "center"
  })
  self.eventTitle = popupTitleText
  local popupActionText = display.newText({
    parent = popup,
    text = "Draw and resolve an event card",
    y = 50,
    font = "fonts/Alien-Encounters-Regular.ttf",
    fontSize = 78
  })

  local widget = require("widget")
  local btn = widget.newButton({
    width = 900,
    height = 275,
    fontSize = 56,
    label = "Tap when resolved",
    font = "fonts/LemonMilk.otf",
    labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1 } },
    defaultFile = "images/paperButtonUp.png",
    overFile = "images/paperButtonDown.png",
    onRelease = function() self:hideEvent(true) end
  })
  btn.x = 0
  btn.y = 270
  popup:insert(btn)

  popup.x = display.contentCenterX
  popup.y = -display.contentCenterY
  popup.alpha = 0
  self.eventPopup = popup
end

function timerScreen:getNextEventTime(firstEvent)
  local lowEnd
  local highEnd
  if _G.settingsData.difficulty == 0 then
    return 60 * 60 * 24 * 365 -- No event difficulty, set the next to a year from now
  elseif _G.settingsData.difficulty == 1 then
      lowEnd = 180 --in seconds (3-5 min)
      highEnd = 300
  elseif _G.settingsData.difficulty == 2 then
      lowEnd = 120 --(2-3 min)
      highEnd = 180
  elseif _G.settingsData.difficulty == 3 then
      lowEnd = 90 --(1.5-2.5 min)
      highEnd = 150
  elseif _G.settingsData.difficulty == 4 then
      lowEnd = 60 --(1-2 min)
      highEnd = 120
  end

  if firstEvent then
    lowEnd = 60
  end

  return math.random(lowEnd , highEnd )
end

function timerScreen:getNextDoomTime(firstDoom)
  local lowEnd = 1
  local highEnd = 3

  if firstDoom then
    return math.random(0, highEnd * 60)
  else
    return math.random(lowEnd * 60, highEnd * 60)
  end
end

return timerScreen

