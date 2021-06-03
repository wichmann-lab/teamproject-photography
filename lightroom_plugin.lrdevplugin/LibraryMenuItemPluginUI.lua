---@diagnostic disable: undefined-global
---@diagnostic disable-next-line: undefined-global
local LrFunctionContext = import 'LrFunctionContext'
---@diagnostic disable-next-line: undefined-global
local LrBinding = import 'LrBinding'
---@diagnostic disable-next-line: undefined-global
local LrDialogs = import 'LrDialogs'
---@diagnostic disable-next-line: undefined-global
local LrView = import 'LrView'
---@diagnostic disable-next-line: undefined-global
local LrTasks = import 'LrTasks'
---@diagnostic disable-next-line: undefined-global
local LrApplication = import 'LrApplication'
local LrDevelopController =import 'LrDevelopController'
local importPhotos = require("ImportPhotos")
--local LrCatalog = import 'LrCatalog'

local adjustConfigFile = require("AdjustConfigurationFile")

--local LrColor = import 'LrColor'
--local ImportPhotos = loadfile ("/Users/ngocdonganhvo/Documents/GitHub/teamproject-photography/lightroom_plugin.lrdevplugin")()
--package.path = package.path .. ";./\\?.lua"
--package.path = package.path .. ";../?.lua"
--package.path = "../?.lua;" .. package.path
--local ImportPhotos = require("ImportPhotos")
local configFile = adjustConfigFile
MyHWLibraryItem = {}

function MyHWLibraryItem.showcustomDialog()     
    LrFunctionContext.callWithContext("showcustomDialog",function(context)  --function-context call for property table (observable)
        local tableOne = LrBinding.makePropertyTable(context)
        
        -- data key for each checkbox with initial boolean value
        tableOne.firstCheckboxIsChecked = false
        tableOne.secondCheckboxIsChecked = false
        tableOne.thirdCheckboxIsChecked = false

        local f = LrView.osFactory()        -- obtain view factory object
            
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

        fieldContrast2 =f:edit_field{
            place_horizontal = 0.6,
            bind = LrView.bind("Checkbox1.2"),
            width_in_digits = 5,
            enabled = LrView.bind("firstCheckboxIsChecked"),
            min = -100,
            max = 100,
            immediate = true,
            value = 0
        }
        fieldContrast3 =f:edit_field{
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
            --width = 400,
            --height = 400,
            bind_to_object = tableOne,      -- bind tableOne
            spacing = f:control_spacing(),
            f:group_box{
                title = "Change settings",
                font = "<system/bold>",

                    f:row{
                        f:checkbox{     -- first checkbox with edit fields
                            title = "Contrast",
                            checked_value = true,
                            value = LrView.bind("firstCheckboxIsChecked")
                        },
                        fieldContrast1,
                        fieldContrast2,
                        fieldContrast3,
                    },

                    f:row{
                        f:checkbox{     -- second checkbox with edit fields
                            title = "Saturation",
                            checked_value = true,
                            value = LrView.bind("secondCheckboxIsChecked")
                        },
                       fieldSaturation1,
                       fieldSaturation2,
                       fieldSaturation3
                    },
                    f:row{
                        f:checkbox{     -- third checkbox with edit fields
                            title = "Highlights",
                            checked_value = true,
                            value = LrView.bind("thirdCheckboxIsChecked")
                        },
                       fieldHighlights1,
                       fieldHighlights2,
                       fieldHighlights3
                    },

                    f:edit_field{       -- Text or commentary filed
                        --place_horizontal = 0.5,
                        value = "Add text or commentary here",
                        width  = 200,
                        height = 100,
                    }
            },
            f:push_button{          -- Push button 
                title = "Save & Edit",
                place_horizontal = 0.5,
                width = 220,
                height = 20,
                action = function()
                LrTasks.startAsyncTask( function()      -- open window to confirm photo changes
                    local catalog = LrApplication.activeCatalog()
                    local targetPhotos = catalog.targetPhotos
                    local targetPhotosCopies = catalog:createVirtualCopies()
                    
                    if 'ok' == LrDialogs.confirm('Are you sure?', 'Do you want to edit the selected ' .. #(targetPhotos) .. ' photo(s)? \n (The Configuration file will be overwritten)') then
                        
                        -- importPhotos.createdirectory(new_dir)         directory where user wants to save the photos

                        catalog:withWriteAccessDo("Adding photos", function ()
                             local testCollection = catalog:createCollection("testCollection")
                             testCollection:addPhotos(targetPhotosCopies)
                         end)
                       
                        adjustConfigFile.configFile.contrast = fieldContrast1.value
                        adjustConfigFile.configFile.highlights = fieldHighlights1.value
                        adjustConfigFile.configFile.saturation = fieldSaturation1.value
                        adjustConfigFile.write_config()
                        for i, photo in ipairs(catalog.targetPhotos) do
                          importPhotos.editPhotos(photo)
                        end

                        return
                    end
                end)
               end
            }, 
            f:push_button{ -- resets the current values to 0
                title="Reset",
                place_horizontal = 0.5,
                width = 220,
                height = 20, 
                action = function ()
                    LrTasks.startAsyncTask( function()      -- open window to confirm photo changes
                        local catalog = LrApplication.activeCatalog()
                        local targetPhotos = catalog.targetPhotos
                        
                        if 'ok' == LrDialogs.confirm('Are you sure?', 'Do you want to reset the values of the selected ' .. #(targetPhotos) .. ' photo(s)? \n (The Configuration file will be overwritten)') then
                            fieldContrast1.value = 0
                            fieldHighlights1.value = 0
                            fieldSaturation1.value = 0
                            adjustConfigFile.configFile.contrast = fieldContrast1.value
                            adjustConfigFile.configFile.highlights = fieldHighlights1.value
                            adjustConfigFile.configFile.saturation = fieldSaturation1.value 
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
        
        local result = LrDialogs.presentModalDialog({ --display cuustom dialog
            title = "Lightroom Plugin - Settings",
            contents = contents -- defined view hierarchy
          
        })
        
    end)
end
--MyHWLibraryItem.importSelected()
MyHWLibraryItem.showcustomDialog()



