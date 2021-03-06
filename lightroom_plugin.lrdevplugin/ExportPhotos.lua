-- ============================General===============================--
--Lightroom SDK
local LrExportSession = import("LrExportSession")
local LrFileUtils = import("LrFileUtils")
local LrFunctionContext = import("LrFunctionContext")
local LrPathUtils = import("LrPathUtils")
-- Imported files
local adjustConfigFile = require("AdjustConfigurationFile")
-- Common shortcuts
local configFile = adjustConfigFile.configFile
-- ==================================================================--

local ExportPhotos = {}

--checks whether the folder for the edited photos exists
local imgPreviewPath = LrPathUtils.child(_PLUGIN.path, "Exported Photos ")
if LrFileUtils.exists(imgPreviewPath) ~= true then
    LrFileUtils.createDirectory(imgPreviewPath)
end

-- creates an exportsession with settings for the exportsession
-- exports given photos into the folder with the fiven folderName
function ExportPhotos.processRenderedPhotos(photos, folderName)
    LrFunctionContext.callWithContext(
        "export",
        function(exportContext)
            local exportSession =
                LrExportSession(
                {
                    photosToExport = photos,
                    exportSettings = {
                        LR_collisionHandling = "skip",
                        LR_format = configFile.export_format,
                        LR_tokens = "{{image_name}}",
                        LR_useWatermark = false,
                        LR_export_destinationPathPrefix = imgPreviewPath,
                        LR_export_destinationType = "specificFolder",
                        LR_export_destinationPathSuffix = folderName
                    }
                }
            )
            for index, rendition in exportSession:renditions {stopIfCanceled = true} do
                local success, pathOrMessage = rendition:waitForRender()
            end
        end
    )
end

return ExportPhotos
