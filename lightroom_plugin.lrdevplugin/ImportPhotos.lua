local adjustConfigFile = require("AdjustConfigurationFile")
local configFile = adjustConfigFile.configFile

local ImportPhotos = {}

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
    photo:quickDevelopAdjustImage("Contrast", configFile.contrast)
    photo:quickDevelopAdjustImage("Highlights", configFile.highlights)
    photo:quickDevelopAdjustImage("Saturation", configFile.saturation)
end

return ImportPhotos
