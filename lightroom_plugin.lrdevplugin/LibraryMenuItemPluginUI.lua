--============================SDK===============================--
local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'
local importPhotos = require("ImportPhotos")
local exportPhotos = require("ExportPhotos")
local adjustConfigFile = require("AdjustConfigurationFile")
local configFile = adjustConfigFile.configFile
--==============================================================--

local function  photoSettings()
     configFile.contrast = fieldContrast1.value
     configFile.saturation = fieldSaturation1.value
     configFile.highlights = fieldHighlights1.value
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

            local f = LrView.osFactory() -- obtain view factory object

            fieldContrast1 = f:edit_field{
                place_horizontal = 0.6,
                bind = LrView.bind("Checkbox1.1"),
                width_in_digits = 5,
                enabled = LrView.bind("firstCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = adjustConfigFile.getValue("contrast")
            }

            fieldContrast2 = f:edit_field{
                place_horizontal = 0.6,
                bind = LrView.bind("Checkbox1.2"),
                width_in_digits = 5,
                enabled = LrView.bind("firstCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = 0
            }
            fieldContrast3 = f:edit_field{
                place_horizontal = 0.6,
                bind = LrView.bind("Checkbox1.3"),
                width_in_digits = 5,
                enabled = LrView.bind("firstCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = 0
            }

            fieldSaturation1 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox2.1"),
                width_in_digits = 5,
                enabled = LrView.bind("secondCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = adjustConfigFile.getValue("saturation")

            }

            fieldSaturation2 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox2.2"),
                width_in_digits = 5,
                enabled = LrView.bind("secondCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = 0

            }
            fieldSaturation3 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox2.3"),
                width_in_digits = 5,
                enabled = LrView.bind("secondCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = 0

            }

            fieldHighlights1 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox3.1"),
                width_in_digits = 5,
                enabled = LrView.bind("thirdCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = adjustConfigFile.getValue("highlights")

            }
            fieldHighlights2 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox3.2"),
                width_in_digits = 5,
                enabled = LrView.bind("thirdCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = 0

            }
            fieldHighlights3 = f:edit_field{
                place_horizontal = 0.8,
                bind = LrView.bind("Checkbox3.3"),
                width_in_digits = 5,
                enabled = LrView.bind("thirdCheckboxIsChecked"),
                min = -100,
                max = 100,
                immediate = true,
                value = 0

            }

            local contents = f:column{
                -- CHANGE THE WINDOW SIZE HERE:
                -- width = 400,
                -- height = 400,
                bind_to_object = tableOne, -- bind tableOne
                spacing = f:control_spacing(),
                f:group_box{
                    title = "Change settings",
                    font = "<system/bold>",

                    f:row{f:checkbox{ -- first checkbox with edit fields
                        title = "Contrast",
                        checked_value = true,
                        value = LrView.bind("firstCheckboxIsChecked")
                    }, fieldContrast1, fieldContrast2, fieldContrast3},

                    f:row{f:checkbox{ -- second checkbox with edit fields
                        title = "Saturation",
                        checked_value = true,
                        value = LrView.bind("secondCheckboxIsChecked")
                    }, fieldSaturation1, fieldSaturation2, fieldSaturation3},
                    f:row{f:checkbox{ -- third checkbox with edit fields
                        title = "Highlights",
                        checked_value = true,
                        value = LrView.bind("thirdCheckboxIsChecked")
                    }, fieldHighlights1, fieldHighlights2, fieldHighlights3},

                    f:edit_field{ -- Text or commentary filed
                        -- place_horizontal = 0.5,
                        value = "Add text or commentary here",
                        width = 200,
                        height = 100
                    }
                },
                f:push_button{ -- Push button 
                    title = "Save & Edit",
                    place_horizontal = 0.5,
                    width = 220,
                    height = 20,
                    action = function()
                        LrTasks.startAsyncTask(function() -- open window to confirm photo changes
                            local catalog = LrApplication.activeCatalog()
                            
                            -- select number of edited photos
                            --[[local targetPhotos = catalog.targetPhotos
                            if configFile.allPhotos == true then
                                 targetPhotos = catalog:getAllPhotos()
                            end]]

                            local targetPhotos = catalog.targetPhotos
                            local targetPhotosCopies = targetPhotos

                            if 'ok' ==
                                LrDialogs.confirm('Are you sure?', 'Do you want to edit the selected ' ..
                                    #(targetPhotos) .. ' photo(s)? \n (The Configuration file will be overwritten)') then

                                -- ExportPhotos.makeDirectory(new_dir)         directory where user wants to save the photos

                                --[[catalog:withWriteAccessDo("Adding photos", function()
                                    originalCollection = catalog:createCollection("Original") -- if already exists: ERROR!! connect to config file!
                                    testCollection = catalog:createCollection("Edited photos") -- if already exists: ERROR!! connect to config file!
                                    originalCollection:addPhotos(targetPhotos)
                                    testCollection:addPhotos(targetPhotosCopies)
                                end)]]

                                photoSettings()

                                adjustConfigFile.write_config()
                                for i, photo in ipairs(catalog.targetPhotos) do
                                    importPhotos.editPhotos(photo)                      --edits photos in catalog
                                end
                                exportPhotos.processRenderedPhotos(targetPhotosCopies) --export edited targetPhotosCopies from the catalog

                                    fieldContrast1.value = 0
                                    fieldHighlights1.value = 0
                                    fieldSaturation1.value = 0
                                    
                                    photoSettings()

                                    adjustConfigFile.write_config()
                                    for i, photo in ipairs(catalog.targetPhotos) do
                                        importPhotos.editPhotos(photo)
                                    end
                            end
                        end)
                    end
                },
                f:push_button{ -- resets the current values to 0
                    title = "Reset",
                    place_horizontal = 0.5,
                    width = 220,
                    height = 20,
                    action = function()
                        LrTasks.startAsyncTask(function() -- open window to confirm photo changes
                            local catalog = LrApplication.activeCatalog()
                            local targetPhotos = catalog.targetPhotos

                            if 'ok' ==
                                LrDialogs.confirm('Are you sure?',
                                    'Do you want to reset the values of the selected ' .. #(targetPhotos) ..
                                        ' photo(s)? \n (The Configuration file will be overwritten)') then
                                fieldContrast1.value = 0
                                fieldHighlights1.value = 0
                                fieldSaturation1.value = 0
                                
                                photoSettings()

                                adjustConfigFile.write_config()
                                for i, photo in ipairs(catalog.targetPhotos) do
                                    importPhotos.editPhotos(photo)
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

