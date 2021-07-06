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
keyset = combine.getKeys(ArraySettings)
combinedArray = combine.getCombinedArray(ArraySettings)
settingsTable = combine.getSettingsTable(combinedArray)
times = combine.getTimesOfCombinations(ArraySettings)
overview = combine.overviewSettings(ArraySettings)

function editPhotos(photos, keyset, settingsTable)
    for index,data in ipairs(settingsTable) do
        if progressBar:isCanceled() then -- cancel progress in catalog (via X)
            break
        end 
        result = editSinglePhoto(keyset,photos,data)
        exportPhotos.processRenderedPhotos(result,folderName)
        folderName =""
        for p,picture in pairs(result) do
            for key, value in pairs(data) do
                picture:quickDevelopAdjustImage(keyset[key], 0)
            end
        end
    end
   progressBar:done()
end

function editSinglePhoto(keyset,photos,data)
    for p,photo in pairs(photos) do
        if progressBar:isCanceled() then -- cancel progress in catalog (via X)
            break
        end 
        folderName=""
        for key, value in pairs(data) do
            photo:quickDevelopAdjustImage(keyset[key], tonumber(value))
            progressBar:setPortionComplete(count, times* #targetPhotosCopies)
            folderName= folderName .. keyset[key].. value
        end
        count = count + 1
    end
    --exportPhotos.processRenderedPhotos(photos,folderName)
    return photos
end
 function resetPhotoEdit() -- reset all setting
    for key, value in pairs(keyset) do
        configFile.Settings[value] = {0, 0, 0,}
        adjustConfigFile.write_config()
    end

end


local function main()

    -- Display dialog box
    LrFunctionContext.callWithContext("showcustomDialog",
        function(context) -- function-context call for property table (observable)
            local tableOne = LrBinding.makePropertyTable(context)
             --ANNIE
            tableOne.myObservedText = overview
           
            local f = LrView.osFactory() -- obtain view factory object
            

            --error(configFile.Settings.Saturation)
            --valueOfBox1 = popupBox1.value
            --valueOfBox1=configFile.Settings[valueOfBox1]
            fieldSettingValue1 = f:edit_field{
                place_horizontal = 0.6,
                --bind =LrView.bind(popupBox1.value), 
                width_in_digits = 5,
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings[keyset[1]][1]
            }

            fieldSettingValue2 = f:edit_field{
                place_horizontal = 0.6,
                bind = LrView.bind("Checkbox1.2"),
                width_in_digits = 5,
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings[keyset[1]][2],
            }
            fieldSettingValue3 = f:edit_field{
                place_horizontal = 0.6,
                bind = LrView.bind("Checkbox1.3"),
                width_in_digits = 5,
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings[keyset[1]][3],
            }

            settingTextField = f:edit_field{
                width_in_chars = 14,
                immediate = true,
                value = keyset[1]
            }
--ANNIE
            overviewTextField= f:static_text{ --  
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
                overviewTextField.title = overview  
                overviewTextField = LrColor( 1, 0, 0 ) -- make the text red

                end

            tableOne:addObserver( "myObservedText", updateOverviewSettings )


            pathDisplayConfigFile = f:static_text{
                title = "Absolute Path (ConfigFile): \n"  .. adjustConfigFile.myPathConfig,
                text_color = LrColor(0, 0, 0)
            }
            LrDialogs.message("THE IMAGE ITERATOR \n - Start editing all your photographs! - ","ADD: \n HELP: \n Save and Edit: \n Reset: \n")

            local contents = f:column{
                -- CHANGE THE WINDOW SIZE HERE:
                -- width = 400,
                -- height = 400,
                bind_to_object = tableOne, -- bind tableOne
                spacing = f:control_spacing(),
                f:group_box{
                    title = "Path of ConfigFile",
                    font = "<system>",
                    pathDisplayConfigFile
                },

                f:row{f:group_box{
                    title = "Change settings",
                    font = "<system/bold>",
                    f:row{
                    

                    f:row{
                        
                        settingTextField,
                        fieldSettingValue1, fieldSettingValue2, fieldSettingValue3,
                    },
                        f:push_button{
                            title = "ADD",
                            action = function()
                                   configFile.Settings[settingTextField.value] = {fieldSettingValue1.value,fieldSettingValue2.value,fieldSettingValue3.value}
                                    adjustConfigFile.write_config()
                                ArraySettings = configFile.Settings
                                keyset = combine.getKeys(ArraySettings)
                                combinedArray = combine.getCombinedArray(ArraySettings)
                                settingsTable = combine.getSettingsTable(combinedArray)
                                times = combine.getTimesOfCombinations(ArraySettings)
                                overview = combine.overviewSettings(ArraySettings)

                                -- ANNIE (für UI muss das noch zu action hinzugefügt werden)
                                overviewTextField.text_color = LrColor( 0, 0, 0 )
                                tableOne.myObservedText = settingTextField.value

                                end,
                            bind = LrView.bind('overview')
                        },
                        f:push_button{
                            title = "HELP",
                            action = function()
                                LrDialogs.message("HALLO","", "info")
                            end
                        },
                    }

                },
            
                }, f:group_box{
                    title = "Overview Develop Settings",
                    font = "<system/bold>",
                    overviewTextField
                },

                f:push_button{ -- Push button 
                    title = "Save and Edit",
                    place_horizontal = 1.0,
                    width = 220,
                    height = 20,
                    action = function()
                        LrTasks.startAsyncTask(function() -- open window to confirm photo changes
                            -- select number of edited photos
                            --[[local targetPhotos = catalog.targetPhotos
                        if configFile.allPhotos == true then
                             targetPhotos = catalog:getAllPhotos()
                        end]]

                            if 'ok' ==
                                LrDialogs.confirm('Are you sure?',
                                    'Do you want to edit the selected ' .. #(targetPhotos) ..
                                        ' photo(s)? \n (The Configuration file will be overwritten)') then

                                -- ExportPhotos.makeDirectory(new_dir)         directory where user wants to save the photos

                                --[[catalog:withWriteAccessDo("Adding photos", function()
                                originalCollection = catalog:createCollection("Original") -- if already exists: ERROR!! connect to config file!
                                testCollection = catalog:createCollection("Edited photos") -- if already exists: ERROR!! connect to config file!
                                originalCollection:addPhotos(targetPhotos)
                                testCollection:addPhotos(targetPhotosCopies)
                            end)]]
                            progressBar = LrProgressScope({
                                title = "TheImageIterator-Editing & Exporting Photos"
                            })
                                progressBar:setCancelable(true)
                                 
                                if targetPhotosCopies == nil then
                                    -- LrDialogs.message("Nothing selected.")
                                    progressBar:done()
                                    return nil
                                
                                else
                
                                    --photoSettings()
                                    --adjustConfigFile.write_config()
                                    --[[define setting arrays for later use
                                    contrastArray = {fieldContrast1.value, fieldContrast2.value, fieldContrast3.value}
                                    saturationArray = {fieldSaturation1.value, fieldSaturation2.value,
                                                       fieldSaturation3.value}
                                    highlightsArray = {fieldHighlights1.value, fieldHighlights2.value,
                                                       fieldHighlights3.value}
                                                       ]]
                                    count = 0
                                    --[[
                                    for i = 1, 3 do
                                        for j = 1, 3 do
                                            for k = 1, 3 do
                                                if progressBar:isCanceled() then -- cancel progress in catalog (via X)
                                                    break
                                                end 
                                                for p, photo in ipairs(catalog.targetPhotos) do
                                                    local path =LrPathUtils.standardizePath(photo:getRawMetadata("path"))
                                                        progressBar:setPortionComplete(count, 3 * 3 * 3 * #targetPhotosCopies)]]
                                                        editPhotos(targetPhotosCopies, keyset, settingsTable)-- edits photos in catalog
                                                         --count = count + 1
                                                --end
                                                --exportPhotos.processRenderedPhotos(targetPhotosCopies,"Export Folder" .. "_c" .. tostring(contrastArray[i]) .. "_s" ..tostring(saturationArray[j]) .. "_h" ..tostring(highlightsArray[k])) -- export edited targetPhotosCopies from the catalog
                                                --for p, photo in ipairs(catalog.targetPhotos) do
                                                    --resetPhotoEdit(photo)
                                                --end

                                            --end
                                        --end

                                    --end
                                    --progressBar:done()
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
                contents = contents -- defined view hierarchy

            })
            if result == 'cancel' then
                if progressBar:isDone() == false then
                
                 progressBar:setCancelable(true)
                progressBar:cancel()

                end
    
            end
           
        end)

end

LrTasks.startAsyncTask(main)

