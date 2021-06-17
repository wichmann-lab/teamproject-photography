--============================SDK===============================--
local LrDialogs = import("LrDialogs")
local LrExportSession = import("LrExportSession")
local LrFileUtils = import("LrFileUtils")
local LrFunctionContext = import("LrFunctionContext")
local LrLogger = import("LrLogger")
local LrPathUtils = import("LrPathUtils")
local adjustConfigFile = require("AdjustConfigurationFile")
local configFile = adjustConfigFile.configFile
--============================LOGGER============================--
local logger = LrLogger('ExportLogger')
logger:enable('print')
local debug, info, warn, err, trace = logger:quick('debug', 'info', 'warn', 'err', 'trace' )
--==============================================================--

local ExportPhotos = {}
local imgPreviewPath = LrPathUtils.child(_PLUGIN.path, "Exported Photos ")
if LrFileUtils.exists(imgPreviewPath) ~= true then
    LrFileUtils.createDirectory(imgPreviewPath)
  end
--local photos = catalog.targetPhotos
function ExportPhotos.makeDirectory(new_dir)
    LrFileUtils.createDirectory(new_dir)
end

function ExportPhotos.processRenderedPhotos(photos,folderName)
    LrFunctionContext.callWithContext("export", function(exportContext)

    local exportSession = LrExportSession({
        photosToExport= photos,
        exportSettings = {
            LR_collisionHandling = "rename",
            LR_format = configFile.export_format,
            LR_tokens = "{{image_name}}",
            LR_useWatermark = false,
            LR_export_destinationPathPrefix = imgPreviewPath,
            LR_export_destinationType = "specificFolder",
            LR_export_destinationPathSuffix = folderName
        }
    })
    --local exportParams = exportContext.propertyTable
    --local editedPhotos = exportParams.editedPhotos
    --local exportPath = exportParams.exportPath
   -- local password = exportParams.password

    --logger:info("EditedPhotos: ", editedPhotos )

    local progressScope = LrDialogs.showModalProgressDialog({
        title = "Export in matrix format",
        caption = "Exporting edited photos by TheImageIterator",
        cannotCancel = false,
        functionContext = exportContext
      })
        for index, rendition in exportSession:renditions{ progressScope=progressScope, stopIfCanceled = true } do
            --[[local photo = rendition.photo
            --rendition:waitForRender()
            local photoPath = rendition.destinationPath
            if not rendition.wasSkipped then]]
                local success, pathOrMessage = rendition:waitForRender()
                if success then
                    --LrFileUtils.delete( pathOrMessage )
                end
            --end
        end
    end)
end

return ExportPhotos