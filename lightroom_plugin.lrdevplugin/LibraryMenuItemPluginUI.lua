local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'
--local LrColor = import 'LrColor'
--local ImportPhotos = loadfile ("/Users/ngocdonganhvo/Documents/GitHub/teamproject-photography/lightroom_plugin.lrdevplugin")()
--package.path = package.path .. ";./\\?.lua"
--local ImportPhotos = require("ImportPhotos")

MyHWLibraryItem = {}
function MyHWLibraryItem.importSelected ()
    LrTasks.startAsyncTask( function()
        local catalog = LrApplication.activeCatalog()
        local targetPhotos = catalog:getTargetPhotos()
        if 'ok' == LrDialogs.confirm('Are you sure?', 'Do you want to edit the selected ' .. #(catalog.targetPhotos) .. ' photo(s)?') then
            for i, photo in ipairs(catalog.targetPhotos) do
                MyHWLibraryItem.editPhotos(photo)
            end
        end
    end)
end

function MyHWLibraryItem.editPhotos(photo)
    photo:quickDevelopAdjustImage("Contrast", -100)
    photo:quickDevelopAdjustImage("Highlights", -100)
    photo:quickDevelopAdjustImage("Saturation", -100)
end

function MyHWLibraryItem.showcustomDialog()     
    LrFunctionContext.callWithContext("showcustomDialog",function(context)  --function-context call for property table (observable)
        local tableOne = LrBinding.makePropertyTable(context)
        
        -- data key for each checkbox with initial boolean value
        tableOne.firstCheckboxIsChecked = false
        tableOne.secondCheckboxIsChecked = false
        tableOne.thirdCheckboxIsChecked = false

        local f = LrView.osFactory()        -- obtain view factory object
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
                        f:edit_field{
                            place_horizontal = 0.6,
                            value = LrView.bind("Checkbox1.1"),
                            width_in_digits = 3,
                            enabled = LrView.bind("firstCheckboxIsChecked"),
                            min = -100,
                            max = 100
                        },
                        f:edit_field{
                            place_horizontal = 0.6,
                            value = LrView.bind("Checkbox1.2"),
                            width_in_digits = 3,
                            enabled = LrView.bind("firstCheckboxIsChecked"),
                            min = -100,
                            max = 100
                        },
                        f:edit_field{
                            place_horizontal = 0.6,
                            value = LrView.bind("Checkbox1.3"),
                            width_in_digits = 3,
                            enabled = LrView.bind("firstCheckboxIsChecked"),
                            min = -100,
                            max = 100
                        },
                    },

                    f:row{
                        f:checkbox{     -- second checkbox with edit fields
                            title = "Saturation",
                            checked_value = true,
                            value = LrView.bind("secondCheckboxIsChecked")
                        },
                        f:edit_field{
                            place_horizontal = 0.8,
                            value = LrView.bind("Checkbox2.1"),
                            width_in_digits = 3,
                            enabled = LrView.bind("secondCheckboxIsChecked"),
                            min = -100,
                            max = 100
                        },
                        f:edit_field{
                            place_horizontal = 0.8,
                            value = LrView.bind("Checkbox2.2"),
                            width_in_digits = 3,
                            enabled = LrView.bind("secondCheckboxIsChecked"),
                            min = -100,
                            max = 100
                        },
                        f:edit_field{
                            place_horizontal = 0.8,
                            value = LrView.bind("Checkbox2.3"),
                            width_in_digits = 3,
                            enabled = LrView.bind("secondCheckboxIsChecked"),
                            min = -100,
                            max = 100
                        },
                    },
                    f:row{
                        f:checkbox{     -- third checkbox with edit fields
                            title = "Highlights",
                            checked_value = true,
                            value = LrView.bind("thirdCheckboxIsChecked")
                        },
                        f:edit_field{
                            place_horizontal = 0.8,
                            value = LrView.bind("Checkbox3.1"),
                            width_in_digits = 3,
                            enabled = LrView.bind("thirdCheckboxIsChecked"),
                            min = -100,
                            max = 100
                        },
                        f:edit_field{
                            place_horizontal = 0.8,
                            value = LrView.bind("Checkbox3.2"),
                            width_in_digits = 3,
                            enabled = LrView.bind("thirdCheckboxIsChecked"),
                            min = -100,
                            max = 100
                        },
                        f:edit_field{
                            place_horizontal = 0.8,
                            value = LrView.bind("Checkbox3.3"),
                            width_in_digits = 3,
                            enabled = LrView.bind("thirdCheckboxIsChecked"),
                            min = -100,
                            max = 100
                        },
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
                MyHWLibraryItem.editPhotos()
               end
            } 
        }
        local result = LrDialogs.presentModalDialog({ --display cuustom dialog
            title = "Lightroom Plugin - Settings",
            contents = contents -- defined view hierarchy
          
        })
    end)
end
MyHWLibraryItem.importSelected()
MyHWLibraryItem.showcustomDialog()



