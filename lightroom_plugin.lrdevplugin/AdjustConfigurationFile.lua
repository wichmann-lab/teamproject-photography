local LrPathUtils = import 'LrPathUtils'
-- local current_dir=io.popen"cd":read'*l'    working directory of LR ist not where the lua scripts are saved
-------------- path information ------------
local home = LrPathUtils.getStandardFilePath("home")
local myPathConfig = home .. "/lrplugin/configurationFile.json"
local json = require("json")
local open = io.open
-- error(home)


local adjustConfig= {}
-- function to read a file from extern source
function read_file(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

-- decodes config.json file to a lua object
-- local fileContent = read_file("configurationFile.json")
local fileContent = read_file(myPathConfig)
adjustConfig.configFile = json.decode(fileContent);  -- configFile can be accessed outside this file for further use
-- print(configFile.contrast[2])
-- function to add new keyword to config.json
--[[function write_config(keyword,value)
    configFile[keyword] = value
    local encodeFile = json.encode(configFile)
    -- local file = open("configurationFile.json","w")
    local file = open(myPathConfig,"w")
    file:write(encodeFile)
    file:close()
end]]

-- function to write into configuration file
function adjustConfig.write_config()
    local encodeFile = json.encode(adjustConfig.configFile)
    local file = open(myPathConfig,"w")
    file:write(encodeFile)
    file:close()
end

-------------------------------------------------------------------------

-- function to get keyword value
function adjustConfig.getValue(keyword)
    return adjustConfig.configFile[keyword]
end

-- os.exit(0)
return adjustConfig