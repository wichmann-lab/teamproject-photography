return {
    LrSdkVersion = 9.0,
    LrToolkitIdentifier = "com.adobe.lightroom.sdk.dummyplugin",
    LrPluginName = "Dummy Plugin",


    LrExportMenuItems = {
        title = "Dummy Plugin Exp", -- The display text for the menu item
        file = "ExportMenuItem.lua", -- The script that runs when the item is selected
    },

    LrLibraryMenuItems = {
        {
            title = "Dummy Plugin Lib", -- The display text for the menu item
            file = "LibraryMenuItem.lua", -- The script that runs when the item is selected
        },
        {
            title="Dummy Plugin with Radio Button", -- The display text for the menu item
            file="LibraryMenuItemRadioButton.lua",
        }
    }

}
