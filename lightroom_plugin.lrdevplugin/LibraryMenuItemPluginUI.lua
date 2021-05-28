local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'
local LrDevelopController =import 'LrDevelopController'
--local LrColor = import 'LrColor'
--local ImportPhotos = loadfile ("/Users/ngocdonganhvo/Documents/GitHub/teamproject-photography/lightroom_plugin.lrdevplugin")()
--package.path = package.path .. ";./\\?.lua"
--package.path = package.path .. ";../?.lua"
--package.path = "../?.lua;" .. package.path
--local ImportPhotos = require("ImportPhotos")
MyHWLibraryItem = {}

function MyHWLibraryItem.editPhotos(photo) -- editing the selected pictures 
    photo:quickDevelopAdjustImage("Contrast", fieldContrast1.value)
    photo:quickDevelopAdjustImage("Highlights", fieldHighlights1.value)
    photo:quickDevelopAdjustImage("Saturation", fieldSaturation1.value)
end 

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
            value = 0
        }

        fieldContrast2 =f:edit_field{
            place_horizontal = 0.6,
            bind = LrView.bind("Checkbox1.2"),
            width_in_digits = 3,
            enabled = LrView.bind("firstCheckboxIsChecked"),
            min = -100,
            max = 100,
            immediate = true,
            value = 0
        }
        fieldContrast3 =f:edit_field{
            place_horizontal = 0.6,
            bind = LrView.bind("Checkbox1.3"),
            width_in_digits = 3,
            enabled = LrView.bind("firstCheckboxIsChecked"),
            min = -100,
            max = 100,
            immediate = true,
            value = 0
        }

        fieldSaturation1 = f:edit_field{
            place_horizontal = 0.8,
            bind = LrView.bind("Checkbox2.1"),
            width_in_digits = 3,
            enabled = LrView.bind("secondCheckboxIsChecked"),
            min = -100,
            max = 100,
            immediate = true,
            value = 0

        }

        fieldSaturation2 = f:edit_field{
            place_horizontal = 0.8,
            bind = LrView.bind("Checkbox2.2"),
            width_in_digits = 3,
            enabled = LrView.bind("secondCheckboxIsChecked"),
            min = -100,
            max = 100,
            immediate = true,
            value = 0

        }
        fieldSaturation3 = f:edit_field{
            place_horizontal = 0.8,
            bind = LrView.bind("Checkbox2.3"),
            width_in_digits = 3,
            enabled = LrView.bind("secondCheckboxIsChecked"),
            min = -100,
            max = 100,
            immediate = true,
            value = 0

        }

        fieldHighlights1 = f:edit_field{
            place_horizontal = 0.8,
            bind = LrView.bind("Checkbox3.1"),
            width_in_digits = 3,
            enabled = LrView.bind("thirdCheckboxIsChecked"),
            min = -100,
            max = 100,
            immediate = true,
            value = 0

        }
        fieldHighlights2 = f:edit_field{
            place_horizontal = 0.8,
            bind = LrView.bind("Checkbox3.2"),
            width_in_digits = 3,
            enabled = LrView.bind("thirdCheckboxIsChecked"),
            min = -100,
            max = 100,
            immediate = true,
            value = 0

        }
        fieldHighlights3 = f:edit_field{
            place_horizontal = 0.8,
            bind = LrView.bind("Checkbox3.3"),
            width_in_digits = 3,
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
                title = "Save",
                place_horizontal = 1.0,
                width = 220,
                height = 20,
               action = function()
                LrTasks.startAsyncTask( function()      -- open window to confirm photo changes
                    local catalog = LrApplication.activeCatalog()
                   local targetPhotos = catalog.targetPhotos
                    if 'ok' == LrDialogs.confirm('Are you sure?', 'Do you want to edit the selected ' .. #(targetPhotos) .. ' photo(s)?') then
                        for i, photo in ipairs(catalog.targetPhotos) do
                          MyHWLibraryItem.editPhotos(photo)
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



