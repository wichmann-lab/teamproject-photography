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

local function editPhotos(photo, i, j, k)
    -- for i = 1, 3, 1 do
    -- for j = 1, 3, 1 do
    -- for k = 1, 3, 1 do
    photo:quickDevelopAdjustImage(developList[1].title, contrastArray[i])
    photo:quickDevelopAdjustImage("Saturation", saturationArray[j])
    photo:quickDevelopAdjustImage("Highlights", highlightsArray[k])
    -- end
    -- end
    -- end
end
local function applyTableMatrix(developSettings)
    records = {}
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
    error(records)
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
            --tableOne.my_value = 'value_1'
            tableOne.my_value2 = 'value_2'
            local f = LrView.osFactory() -- obtain view factory object
            developList = { -- the menu items and their values
            { title = "Contrast", value = 1},
            { title = "Saturation", value = 'value_2' },
            { title = "Highlights", value = 'value_3' },
            }
            popupBox1 =f:popup_menu {
                value = LrView.bind('my_value'), -- current value bound to same key as static text
                items = developList,
            }
            popupBox2 =f:popup_menu {
                value = LrView.bind('my_value1'), -- current value bound to same key as static text
                items = developList,
            }
            --error(configFile.Settings.Saturation)
            --valueOfBox1 = popupBox1.value
            --valueOfBox1=configFile.Settings[valueOfBox1]
            fieldContrast1 = f:edit_field{
                place_horizontal = 0.6,
                --bind =LrView.bind(popupBox1.value), 
                width_in_digits = 7,
                --enabled = LrView.bind("firstCheckboxIsChecked"),
                --min = -100,
                --max = 100,
                --immediate = true,
                value = LrView.bind('my_value'),
            }

            fieldContrast2 = f:edit_field{
                place_horizontal = 0.6,
                bind = LrView.bind("Checkbox1.2"),
                width_in_digits = 7,
                --enabled = LrView.bind("firstCheckboxIsChecked"),
                --min = -100,
                --max = 100,
                immediate = true,
                value = LrView.bind('my_value')
            }
            fieldContrast3 = f:edit_field{
                place_horizontal = 0.6,
                bind = LrView.bind("Checkbox1.3"),
                width_in_digits = 7,
                --enabled = LrView.bind("firstCheckboxIsChecked"),
                --min = -100,
                --max = 100,
                immediate = true,
                value = LrView.bind('my_value')
            }

            fieldSaturation1 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox2.1"),
                width_in_digits = 7,
                enabled = LrView.bind("secondCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = LrView.bind('my_value1') 
            }

            fieldSaturation2 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox2.2"),
                width_in_digits = 7,
                enabled = LrView.bind("secondCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings.Saturation[2]

            }
            fieldSaturation3 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox2.3"),
                width_in_digits = 7,
                enabled = LrView.bind("secondCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings.Saturation[3]

            }

            fieldHighlights1 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox3.1"),
                width_in_digits = 7,
                enabled = LrView.bind("thirdCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings.Highlights[1]

            }
            fieldHighlights2 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox3.2"),
                width_in_digits = 7,
                enabled = LrView.bind("thirdCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings.Highlights[2]

            }
            fieldHighlights3 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox3.3"),
                width_in_digits = 7,
                enabled = LrView.bind("thirdCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = configFile.Settings.Highlights[3]

            }
            pathDisplayConfigFile = f:static_text{
                title = "Absolute Path (ConfigFile):" .. adjustConfigFile.myPathConfig,
                text_color = LrColor(0, 0, 0)
            }
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

                f:row{f:column{f:group_box{
                    title = "Change settings",
                    font = "<system/bold>",

                    f:row{popupBox1, 
                        --[[f:checkbox{ -- first checkbox with edit fields
                        title = "Contrast",
                        width_in_chars = 7,
                        checked_value = true,
                        value = LrView.bind("firstCheckboxIsChecked")]]
                        fieldContrast1, fieldContrast2, fieldContrast3},
                    f:row{f:checkbox{ -- second checkbox with edit fields
                        title = "Saturation",
                        checked_value = true,
                        width_in_chars = 7,
                        value = LrView.bind("secondCheckboxIsChecked")
                    }, fieldSaturation1, fieldSaturation2, fieldSaturation3},
                    popupBox2,
                    f:row{f:checkbox{ -- third checkbox with edit fields
                        title = "Highlights",
                        checked_value = true,
                        width_in_chars = 7,
                        value = LrView.bind("thirdCheckboxIsChecked")
                    }, fieldHighlights1, fieldHighlights2, fieldHighlights3},

                    f:edit_field{ -- Text or commentary filed
                        -- place_horizontal = 0.5,
                        value = "Add text or commentary here",
                        width = 200,
                        height = 100
                    }

                }}, f:column{f:group_box{f:edit_field{
                    value = "Add text"
                }}, f:group_box{f:edit_field{
                    value = "Add text"
                }}, f:group_box{f:edit_field{
                    value = "Add text"
                }}}},

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

