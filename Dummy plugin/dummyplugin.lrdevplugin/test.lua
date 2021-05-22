-- require 'json'
local json = loadfile("C:/Users/regin/Documents/Studium/Teamprojekt/Teamprojekt Local/Sample Plugins/dummyplugin.lrdevplugin/json.lua")()
local open = io.open

local function read_file(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end
-- Funktion von externer Quelle, verlinkt im README
local fileContent = read_file("C:/Users/regin/Documents/Studium/Teamprojekt/Teamprojekt Local/Sample Plugins/dummyplugin.lrdevplugin/config.lua"),
-- print (fileContent);
-- print (fileContent);
--local configFile = json.decode(fileContent); --
--local file = io.open( filePath, "r" ),
--local testVar = json.encode('[1,2,3,{"x":10}]')

fileContent:write( "Feed me data!\n" )
    local numbers = {1,2,3,4,5,6,7,8,9}
    fileContent:write( numbers[1], numbers[2], numbers[3], "\n" )
    for _,v in ipairs( numbers ) do
        fileContent:write( v, " " )
    end
    fileContent:write( "\nNo more data\n" )
    --io.close( file )