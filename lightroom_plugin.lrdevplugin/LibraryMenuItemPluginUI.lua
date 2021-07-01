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
local combine = require("combine")
-- ==============================================================--

local function photoSettings() -- set current photo settings in config.json

    --[[for i, config in pairs(configFile) do
        for j, value in ipairs(config) do
            value = temp.value
        end
    end]]

    configFile.Settings.Contrast[1] = fieldContrast1.value
    configFile.Settings.Saturation[1] = fieldSaturation1.value
    configFile.Settings.Highlights[1] = fieldHighlights1.value
    configFile.Settings.Contrast[2] = fieldContrast2.value
    configFile.Settings.Saturation[2] = fieldSaturation2.value
    configFile.Settings.Highlights[2] = fieldHighlights2.value
    configFile.Settings.Contrast[3] = fieldContrast3.value
    configFile.Settings.Saturation[3] = fieldSaturation3.value
    configFile.Settings.Highlights[3] = fieldHighlights3.value
end

local function resetPhotoEdit(photo) -- reset all setting
    photo:quickDevelopAdjustImage("Contrast", 0)
    photo:quickDevelopAdjustImage("Highlights", 0)
    photo:quickDevelopAdjustImage("Saturation", 0)
end

--[[local function editPhotos(photo, i, j, k)
    -- for i = 1, 3, 1 do
    -- for j = 1, 3, 1 do
    -- for k = 1, 3, 1 do
    photo:quickDevelopAdjustImage(developList[1].title, contrastArray[i])
    photo:quickDevelopAdjustImage("Saturation", saturationArray[j])
    photo:quickDevelopAdjustImage("Highlights", highlightsArray[k])
    -- end
    -- end
    -- end
end]]

ArraySettings = configFile.Settings
keyset = combine.getKeys(ArraySettings)
combinedArray = combine.getCombinedArray(ArraySettings)
settingsTable = combine.getSettingsTable(combinedArray)

local function editPhotos(photo, keyset, settingsTable)
    for index,data in ipairs(settingsTable) do
        for key, value in pairs(data) do
            photo:quickDevelopAdjustImage(keyset[key], value)
        end
    end

end


