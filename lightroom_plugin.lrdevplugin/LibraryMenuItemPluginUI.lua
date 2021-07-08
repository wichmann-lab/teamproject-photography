-- ============================SDK===============================--
local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'
local exportPhotos = require("ExportPhotos")
local adjustConfigFile = require("AdjustConfigurationFile")
local configFile = adjustConfigFile.configFile
local LrColor = import 'LrColor'
local LrProgressScope = import 'LrProgressScope'
local catalog = LrApplication.activeCatalog()
local targetPhotos = catalog.targetPhotos
local targetPhotosCopies = targetPhotos
local LrPathUtils = import 'LrPathUtils'
local combine = require("arrayCombine")
-- ==============================================================--

ArraySettings = configFile.Settings
keyTable = combine.getKeys(ArraySettings)
combinedArray = combine.getCombinedArray(ArraySettings)
settingsTable = combine.getSettingsTable(combinedArray)
times = combine.getTimesOfCombinations(ArraySettings)
overview = combine.overviewSettings(ArraySettings)
developSettingsTable={"Exposure", "Contrast", "Highlights", "Shadows", "Whites", "Blacks", "Clarity", "Vibrance","Saturation"}

function editPhotos(photos, keyTable, settingsTable)
    for index,data in ipairs(settingsTable) do
        if progressBar:isCanceled() then -- cancel progress in catalog (via X)
            break
        end 
        result = editSinglePhoto(keyTable,photos,data)
        exportPhotos.processRenderedPhotos(result,folderName)
        folderName =""
        for p,picture in pairs(result) do
            for key, value in pairs(data) do
                picture:quickDevelopAdjustImage(keyTable[key], 0)
            end
        end
    end
   progressBar:done()
end

