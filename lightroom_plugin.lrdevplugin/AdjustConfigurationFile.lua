local LrPathUtils = import 'LrPathUtils'
local LrErrors = import 'LrErrors'
local LrFileUtils = import 'LrFileUtils'
-- local current_dir=io.popen"cd":read'*l'    working directory of LR ist not where the lua scripts are saved
-------------- path information ------------
local home = LrPathUtils.getStandardFilePath("home")
--error(home)
local adjustConfig = {}
-- exist the following directory?
adjustConfig.myPathConfig = home .. "/TheImageIterator/imageIteratorSettings.json"
adjustConfig.myPathConfig = adjustConfig.myPathConfig:gsub("%\\", "/")
if LrFileUtils.exists(adjustConfig.myPathConfig) ~= true then
    LrErrors.throwUserError("Configuration File Error: \nimageIteratorSettings.json is missing. \nCreate file in " .. adjustConfig.myPathConfig)
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
adjustConfig.configFile = json.decode(fileContent); -- configFile can be accessed outside this file for further use


-- function to write into configuration file 
function adjustConfig.write_config()
    local encodeFile = json.encode(adjustConfig.configFile)
    local file = open(adjustConfig.myPathConfig, "w")
    file:write(encodeFile)
    file:close()
end

-------------------------------------------------------------------------

-- function to get keyword value
function adjustConfig.getValue(keyword)
    return adjustConfig.configFile[keyword]
end

return adjustConfig
