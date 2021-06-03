---@diagnostic disable-next-line: undefined-global
local LrLogger = import 'LrLogger'
---@diagnostic disable-next-line: undefined-global
local LrTasks = import 'LrTasks'
---@diagnostic disable-next-line: undefined-global
local LrApplication = import 'LrApplication'
---@diagnostic disable-next-line: undefined-global
local LrDialogs = import 'LrDialogs'
---@diagnostic disable-next-line: undefined-global
local LrView = import 'LrView'
---@diagnostic disable-next-line: undefined-global
local LrFunctionContext = import 'LrFunctionContext'
---@diagnostic disable-next-line: undefined-global
local LrFileUtils = import 'LrFileUtils'
local adjustConfigFile = require("AdjustConfigurationFile")

--Logger for this file 
--importLogger = LrLogger('ImportPhotos')
--importLogger:enable("logfile")

local ImportPhotos= {}

--[[ function importSelected, selects photos from the catalog and calls the funcion editPhotos()
function ImportPhotos.importSelected ()
    LrTasks.startAsyncTask( function()
        local catalog = LrApplication.activeCatalog()
        local targetPhotos = catalog:getTargetPhotos()
        if 'ok' == LrDialogs.confirm('Are you sure?', 'Do you want to edit the selected ' .. #(catalog.targetPhotos) .. ' photo(s)?') then
            for i, photo in ipairs(catalog.targetPhotos) do
                ImportPhotos.editPhotos(photo)
            end
        end
    end)
end
]]

-- function for editing each photo 
function ImportPhotos.editPhotos(photo)
    photo:quickDevelopAdjustImage("Contrast",   adjustConfigFile.getValue("contrast"))
    photo:quickDevelopAdjustImage("Highlights", adjustConfigFile.getValue("highlights"))
    photo:quickDevelopAdjustImage("Saturation", adjustConfigFile.getValue("saturation"))
end

function ImportPhotos.createdirectory()
    LrFileUtils.createDirectory("/Users/ngocdonganhvo/Documents/GitHub/teamproject-photography/lightroom_plugin.lrdevplugin/testDirectory")
    
end
-- ImportPhotos.importSelected()
return ImportPhotos