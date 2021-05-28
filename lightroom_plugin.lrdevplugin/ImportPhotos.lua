local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrFunctionContext = import 'LrFunctionContext'
local LrFileUtils = import 'LrFileUtils'

--Logger for this file 
--importLogger = LrLogger('ImportPhotos')
--importLogger:enable("logfile")


ImportPhotos= {}
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
    photo:quickDevelopAdjustImage("Contrast", 100)
    photo:quickDevelopAdjustImage("Highlights", 100)
    photo:quickDevelopAdjustImage("Saturation", 100)
end
ImportPhotos.importSelected()
