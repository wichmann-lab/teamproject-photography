-- find directory
-- package.path = package.path .. ";../?.lua"
-- local json = require("json")
local myPathLua = "D:/Uni/teamproject-photography/lightroom_plugin.lrdevplugin/json.lua"
local myPathConfig = "D:/Uni/teamproject-photography/lightroom_plugin.lrdevplugin/configurationFile.json"
local json = loadfile(myPathLua)()
local open = io.open

local adjustConfig= {}
-- function to read a file
-- function from extern source
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
configFile = json.decode(fileContent);  -- configFile can be accessed outside this file for further use
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

-- option 2
function adjustConfig.write_config()
    local encodeFile = json.encode(configFile)
    local file = open(myPathConfig,"w")
    file:write(encodeFile)
    file:close()
end

-------------------------------------------------------------------------

-- function to get keyword value
function adjustConfig.getValue(keyword)
    return json.encode(configFile[keyword])
end

-- os.exit(0)

print(adjustConfig.getValue(contrast))

return adjustConfig