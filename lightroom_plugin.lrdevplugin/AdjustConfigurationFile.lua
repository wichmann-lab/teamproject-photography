-- ============================General===============================--
--Lightroom SDK
local LrPathUtils = import "LrPathUtils"
local LrErrors = import "LrErrors"
local LrFileUtils = import "LrFileUtils"
local LrDialogs = import "LrDialogs"
-- Imported files
local arrayCombine = require("DevelopSettingsCombinations")
local json = require("json")
-- Common shortcuts
local home = LrPathUtils.getStandardFilePath("home")
-- ==================================================================--

local adjustConfig = {}

-- checks if the following directory (TheImageIterator) exists and throws an error if not
adjustConfig.myPathConfig = home .. "/TheImageIterator/imageIteratorSettings.json"
adjustConfig.myPathConfig = adjustConfig.myPathConfig:gsub("%\\", "/")
if LrFileUtils.exists(adjustConfig.myPathConfig) == false then
    LrErrors.throwUserError(
        "Configuration File Error: \nimageIteratorSettings.json is missing. \nCreate file in " ..
            adjustConfig.myPathConfig
    )
end

local open = io.open

-- reads a file from an external source
function read_file(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then
        return nil
    end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

-- decodes config.json file to a lua object
local fileContent = read_file(adjustConfig.myPathConfig)
adjustConfig.configFile = json.decode(fileContent) -- configFile can be accessed outside this file for further use
configTable = arrayCombine.getKeys(adjustConfig.configFile) -- 1D table: keywords in configFile
result = false
for key, value in pairs(configTable) do
    if configTable[key] == "Settings" then
        result = true
    end
end
if result == true then
    if next(adjustConfig.configFile.Settings) == nil then
        LrErrors.throwUserError(
            "Caution! \n No initial values in key 'Settings' in configuration file. Add settings to imageIteratorSettings.lua. (See example in README)"
        )
    end
else
    LrErrors.throwUserError(
        "Caution! \n No initial key 'Settings' in configuration file. Add settings to imageIteratorSettings.lua. (See example in README)"
    )
end

-- function to write into the configuration file
function adjustConfig.write_config()
    local encodeFile = json.encode(adjustConfig.configFile)
    local file = open(adjustConfig.myPathConfig, "w")
    file:write(encodeFile)
    file:close()
end

-- function to reload the configuration file
function adjustConfig.reload_config()
    local fileContent = read_file(adjustConfig.myPathConfig)
    adjustConfig.configFile = json.decode(fileContent)
end

-- returns the settings as keys and values in a string
function adjustConfig.overviewSettings(array)
    overview = ""
    for key, v in pairs(array) do
        overview = overview .. key .. ":"
        for w, value in pairs(v) do
            overview = overview .. value .. ","
        end
        overview = overview .. "\n"
    end
    return overview
end

return adjustConfig