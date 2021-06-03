local adjustConfigFile = require("AdjustConfigurationFile")

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
    photo:quickDevelopAdjustImage("Contrast", adjustConfigFile.getValue("contrast"))
    photo:quickDevelopAdjustImage("Highlights", adjustConfigFile.getValue("highlights"))
    photo:quickDevelopAdjustImage("Saturation", adjustConfigFile.getValue("saturation"))
end

return ImportPhotos
