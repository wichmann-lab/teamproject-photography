-- require 'json'
local json = loadfile("C:/Users/regin/Documents/Studium/Teamprojekt/Teamprojekt Local/Sample Plugins/dummyplugin.lrdevplugin/json.lua")()
--local open = io.open()

local function read_file(path)
    file = io.open( path, "r" ) -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read( "*a" ) -- *a or *all reads the whole file
    --io.close( file )
    return content
end
-- Funktion von externer Quelle, verlinkt im README
local pathOfConfig = "C:/Users/regin/Documents/Studium/Teamprojekt/Teamprojekt Local/Sample Plugins/dummyplugin.lrdevplugin/config.json"
local fileContent = read_file(pathOfConfig);
--local file = json.decode(fileContent);
file:write( "Feed me data!\n" )
    local numbers = {1,2,3,4,5,6,7,8,9}
    file:write( numbers[1], numbers[2], numbers[3], "\n" )
    for _,v in ipairs( numbers ) do
        file:write( v, " " )
        file:write("test")
    end
    file:write( "\nNo more data\n" )
    --io.close( file )
    
    print(fileContent)
