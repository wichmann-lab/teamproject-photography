-- ============================General===============================--
--Lightroom SDK
local LrFunctionContext = import "LrFunctionContext"
local LrBinding = import "LrBinding"
local LrDialogs = import "LrDialogs"
local LrView = import "LrView"
local LrTasks = import "LrTasks"
local LrColor = import "LrColor"
local LrProgressScope = import "LrProgressScope"
local LrApplication = import "LrApplication"
-- Imported files
local exportPhotos = require("ExportPhotos")
local adjustConfigFile = require("AdjustConfigurationFile")
local combine = require("arrayCombine")
-- Common shortcuts
local configFile = adjustConfigFile.configFile
local catalog = LrApplication.activeCatalog()
local targetPhotos = catalog.targetPhotos
local targetPhotosCopies = targetPhotos
ArraySettings = configFile.Settings
developSettingsTable = {
    "Exposure",
    "Contrast",
    "Highlights",
    "Shadows",
    "Whites",
    "Blacks",
    "Clarity",
    "Vibrance",
    "Saturation"
}
-- Initial values
showSuccess = true
observerFieldSetting = 0
black = LrColor(0, 0, 0)
red = LrColor(1, 0, 0)
exists = false 
-- ==================================================================--


-- Updates settings in UI after configuration file is modified
function updateSettings()
    keyTable = combine.getKeys(ArraySettings)
    combinedArray = combine.getCombinedArray(ArraySettings)
    settingsTable = combine.getSettingsTable(combinedArray)
    times = combine.getTimesOfCombinations(ArraySettings)
    overview = adjustConfigFile.overviewSettings(ArraySettings)
end

-- isAvailable() checks whether a setting from the configuration file is not available
-- throws an error in the event of impermissible inputs
function isAvailable()
    for key, val in pairs(keyTable) do
        val = val:lower()
        val = val:gsub("^%l", string.upper)
        available = true
        for index, value in ipairs(developSettingsTable) do
            if value ~= val then
                available = false
            else
                available = true
                break
            end
        end
        if available == false then
            return false
        end
    end
    return true
end

-- Edits selected photos if all settings are available
-- quit processing if progress is canceled (via X)
-- exports edited photos into the folder
function editPhotos(photos, keyTable, settingsTable)
    if isAvailable() then
        for index, data in ipairs(settingsTable) do
            if progressBar:isCanceled() then
                showSuccess = false
                break
            end
            result = editSinglePhoto(keyTable, photos, data)
            exportPhotos.processRenderedPhotos(result, folderName)
            folderName = ""
            for p, picture in pairs(result) do
                for key, value in pairs(data) do
                    picture:quickDevelopAdjustImage(keyTable[key], 0) -- reset values for further editing
                end
            end
        end
    else
        showSuccess = false
        LrDialogs.showError(
            "\nUnavailable setting(s) in imageIteratorSettings.json! Please change the setting(s) in " ..
                adjustConfigFile.myPathConfig .. "\nand reload the TheImageIterator Plug-in."
        )
    end
    progressBar:done()
end