local function applyTableMatrix(developSettings)-- parameter developSetting is table in form of: {"Contrast: [1,2,3], "Saturation": [4,5,6], "Highlights:[7,8,9]"}
    records = {} -- "supertable"
    i = 1
    for key, value in pairs(developSettings) do
        for firstKey, firstValue in pairs(value) do
            for secondKey, secondValue in pairs(value) do
                for thirdKey, thirdValue in pairs(value) do
                    records[i]["test"] = firstValue
                    -- records[i][secondKey]= secondValue
                    -- records[i][thirdKey]=thirdValue
                    i = i + 1
                end
            end
        end
    end
    return records --[[     [{"Contrast: 1, "Saturation": 4, "Highlights:7"},]
                            {"Contrast: 1, "Saturation": 4, "Highlights:8"},
                            {"Contrast: 1, "Saturation": 4, "Highlights:9"},
                            ....]
                    ]]
end

local function main()

    -- Display dialog box
    LrFunctionContext.callWithContext("showcustomDialog",
        function(context) -- function-context call for property table (observable)
            local tableOne = LrBinding.makePropertyTable(context)
            -- data key for each checkbox with initial boolean value
            tableOne.firstCheckboxIsChecked = false
            tableOne.secondCheckboxIsChecked = false
            tableOne.thirdCheckboxIsChecked = false
            tableOne.my_value = 'value_1'
            tableOne.my_value2 = 'value_2'
            local f = LrView.osFactory() -- obtain view factory object
            developList = { -- the menu items and their values
            { title = "Contrast", value = {'value_1',20,30}},
            { title = "Saturation", value = 'value_2' },
            { title = "Highlights", value = 'value_3' },
            }

            --error(configFile.Settings.Saturation)
            --valueOfBox1 = popupBox1.value
            --valueOfBox1=configFile.Settings[valueOfBox1]
            fieldSettingValue1 = f:edit_field{
                place_horizontal = 0.6,
                --bind =LrView.bind(popupBox1.value), 
                width_in_digits = 5,
                --enabled = LrView.bind("firstCheckboxIsChecked"),
                --min = -100,
                --max = 100,
                --immediate = true,
                value = configFile.Settings[developList[1].title][1]
            }

            fieldSettingValue2 = f:edit_field{
                place_horizontal = 0.6,
                bind = LrView.bind("Checkbox1.2"),
                width_in_digits = 5,
                --enabled = LrView.bind("firstCheckboxIsChecked"),
                --min = -100,
                --max = 100,
                immediate = true,
                value = configFile.Settings.Contrast[2],
            }
            fieldSettingValue3 = f:edit_field{
                place_horizontal = 0.6,
                bind = LrView.bind("Checkbox1.3"),
                width_in_digits = 5,
                --enabled = LrView.bind("firstCheckboxIsChecked"),
                --min = -100,
                --max = 100,
                immediate = true,
                value = configFile.Settings.Contrast[3],
            }

            settingTextField = f:edit_field{
                width_in_chars = 14,
                value = "Add develop setting"
            }

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
                        
                        setting1,
                        fieldSettingValue1, fieldSettingValue2, fieldSettingValue3,
                    },
                        f:push_button{
                            title = "ADD",
                            --action = 
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
                        f:static_text{ -- Text or commentary filed
                        -- place_horizontal = 0.5,
                        title = tostring(configFile.Settings[1]),
                         width = 400,
                         height = 200
                    }
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
                                local progressBar = LrProgressScope({
                                    title = "TheImageIterator Progress"
                                })
                                progressBar:setCancelable(true)
                                 
                                if targetPhotosCopies == nil then
                                    -- LrDialogs.message("Nothing selected.")
                                    progressBar:done()
                                    return nil
                                
                                else
                
                                    photoSettings()
                                    adjustConfigFile.write_config()
                                    -- define setting arrays for later use
                                    contrastArray = {fieldContrast1.value, fieldContrast2.value, fieldContrast3.value}
                                    saturationArray = {fieldSaturation1.value, fieldSaturation2.value,
                                                       fieldSaturation3.value}
                                    highlightsArray = {fieldHighlights1.value, fieldHighlights2.value,
                                                       fieldHighlights3.value}
                                    local count = 0
                                    -- applyTableMatrix(configFile.Settings)
                                    for i = 1, 3 do
                                        for j = 1, 3 do
                                            for k = 1, 3 do
                                                if progressBar:isCanceled() then -- cancel progress in catalog (via X)
                                                    break
                                                end 
                                                for p, photo in ipairs(catalog.targetPhotos) do
                                                    --local path =LrPathUtils.standardizePath(photo:getRawMetadata("path"))
                                                        progressBar:setPortionComplete(count, 3 * 3 * 3 * #targetPhotosCopies)
                                                        editPhotos(photo, i, j, k) -- edits photos in catalog
                                                         count = count + 1
                                                end
                                                exportPhotos.processRenderedPhotos(targetPhotosCopies,
                                                    "Export Folder" .. "_c" .. tostring(contrastArray[i]) .. "_s" ..
                                                        tostring(saturationArray[j]) .. "_h" ..
                                                        tostring(highlightsArray[k])) -- export edited targetPhotosCopies from the catalog
                                                for p, photo in ipairs(catalog.targetPhotos) do
                                                    resetPhotoEdit(photo)
                                                end

                                            end
                                        end

                                    end
                                    progressBar:done()
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
                        LrTasks.startAsyncTask(function() -- open window to confirm photo changes
                            local catalog = LrApplication.activeCatalog()
                            local targetPhotos = catalog.targetPhotos

                            if 'ok' ==
                                LrDialogs.confirm('Are you sure?', 'Do you want to reset the values of the selected ' ..
                                    #(targetPhotos) .. ' photo(s)?') then

                                for i, photo in ipairs(catalog.targetPhotos) do
                                    resetPhotoEdit(photo)
                                end

                                return
                            end
                        end)
                    end
                }

            }

            local result = LrDialogs.presentModalDialog({ -- display cuustom dialog
                title = "Lightroom Plugin - Settings",
                contents = contents -- defined view hierarchy

            })

        end)

end

LrTasks.startAsyncTask(main)

