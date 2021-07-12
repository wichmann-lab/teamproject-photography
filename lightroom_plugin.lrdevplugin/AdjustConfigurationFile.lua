local LrPathUtils = import "LrPathUtils"
local LrErrors = import "LrErrors"
local LrFileUtils = import "LrFileUtils"
local LrDialogs = import "LrDialogs"
-- local current_dir=io.popen"cd":read'*l'    working directory of LR ist not where the lua scripts are saved
-------------- path information ------------
local home = LrPathUtils.getStandardFilePath("home")
--error(home)
local adjustConfig = {}
local arrayCombine = require("arrayCombine")
-- exist the following directory?
adjustConfig.myPathConfig = home .. "/TheImageIterator/imageIteratorSettings.json"
adjustConfig.myPathConfig = adjustConfig.myPathConfig:gsub("%\\", "/")
if LrFileUtils.exists(adjustConfig.myPathConfig) == false then
    LrErrors.throwUserError(
        "Configuration File Error: \nimageIteratorSettings.json is missing. \nCreate file in " ..
            adjustConfig.myPathConfig
    )
end
local json = require("json")

local open = io.open

-- function to read a file from extern source
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
-- local fileContent = read_file("configurationFile.json")
local fileContent = read_file(adjustConfig.myPathConfig)
adjustConfig.configFile = json.decode(fileContent) -- configFile can be accessed outside this file for further use
configTable = arrayCombine.getKeys(adjustConfig.configFile) -- 1D table: keywords in configFile
result = 0
for key, value in pairs(configTable) do
    if configTable[key] == "Settings" then
        result = 1
    end
end

if result == 1 then
    if next(adjustConfig.configFile.Settings) == nil then
        LrErrors.throwUserError(
            "Caution! \n No initial settings in configuration file. Add settings to imageIteratorSettings.lua. (See example in README)"
        )
    end
else
    LrErrors.throwUserError(
        "Caution! \n No initial settings in configuration file. Add settings to imageIteratorSettings.lua. (See example in README)"
    )
end

-- function to write into configuration file
function adjustConfig.write_config()
    local encodeFile = json.encode(adjustConfig.configFile)
    local file = open(adjustConfig.myPathConfig, "w")
    file:write(encodeFile)
    file:close()
end

-- function to reload configuration file
function adjustConfig.reload_config()
    local fileContent = read_file(adjustConfig.myPathConfig)
    adjustConfig.configFile = json.decode(fileContent)
end

function adjustConfig.configFileNil()
    configTable = arrayCombine.getKeys(adjustConfig.configFile)
    result = 0
    settings = adjustConfig.configFile.Settings
    for key, value in ipairs(configTable) do
        if value == "Settings" then
            result = 1
        end
    end
    --error(result)
    if (adjustConfig.configFile.Settings == nil and result == 1) or result == 0 then
        LrDialogs.showError(
            "Caution! \n No initial settings in configuration file. Add settings to imageIteratorSettings.lua. (See example in README)"
        )
    end
end

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

-------------------------------------------------------------------------

-- function to get keyword value
function adjustConfig.getValue(keyword)
    return adjustConfig.configFile[keyword]
end

return adjustConfig
