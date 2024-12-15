local clockWidget = { }--minute=0, second=0 }
local musicMan = require("musicMan")

local startTime
local currentTime
local nextEventTime = nil
local nextDoomTimer = nil
local pauseTime
local isRunning = false
local timeOverCallbackFired = false
local warningBellRung = false

local warningsAt = {}

function clockWidget:createVisuals(ownerGroup)
	clockWidget.displayGroup = display.newGroup()
	
	startTime = -math.random(999999)

-- Digital Clock
	local timerBackdrop = display.newRect(clockWidget.displayGroup,0,0, 1300, 600)
	timerBackdrop:setFillColor(0.5)
	timerBackdrop.alpha = 0.5
	local timerText = display.newText(
		{
			parent = clockWidget.displayGroup,
			text = "00:00",
			font = "fonts/Alien-Encounters-Solid-Regular.ttf",
			fontSize = 480
		})
	timerText:setFillColor(242/255, 51/255, 47/255)
	
	self.timerBackdrop = timerBackdrop
	self.timerText = timerText

	clockWidget.displayGroup.x = display.contentCenterX
	clockWidget.displayGroup.y = display.contentCenterY * 0.6 + 450

	ownerGroup:insert(clockWidget.displayGroup)
end

function clockWidget:setTimer(numMinutes)
	self:pause()

	self.timeLimit = numMinutes * 60
	if numMinutes < 10 then
		self.timerText.text = "0" .. numMinutes .. ":00"
	else
		self.timerText.text = numMinutes .. ":00"
	end
	
	warningsAt = {
		{ 1 * 60, "voice/1-minutes.mp3" },
		{ 2 * 60, "voice/2-minutes.mp3" },
		{ 3 * 60, "voice/3-minutes.mp3" },
		{ 5 * 60, "voice/5-minutes.mp3" },
		{ 7 * 60, "voice/7-minutes.mp3" }
	}

	if numMinutes >= 10 then
		warningsAt[#warningsAt+1] = { 10 * 60, "voice/10-minutes.mp3" }
	end
	
	if numMinutes >= 15 then
		warningsAt[#warningsAt+1] = { 15 * 60, "voice/15-minutes.mp3" }
	end
	
	startTime = nil
	pauseTime = nil
	timeOverCallbackFired = false
	warningBellRung = false
end

function clockWidget:killCallbacks()
	timeOverCallbackFired = true
	warningBellRung = true
end

function clockWidget:pause()
	local oldValue = isRunning
	isRunning = false
	pauseTime = currentTime
	_G.gameWasPaused = true
	return oldValue
end

function clockWidget:unpause()
	_G.gameWasPaused = false
	isRunning = true
end

function clockWidget:setNextEventIn(numSeconds)
	local totalSecondsRunning = 0
	if currentTime ~= nil and startTime ~= nil then
		totalSecondsRunning = (currentTime - startTime)/1000
	end
	nextEventTime = totalSecondsRunning + numSeconds
	
	local totalClockSeconds = clockWidget.timeLimit
	if totalClockSeconds - nextEventTime <= 45 then
		nextEventTime = nil
	end
end

function clockWidget:setNextDoomIn(numSeconds)
	local totalSecondsRunning = 0
	if currentTime ~= nil and startTime ~= nil then
		totalSecondsRunning = (currentTime - startTime)/1000
	end
	nextDoomTimer = totalSecondsRunning + numSeconds
	
	local totalClockSeconds = clockWidget.timeLimit
	if totalClockSeconds - nextDoomTimer <= 15 then
		nextDoomTimer = nil
	end
end

function clockWidget:delayEventTime()
	if nextEventTime ~= nil then
		-- Delay 2 seconds and try again then
		nextEventTime = nextEventTime + 2
	end
end

function clockWidget:delayDoomTime()
	if nextDoomTimer ~= nil then
		-- Delay 5 seconds and try again then
		nextDoomTimer = nextDoomTimer + 5
	end
end

-- Update loop
local function onEnterFrame(event)
	if isRunning ~= true then
		return
	end
	
	if startTime == nil then
		startTime = event.time
	end
	
	currentTime = event.time
	
	if pauseTime ~= nil then
		startTime = startTime + (currentTime - pauseTime)
		pauseTime = nil
	end
	
	local totalSecondsRunning = (currentTime - startTime)/1000

	if clockWidget.timeLimit ~= nil and totalSecondsRunning > clockWidget.timeLimit then
		totalSecondsRunning = clockWidget.timeLimit
		
		if timeOverCallbackFired == false then
			timeOverCallbackFired = true
			
			clockWidget:pause()
			if clockWidget.timeOverCallback ~= nil then
				clockWidget.timeOverCallback()
			end
		end
	end
	
	if clockWidget.timeLimit ~= nil then
		local totalClockSeconds = clockWidget.timeLimit
		local remainingTime = totalClockSeconds - totalSecondsRunning
		local displayMinute = remainingTime/60
		local displaySecond = remainingTime - math.floor(displayMinute) * 60
		displayMinute = math.floor(displayMinute)
		displaySecond = math.ceil(displaySecond)
		if displaySecond == 60 then
			displayMinute = displayMinute+1
			displaySecond = 0
		end
		_G.percentTimeRemaining = remainingTime / totalClockSeconds
		
		if displayMinute < 10 then
			clockWidget.timerText.text = "0" .. displayMinute
		else
			clockWidget.timerText.text = displayMinute
		end
		if displaySecond < 10 then
			clockWidget.timerText.text = clockWidget.timerText.text .. ":0" .. displaySecond
		else
			clockWidget.timerText.text = clockWidget.timerText.text .. ":" .. displaySecond
		end
		
		if totalSecondsRunning ~= nil and nextEventTime ~= nil and remainingTime ~= nil then
			print(totalSecondsRunning .. " : " .. nextEventTime .. " : " .. remainingTime)
		end
		if nextEventTime ~= nil and totalSecondsRunning >= nextEventTime and remainingTime > 45 then
			if _G.isMidEvent then
				clockWidget:delayEventTime()
			else
				nextEventTime = nil
				if clockWidget.eventCallback ~= nil then
					clockWidget.eventCallback()
				end
			end
		end
		
		if nextDoomTimer ~= nil and totalSecondsRunning >= nextDoomTimer and remainingTime > 15 then
			if _G.isMidEvent then
				clockWidget:delayDoomTime()
			else
				nextDoomTimer = nil
				if clockWidget.doomCallback ~= nil then
					clockWidget.doomCallback()
				end
			end
		end
		
		if _G.settingsData.warningSoundsOn then
			if #warningsAt > 0 and remainingTime <= warningsAt[#warningsAt][1] then
				musicMan:playVoiceOver(warningsAt[#warningsAt][2], _G.settingsData.warningVolume/100)
				table.remove(warningsAt)
			end
		end
	end
end

Runtime:addEventListener("enterFrame", onEnterFrame)

return clockWidget