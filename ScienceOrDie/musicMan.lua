local musicMan = {}

local fileFormat = ".ogg"
if system.getInfo("platformName") == "iPhone OS" then
	fileFormat = ".m4a"
end
-- HACK TODO REPLACE MIKE
--fileFormat = ".mp3"

local MusicChannelOne = 32
local MusicChannelTwo = 31
local VoiceChannel = 30
local SoundscapeChannel = 29
local lastUsedMusicChannel = MusicChannelTwo
local SfxChannel = 1

function musicMan:playMusic(filename, volume)
	local targetChannel = MusicChannelOne
	if lastUsedMusicChannel == targetChannel then
		targetChannel = MusicChannelTwo
	end
	lastUsedMusicChannel = targetChannel
	self:stopMusic()
	audio.setVolume( volume, { channel=targetChannel } )
	
	local music = audio.loadStream("audio/" .. filename .. fileFormat)
	self.currentMusicChannel = audio.play(music, { loops=-1, fadein=1000, channel=targetChannel })
end

function musicMan:setMusicVolume(volume)
	if self.currentMusicChannel ~= nil then
		audio.setVolume( volume, { channel=self.currentMusicChannel } )
	end
end


function musicMan:stopMusic()
	if self.currentMusicChannel ~= nil then
		local oldChannel = self.currentMusicChannel
		self.currentMusicChannel = nil
		audio.fadeOut({ channel=oldChannel, time=1000 })
	end
end

local function voiceClipComplete()
	musicMan.currentVoiceChannel = nil
	
	if musicMan.onVoiceClipCompleteCallback ~= nil then
		musicMan.onVoiceClipCompleteCallback()
	end
end

--Returns the length of the voice over clip
function musicMan:playVoiceOver(voiceFileName, volume)
	self:stopCurrentVoiceOver()
	
	audio.setVolume( volume, { channel=VoiceChannel } )

	local voiceClip = audio.loadSound("audio/" .. voiceFileName)
	self.currentVoiceClip = voiceClip
	self.currentVoiceChannel = audio.play(voiceClip, { onComplete=voiceClipComplete, channel=VoiceChannel })
	return audio.getDuration(voiceClip)
end

function musicMan:stopCurrentVoiceOver()
	if self.currentVoiceChannel ~= nil then
		audio.stop(self.currentVoiceChannel)
		self.currentVoiceChannel = nil
		audio.dispose(self.currentVoiceClip)
	end
end

function musicMan:playSoundScape(filename, seekTo)
	self:stopCurrentSoundScape()
	
	audio.setVolume( 1, { channel=SoundscapeChannel } )
	
	local fadeTime = 0
	local sfx = audio.loadStream("audio/" .. filename)
	if seekTo ~= nil then
		audio.seek(seekTo, sfx)
		fadeTime = 1500
	end
	self.currentSoundScapeChannel = audio.play(sfx, { fadeIn=fadeTime, channel=SoundscapeChannel })
end

function musicMan:stopCurrentSoundScape()
	if self.currentSoundScapeChannel ~= nil then
		audio.stop(self.currentSoundScapeChannel)
		self.currentSoundScapeChannel = nil
	end
end

function musicMan:playSoundEffect(filename, volume)
	local sfx = audio.loadStream("audio/" .. filename)
	audio.setVolume( volume, { channel=SfxChannel } )
	audio.play(sfx, { channel=SfxChannel })
end

function musicMan:pauseAll()
	audio.pause()
end

function musicMan:unpauseAll()
	audio.resume()
end

return musicMan