function editSinglePhoto(keyTable,photos,data)
    for p,photo in pairs(photos) do
        if progressBar:isCanceled() then -- cancel progress in catalog (via X)
            break
        end 
        folderName=""
        for key, value in pairs(data) do
            photo:quickDevelopAdjustImage(keyTable[key], tonumber(value))
            progressBar:setPortionComplete(count, times* #targetPhotosCopies)
            folderName= folderName .. keyTable[key].. value
        end
        count = count + 1
    end
    --exportPhotos.processRenderedPhotos(photos,folderName)
    return photos
end
 function resetPhotoEdit() -- reset all setting
    for key, value in pairs(keyTable) do
        configFile.Settings[value] = {0, 0, 0,}
        adjustConfigFile.write_config()
    end

end

--adjustConfigFile.configFileNil()



local function main()

    -- Display dialog box
    LrFunctionContext.callWithContext("showcustomDialog",
        function(context) -- function-context call for property table (observable)
            local tableOne = LrBinding.makePropertyTable(context)
             --ANNIE
            observerFieldSetting = 0
            tableOne.myObservedText = overview
            tableOne.myObservedField1 = observerFieldSetting
   
            local f = LrView.osFactory() -- obtain view factory object
            

            --error(configFile.Settings.Saturation)
            --valueOfBox1 = popupBox1.value
            --valueOfBox1=configFile.Settings[valueOfBox1]
            fieldSettingValue1 = f:edit_field{
                place_horizontal = 0.6,
                width_in_digits = 5,
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings[keyTable[1]][1],
                bind = LrView.bind("observerFieldSetting")
            }

            fieldSettingValue2 = f:edit_field{
                place_horizontal = 0.6,
                width_in_digits = 5,
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings[keyTable[1]][2],
                bind = LrView.bind("observerFieldSetting")
            }
            fieldSettingValue3 = f:edit_field{
                place_horizontal = 0.6,
                width_in_digits = 5,
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings[keyTable[1]][3],
                bind = LrView.bind("observerFieldSetting")
            }

            settingTextField = f:edit_field{
                width_in_chars = 14,
                immediate = true,
                value = keyTable[1]
            }
--ANNIE
            showValue_st= f:static_text{ --  
                        -- place_horizontal = 0.5,
                        --immediate = true,
                        title = tableOne.myObservedText,
                        text_color = LrColor( 1, 0, 0 ),
                       -- bind = LrView.bind('overview'),
                         width = 400,
                         height = 200,
                    }

                    --ANNIE
            local updateOverviewSettings = function ()
                showValue_st.title = overview
                showValue_st.text_color = LrColor( 1, 0, 0 ) -- make the text red
               end

            tableOne:addObserver( "myObservedText", updateOverviewSettings )
            tableOne:addObserver( "myObservedField1", updateOverviewSettings )
            tableOne:addObserver( "myObservedField2", updateOverviewSettings )
            tableOne:addObserver( "myObservedField3", updateOverviewSettings )


            pathDisplayConfigFile = f:static_text{
                title = "Absolute Path (ConfigFile): \n"  .. adjustConfigFile.myPathConfig,
                text_color = LrColor(0, 0, 0)
            }
             LrDialogs.message("THE IMAGE ITERATOR \n - Start editing all your photographs! - ",
             "ADD-Button: Add settings and different values for those. The selected photographs will be edited with all combinations of settings and values. \n HELP-Button: Opens window, shows which settings are available. \n Save and Edit- Button: Start the editing and exporting progress. \n Reset-Button: Reset the values of all settings in the configuration file to 0. \n CANCEL-Button: Cancel the editing and exporting progress. \n (alternative: via X at the right end of the progress bar in the catalog window) \n EXIT-Button: Close the Plug-in window \n",
              "warning")

            local contents = f:column{
                -- CHANGE THE WINDOW SIZE HERE:
                -- width = 400,
                -- height = 400,
                bind_to_object = tableOne, -- bind tableOne
                spacing = f:control_spacing(),
                f:group_box{
                    title = "Path of ConfigFile",
                    font = "<system/bold>",
                    pathDisplayConfigFile
                },

                f:row{f:group_box{
                    title = "Add and change settings",
                    font = "<system/bold>",
                    f:row{

                    

                    f:row{
                        settingTextField,
                        fieldSettingValue1, fieldSettingValue2, fieldSettingValue3,
                    },

                        f:push_button{
                            title = "ADD",
                            action = function()
                                settingTextField.value = settingTextField.value:lower()
                                settingTextField.value = settingTextField.value:gsub("^%l", string.upper)
                                res = 0
                                for index, value in ipairs(developSettingsTable) do
                                    if value == settingTextField.value then
                                        res = 1
                                        --break
                                    end
                                end
                                if res == 1 then
                                    configFile.Settings[settingTextField.value] = {fieldSettingValue1.value,fieldSettingValue2.value,fieldSettingValue3.value}
                                    adjustConfigFile.write_config()
                                    configFile = adjustConfigFile.configFile
                                   ArraySettings = configFile.Settings
                                else
                                    LrDialogs.showError("Unavailable Setting! Please check the given list in README or HELP!")
                                end
                                --adjustConfigFile.reload_config()
                                keyTable = combine.getKeys(ArraySettings)
                                combinedArray = combine.getCombinedArray(ArraySettings)
                                settingsTable = combine.getSettingsTable(combinedArray)
                                times = combine.getTimesOfCombinations(ArraySettings)
                                overview = combine.overviewSettings(ArraySettings)
                                configFile = adjustConfigFile.configFile
                                -- ANNIE (für UI muss das noch zu action hinzugefügt werden)
                                showValue_st.text_color = LrColor( 0, 0, 0 )
                                tableOne.myObservedText = settingTextField.value
                                tableOne.myObservedField1 = fieldSettingValue1.value --!!!
                                tableOne.myObservedField2 = fieldSettingValue2.value
                                tableOne.myObservedField3 = fieldSettingValue3.value

                            end,
                            bind = LrView.bind('overview')
                        },
                        f:push_button{
                            title = "HELP",
                            action = function()
                                LrDialogs.message("The following editing settings are available:"," Exposure \n Contrast \n Highlights \n Shadows \n Whites \n Blacks \n Clarity \n Vibrance \n Saturation", "info")

                            end
                        },
                    }

                },
            
                }, f:group_box{
                    title = "Overview Develop Settings",
                    font = "<system/bold>",
                    showValue_st
                },
                f:push_button{ -- Push button 
                    title = "Save and Edit",
                    place_horizontal = 1.0,
                    width = 220,
                    height = 20,
                    action = function()
                        LrTasks.startAsyncTask(function() -- open window to confirm photo changes
                            if 'ok' ==
                                LrDialogs.confirm('Are you sure?',
                                    'Do you want to edit the selected ' .. #(targetPhotos) ..
                                        ' photo(s)? \n (The Configuration file will be overwritten)') then
                            progressBar = LrProgressScope({
                                title = "TheImageIterator-Editing & Exporting Photos"
                            })
                                progressBar:setCancelable(true)
                                 
                                if targetPhotosCopies == nil then
                                    progressBar:done()
                                    return nil
                                else
                                    ArraySettings = configFile.Settings
                                    keyTable = combine.getKeys(ArraySettings)
                                    combinedArray = combine.getCombinedArray(ArraySettings)
                                    settingsTable = combine.getSettingsTable(combinedArray)
                                    times = combine.getTimesOfCombinations(ArraySettings)
                                    overview = combine.overviewSettings(ArraySettings)
                                    count = 0
                                    editPhotos(targetPhotosCopies, keyTable, settingsTable)-- edits photos in catalog
                                                        
                                end
                            end
                        
                        end)
                    end
                },
                f:push_button{ -- resets the current values to 0
                    title = "Reset",
                    place_horizontal = 1.0,
                    width = 220,
                    height = 20,
                    action = function()          
                        resetPhotoEdit()
                                
                    end
                }

            }

            local result = LrDialogs.presentModalDialog({ -- display cuustom dialog
                title = "Lightroom Plugin - Settings",
                contents = contents, -- defined view hierarchy
               -- cancelVerb = "< exclude >",
                actionVerb = "EXIT",
                cancelVerb = "CANCEL"

            })
            if (result == 'cancel') then
                if progressBar ~= nil  then
                    progressBar:setCancelable(true)
                    progressBar:cancel()
                end
            end
           
        end)

end

LrTasks.startAsyncTask(main)

