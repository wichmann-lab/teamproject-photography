local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrFunctionContext = import 'LrFunctionContext'
local LrFileUtils = import 'LrFileUtils'
local adjustConfigFile = require("AdjustConfigurationFile")

--Logger for this file 
--importLogger = LrLogger('ImportPhotos')
--importLogger:enable("logfile")


local ImportPhotos= {}

local configFile = adjustConfigFile.configFile

-- function importSelected, selects photos from the catalog and calls the funcion editPhotos()
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
-- function for editing each photo
function ImportPhotos.editPhotos(photo)
    photo:quickDevelopAdjustImage("Contrast",adjustConfigFile.getValue(contrast[2]))
    -- maybe default value is 5, adjustConfigFile.getValue(contrast[2]) = null
    photo:quickDevelopAdjustImage("Highlights", adjustConfigFile.getValue(highlights))
    photo:quickDevelopAdjustImage("Saturation", 100)
end
-- ImportPhotos.importSelected()
return ImportPhotos