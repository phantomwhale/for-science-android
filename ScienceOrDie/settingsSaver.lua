local settingsData = require("settingsData")
local json = require("json")
local settingsFile = "settings.data"

local settingsSaver = {}

function settingsSaver:save()
  local path = system.pathForFile(settingsFile, system.DocumentsDirectory)
  local file = io.open(path, "w")
  if file then
    local contents = json.encode(_G.settingsData)
    file:write(contents)
    io.close(file)
  end
end

function settingsSaver:load()
  local path = system.pathForFile(settingsFile, system.DocumentsDirectory)
  local contents = ""
  local file = io.open(path, "r")
  if file then
    -- read all contents of file into a string
    local contents = file:read("*a")
    _G.settingsData = json.decode(contents);
    io.close(file)
  end

  -- HACK HACK HACK
  -- Replaced toggles with sliders, now these should always be true but I don't want
  --  to do the surgery to remove them from everywhere
  _G.settingsData.musicOn = true
  _G.settingsData.warningSoundsOn = true
  _G.settingsData.eventSoundsOn = true
  _G.settingsData.gameOverSoundsOn = true
  _G.settingsData.doomQuoteSoundsOn = true
end

return settingsSaver