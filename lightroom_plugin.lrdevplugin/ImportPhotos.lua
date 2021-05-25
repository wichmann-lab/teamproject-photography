local LrCatalog = import 'LrCatalog'
local LrCollection = import 'LrCollection'
local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'

local catalog = LrApplication.activeCatalog()
--LrCatalog.triggerImportUI(configFile.path)

function importSelectedPhotos ()
    LrTasks.startAsyncTask(function()
        catalog:withWriteAccessDo("Ein Test", function ()
            local selectedPhotos = catalog.targetPhoto
        end)
    end)
end
importSelectedPhotos()