--============================SDK===============================--
local ExportPhotos = require 'ExportPhotos'
require 'ExportDialogs'
--==============================================================--

--logger:enable("logfile")

return {
    hideSections = { 'video', 'watermarking' }, -- exclude from displaying in the export dialog
    allowFileFormats = nil, -- all available
    allowColorSpaces = nil, -- all available
    hidePrintResolution = true, -- sizing section is only shown in pixel units
    canExportVideo = false,

    startDialog = ExportDialogs.startDialog,
    endDialog = ExportDialogs.endDialog,
    sectionsForTopOfDialog = ExportDialogs.sectionsForTopOfDialog,
    --processRenderedPhotos = ExportPhotos.processRenderedPhotos,
}