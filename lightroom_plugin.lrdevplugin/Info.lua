return {
    LrSdkVersion = 9.0,
    LrToolkitIdentifier = "com.adobe.lightroom.sdk.theImageIterator",
    LrPluginName = "The Image Iterator - Plug-in",

LrLibraryMenuItems={

    {
        title= "The Image Iterator",
        file ="LibraryMenuItemPluginUI.lua",
    },
    },
LrExportMenuItem = {
    title = "Export Service for the Image Iterator", -- this string appears as the Export destination
    file = "ExportPhotos.lua", -- the service definition script
    },
}