-- edits each photo with a specific settings combination
-- helper function for editPhotos()
-- sets folderName according to the settings combination 
function editSinglePhoto(keyTable, photos, data)
    for p, photo in pairs(photos) do
        if progressBar:isCanceled() then -- cancel progress in catalog (via X)
            break
        end
        folderName = ""
        for key, value in pairs(data) do
            photo:quickDevelopAdjustImage(keyTable[key], tonumber(value))
            progressBar:setPortionComplete(count, times * #targetPhotosCopies)
            folderName = folderName .. keyTable[key] .. value
        end
        count = count + 1
    end
    return photos
end

--resets values in the configuration file
function resetConfigSettings()
    for key, value in pairs(keyTable) do
        configFile.Settings[value] = {0, 0, 0}
        adjustConfigFile.write_config()
    end
end

updateSettings()

local function main()
    -- Display dialog box
    LrFunctionContext.callWithContext(
        "showcustomDialog",
        function(context) -- function-context call for property table (observable)
            local propertyTable = LrBinding.makePropertyTable(context)
            -- properties for binding the UI to the configuration file
            propertyTable.myObservedText = overview
            propertyTable.myObservedField1 = observerFieldSetting
            propertyTable.myObservedField2 = observerFieldSetting
            propertyTable.myObservedField3 = observerFieldSetting
            propertyTable.buttonEnabled = true

            -- create UI objects
            local f = LrView.osFactory() -- obtain view factory object
            fieldSettingValue1 =
                f:edit_field {
                place_horizontal = 0.6,
                width_in_digits = 5,
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings[keyTable[1]][1],
                bind = LrView.bind("observerFieldSetting")
            }

            fieldSettingValue2 =
                f:edit_field {
                place_horizontal = 0.6,
                width_in_digits = 5,
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings[keyTable[1]][2],
                bind = LrView.bind("observerFieldSetting")
            }
            fieldSettingValue3 =
                f:edit_field {
                place_horizontal = 0.6,
                width_in_digits = 5,
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings[keyTable[1]][3],
                bind = LrView.bind("observerFieldSetting")
            }

            fieldSettingText =
                f:edit_field {
                width_in_chars = 13,
                immediate = true,
                value = keyTable[1]
            }
            showValue_st =
                f:static_text {
                --
                title = propertyTable.myObservedText,
                text_color = red,
                width = 400,
                height = 200
            }

            pathDisplayConfigFile =
                f:static_text {
                title = "Absolute Path (ConfigFile): \n" .. adjustConfigFile.myPathConfig,
                text_color = black,
            }
            local updateOverviewSettings = function()
                showValue_st.title = overview
                showValue_st.text_color = red
            end
            -- observer for binding the UI to the configuration file
            propertyTable:addObserver("myObservedText", updateOverviewSettings)
            propertyTable:addObserver("myObservedField1", updateOverviewSettings)
            propertyTable:addObserver("myObservedField2", updateOverviewSettings)
            propertyTable:addObserver("myObservedField3", updateOverviewSettings)

            

            local contents =
                f:column {
                bind_to_object = propertyTable, -- bind propertyTable
                spacing = f:control_spacing(),
                f:group_box{
                    title = "Get started with the Plug-in",
                    text_color = LrColor("blue"),
                    font = "<system/bold>",
                    f:row{
                    f:static_text{                    
                        title = "Click here to get information about the UI",
                        text_color = black
                    },
                f:push_button{
                    title = "SUPPORT",
                    action = function ()
                        LrDialogs.message(
                            "THE IMAGE ITERATOR \n - Start editing all your photographs! - ",
                            "- ADD-Button -\nAdd settings and different values for those. The selected photographs will be edited with all combinations of settings and values.\n- HELP-Button -\nOpens window, shows which settings are available.\n- SAVE AND EDIT-Button -\nInitiate the editing and exporting progress.\n- RESET-Button -\nReset the values of all settings in the configuration file to 0.\n- CANCEL PROGRESS AND EXIT-Button -\nCancel the editing and exporting progress (alternative: via X at the right end of the progress bar in the catalog window), Plug-in will be closed.\n- EXIT-Button -\nClose the Plug-in window.\n- Path to ConfigFile -\nDisplays the path where the configuration file should be or is.\n- Overview Develop Settings -\nDisplays all settings and values, that were initially in the configuration file or added via ADD-Button.", "info")                       end
                }
            }
                },
                f:group_box {
                    title = "Path of ConfigFile",
                    font = "<system/bold>",
                    pathDisplayConfigFile
                },
                f:row {
                    f:group_box {
                        title = "Add and change settings",
                        font = "<system/bold>",
                        f:row {
                            f:row {
                                fieldSettingText,
                                fieldSettingValue1,
                                fieldSettingValue2,
                                fieldSettingValue3
                            },
                            f:push_button {
                                title = "ADD",
                                action = function() -- adds setting to configuration file after pushing the "ADD"-Button
                                    fieldSettingText.value = fieldSettingText.value:lower()
                                    fieldSettingText.value = fieldSettingText.value:gsub("^%l", string.upper)
                                    for index, value in ipairs(developSettingsTable) do
                                        if value == fieldSettingText.value then
                                            exists = true
                                        end
                                    end
                                    if exists == true then
                                        configFile.Settings[fieldSettingText.value] = {
                                            fieldSettingValue1.value,
                                            fieldSettingValue2.value,
                                            fieldSettingValue3.value
                                        }
                                        adjustConfigFile.write_config()
                                        configFile = adjustConfigFile.configFile
                                        ArraySettings = configFile.Settings
                                    else
                                        LrDialogs.showError(
                                            "Unavailable Setting! Please check the given list in README or HELP!"
                                        )
                                    end
                                    updateSettings()
                                    configFile = adjustConfigFile.configFile
                                    -- Updating UI
                                    showValue_st.text_color = black
                                    propertyTable.myObservedText = fieldSettingText.value
                                    propertyTable.myObservedField1 = fieldSettingValue1.value
                                    propertyTable.myObservedField2 = fieldSettingValue2.value
                                    propertyTable.myObservedField3 = fieldSettingValue3.value
                                end
                            },
                            f:push_button {
                                title = "HELP",
                                action = function()
                                    LrDialogs.message(
                                        "The following editing settings are available:",
                                        " Exposure \n Contrast \n Highlights \n Shadows \n Whites \n Blacks \n Clarity \n Vibrance \n Saturation",
                                        "info"
                                    )
                                end
                            }
                        }
                    }
                },
                f:group_box {
                    title = "Overview Develop Settings",
                    text_color = LrColor("blue"),
                    font = "<system/bold>",
                    showValue_st
                },
                f:push_button {
                    title = "SAVE AND EDIT",
                    place_horizontal = 1.0,
                    width = 220,
                    height = 20,
                    enabled = LrView.bind("buttonEnabled"),
                    action = function()
                        LrTasks.startAsyncTask(
                            function()
                                -- open window to confirm photo changes
                                if "ok" == LrDialogs.confirm(
                                            "Are you sure?",
                                            "Do you want to edit the selected " ..
                                                #(targetPhotos) ..
                                                    " photo(s)? \n (The Configuration file will be overwritten)"
                                        )
                                then
                                    progressBar = -- creates porgressbar for counting the renditions
                                        LrProgressScope(
                                        {
                                            title = "TheImageIterator-Editing & Exporting Photos"
                                        }
                                    )
                                    progressBar:setCancelable(true)

                                    if targetPhotosCopies == nil then
                                        progressBar:done()
                                        return nil
                                    else
                                        ArraySettings = configFile.Settings
                                        updateSettings()
                                        count = 0
                                        propertyTable.buttonEnabled = false
                                        editPhotos(targetPhotosCopies, keyTable, settingsTable)
                                        propertyTable.buttonEnabled = true
                                    end

                                    if showSuccess == true then
                                        LrDialogs.message(
                                            "Successfully edited and exported the photographs to the ExportedPhotos folder! \n (See Plug-in folder)"
                                        )
                                    end
                                end

                                
                            end
                        )
                    end
                },
                f:push_button {
                    title = "RESET",
                    place_horizontal = 1.0,
                    width = 220,
                    height = 20,
                    action = function() --resets the values of the settings to zero after pushing the "Reset"-Button
                        resetConfigSettings()
                        updateSettings()
                        configFile = adjustConfigFile.configFile
                        propertyTable.myObservedText = overview
                    end
                }
            }

            local result =
                LrDialogs.presentModalDialog(
                {
                    -- display cuustom dialog
                    title = "The Image Iterator - Lightroom Plug-in",
                    contents = contents, -- defined view hierarchy
                    actionVerb = "EXIT",
                    cancelVerb = "CANCEL PROGRESS AND EXIT"
                }
            )
            if (result == "cancel") then --cancel the progress after pushing the "Cancel"-Button
                showSuccess = false
                if progressBar ~= nil then
                    progressBar:setCancelable(true)
                    progressBar:cancel()
                end
            end
        end
    )
end

LrTasks.startAsyncTask(main)
