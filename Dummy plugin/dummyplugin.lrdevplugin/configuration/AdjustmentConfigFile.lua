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
local fileContent = read_file("config.json")
local configFile = json.decode(fileContent);
print(configFile.test2[2])
print(configFile.test)

-- adds new keywords to config.json
configFile.suzhengyu = 10
configFile.test = 5
configFile.test2 = {"1","2"}
configFile.test3= "Das ist ein neuerTest"
local foo = json.encode(configFile)

-- writes keywords to config.json
local file = open("config.json", "w")
file:write( foo )
file:close()
os.exit(0)

-- configFile:write( "Feed me data!\n" )
--    local numbers = {1,2,3,4,5,6,7,8,9}
--    os.exit(0)
--    fileContent:write( numbers[1], numbers[2], numbers[3], "\n" )
--    for _,v in ipairs( numbers ) do
--        fileContent:write( v, " " )
--    end
--    fileContent:write( "\nNo more data\n" )
--    io.close( file )