local LrDialogs = require 'LrDialogs'

MyDummyPluginExportItem = {}
    function MyDummyPluginExportItem.showModalDialog()
    LrDialogs.message("ExportMenuItem Selected", "Dummy Plugin", "info")
end

MyDummyPluginExportItem.showModalDialog()