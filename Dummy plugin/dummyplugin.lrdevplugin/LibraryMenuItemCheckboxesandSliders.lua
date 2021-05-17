local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrColor = import 'LrColor'

-- require 'json'
local json = loadfile("D:/Uni/teamproject-photography/Dummy plugin/dummyplugin.lrdevplugin/json.lua")()
local open = io.open

local function read_file(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

local fileContent = read_file("D:/Uni/teamproject-photography/Dummy plugin/dummyplugin.lrdevplugin/config.json");
-- print (fileContent);
-- print (fileContent);
local configFile = json.decode(fileContent);

MyDummyPluginLibraryItem = {}
function MyDummyPluginLibraryItem.showCustomDialogWithSliders()
    -- body of show-dialog function
    LrFunctionContext.callWithContext("showCustomDialogSlider", function(context)
        -- body of called function
        local tableOne = LrBinding.makePropertyTable(context) -- create bound tables
        local tableTwo = LrBinding.makePropertyTable(context)

        -- initial boolean value for each slider (data key)
        tableOne.sliderOneischecked = false
        tableOne.sliderTwoischecked = false
        tableOne.sliderThreeischecked = false
        tableTwo.sliderOneischecked = false
        tableTwo.sliderTwoischecked = configFile.testConfig

        -- create view hierarchy
        local f = LrView.osFactory() -- get view factory object
        local contents = f:column{      -- view hierarchy

            bind_to_object = tableOne,  -- bind tableOne
            spacing = f:control_spacing(),
            f:group_box{                -- group box for Tone settings
                title = "Tone",
                font = "<system>",

                f:row{f:checkbox{       -- Create Checkbox
                    title = "Contrast", -- label text
                    checked_value = true,   --when control value matches this, the checkboy is checked
                    value = LrView.bind("sliderOneischecked") -- bind button state to data key
                }, f:edit_field{            -- Create Edit field
                    place_horizontal = 0.5,
                    value = LrView.bind("Slider One"),
                    width_in_digits = 7,
                    enabled = LrView.bind("sliderOneischecked")
                }, f:slider{            -- Create Slider
                    value = LrView.bind("Slider One"),
                    min = 0,
                    max = configFile.testMax,
                    enabled = LrView.bind("sliderOneischecked")
                }},

                f:row{f:checkbox{
                    title = "Exposure", -- label text
                    checked_value = true,
                    value = LrView.bind("sliderTwoischecked") -- bind button state to data key
                }, f:edit_field{
                    place_horizontal = 0.5,
                    value = LrView.bind("Slider Two"),
                    width_in_digits = 7,
                    enabled = LrView.bind("sliderTwoischecked")
                }, f:slider{
                    value = LrView.bind("Slider Two"),
                    min = 0,
                    max = 100,
                    enabled = LrView.bind("sliderTwoischecked")
                }},

                f:row{f:checkbox{
                    title = "Highlights", -- label text
                    checked_value = true,
                    value = LrView.bind("sliderThreeischecked") -- bind button state to data key
                }, f:edit_field{
                    place_horizontal = 0.5,
                    value = LrView.bind("Slider Three"),
                    width_in_digits = 7,
                    enabled = LrView.bind("sliderThreeischecked")
                }, f:slider{
                    value = LrView.bind("Slider Three"),
                    min = 0,
                    max = 100,
                    enabled = LrView.bind("sliderThreeischecked")
                }}

            },

            f:group_box{     -- group box for Presence settings
                title = "Presence",
                font = "<system>",

                f:row{f:checkbox{
                    bind_to_object = tableTwo,
                    title = "Saturation", -- label text
                    value = LrView.bind("sliderOneischecked") -- bind button state to data key
                }, f:edit_field{
                    bind_to_object = tableTwo,
                    place_horizontal = 0.5,
                    value = LrView.bind("Slider One"),
                    width_in_digits = 7,
                    enabled = LrView.bind("sliderOneischecked")
                }, f:slider{
                    bind_to_object = tableTwo,
                    value = LrView.bind("Slider One"),
                    min = 0,
                    max = 100,
                    enabled = LrView.bind("sliderOneischecked")
                }},
                
                f:row{f:checkbox{
                    bind_to_object = tableTwo,
                    title = "Vibrance", -- label text
                    value = LrView.bind("sliderTwoischecked") -- bind button state to data key
                }, f:edit_field{
                    bind_to_object = tableTwo,
                    place_horizontal = 0.5,
                    value = LrView.bind("Slider Two"),
                    width_in_digits = 7,
                    enabled = LrView.bind("sliderTwoischecked")
                }, f:slider{
                    bind_to_object = tableTwo,
                    value = LrView.bind("Slider Two"),
                    min = 0,
                    max = 100,
                    enabled = LrView.bind("sliderTwoischecked")
                }}
            },

            f:group_box{          -- group box for summary of all changed settings
                title = "Changed Settings",
                font = "<system>",
                f:static_text{      -- Text bind to first slider, appears if checkbox is checked
                    text_color = LrColor(0, 0, 0),
                    title = LrView.bind {
                        key = "sliderOneischecked",
                        transform = function(value, fromTable)
                            if value == true then
                                return "Contrast"
                            else
                                return
                            end
                        end
                    }
                },
                f:static_text{  -- Text bind to second slider, appears if checkbox is checked
                    text_color = LrColor(0, 0, 0),
                    title = LrView.bind {
                        key = "sliderTwoischecked",
                        transform = function(value, fromTable)
                            if value == true then
                                return "Exposure"
                            else
                                return
                            end
                        end
                    }
                },
                f:static_text{  -- Text bind to third slider, appears if checkbox is checked
                    text_color = LrColor(0, 0, 0),
                    title = LrView.bind {
                        key = "sliderThreeischecked",
                        transform = function(value, fromTable)
                            if value == true then
                                return "Highlights"
                            else
                                return
                            end
                        end
                    }
                },
                f:static_text{  -- Text bind to fourth slider, appears if checkbox is checked
                    bind_to_object = tableTwo,
                    text_color = LrColor(0, 0, 0),
                    title = LrView.bind {
                        key = "sliderOneischecked",
                        transform = function(value, fromTable)
                            if value == true then
                                return "Saturation"
                            else
                                return
                            end
                        end
                    }
                },
                f:static_text{  -- Text bind to fifth slider, appears if checkbox is checked
                    bind_to_object = tableTwo,
                    text_color = LrColor(0, 0, 0),
                    title = LrView.bind {
                        key = "sliderTwoischecked",
                        transform = function(value, fromTable)
                            if value == true then
                                return "Vibrance"
                            else
                                return
                            end
                        end
                    }
                }

            }
        }

        local result = LrDialogs.presentModalDialog({
            title = "Dummy Plugin - Settings",
            contents = contents -- view hierarchy
            
        })
    end)
end
MyDummyPluginLibraryItem.showCustomDialogWithSliders()
