-- find directory
package.path = package.path .. ";./\\?.lua"
local json = require("json")
-- local json = loadfile("D:/Uni/SS21/Teamprojekt/ProjectFiles/hello.lrdevplugin/json.lua")()
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

-- tests for functions from json.lua
local fileContent = read_file("configurationFile.json")
local configFile = json.decode(fileContent);

-- adds new keywords to config.json

local result = json.encode(configFile)

-- writes keywords to config.json
local file = open("configurationFile.json", "w")
file:write( result )
file:close()
os.exit(0)