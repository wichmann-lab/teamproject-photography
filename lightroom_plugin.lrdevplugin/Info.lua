return {
    LrSdkVersion = 9.0,
    LrToolkitIdentifier = "com.adobe.lightroom.sdk.teamprojectPlugin",
    LrPluginName = "Teamprojekt Plugin",

LrLibraryMenuItems={
        {
            title= "Teamprojekt Plugin Import",
            file ="ImportPhotos.lua",
            enabledWhen = 'photosAvailable',
        },
    }
}
