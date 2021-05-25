-- find directory
package.path = package.path .. ";./\\?.lua"
local json = require("json")
-- local json = loadfile("absolute path of json.lua here")()
local open = io.open

-- function to read a file
-- function from extern source
local function read_file(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

-- decodes config.json file to a lua object
local fileContent = read_file("configurationFile.json")
configFile = json.decode(fileContent);  -- configFile can be accessed outside this file for further use

-- function to add new keyword to config.json
function write_config(keyword,value)
    configFile[keyword] = value
    local encodeFile = json.encode(configFile)
    local file = open("configurationFile.json","w")
    file:write(encodeFile)
    file:close()
end

-- option 2
function write_config()
    local encodeFile = json.encode(configFile)
    local file = open("configurationFile.json","w")
    file:write(encodeFile)
    file:close()
end

-------------------------------------------------------------------------


-- adds new keywords to config.json
configFile.contrast = {20, 50}
local result = json.encode(configFile)

-- writes keywords to config.json
local file = open("configurationFile.json", "w")
file:write( result )
file:close()
os.exit(0)