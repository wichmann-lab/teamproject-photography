local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrColor = import 'LrColor'
------------------------------------------------------------------------------------------------------
--Version mit "Update Text"--
------------------------------------------------------------------------------------------------------
--[[ MyDummyPluginLibraryItem = {}
function MyDummyPluginLibraryItem.showCustomDialogWithObserver()
-- body of show-dialog function
LrFunctionContext.callWithContext( "showCustomDialogWithObserver", function( context )
    -- body of called function
    local props = LrBinding.makePropertyTable( context ) -- create bound table
    props.myObservedString = "This is a string" -- new prop with initial value
    --props.isChecked = false -- add a property key and initial value
    -- create view hierarchy
    local f = LrView.osFactory()
    local showValue_st = f:static_text { -- create the label control
    title = props.myObservedString,-- set text to the static property value
    text_color = LrColor( 1, 0, 0 ) -- set color to a new color object
    }
    local updateField = f:edit_field { -- create an edit box
    value = "Enter some text", -- initial text, not bound to data
    immediate = true -- update value with every keystroke
    }
    local myCalledFunction = function()
        showValue_st.title = updateField.value -- reflect the value entered in edit box
        showValue_st.text_color = LrColor( 1, 0, 0 ) -- make the text red
        end
    props:addObserver( "myObservedString", myCalledFunction )
    local c = f:column { --The top-level container, arranges all the rows vertically
    f:row { -- a group of labels arranged horizontally
        fill_horizontal = 1, -- the row fills its parent’s width
        f:static_text { -- add a right-aligned label
            alignment = "right",
            width = LrView.share "label_width", -- all get the same width
            title = "Bound value: "
        },
        showValue_st, -- the text box we already defined
        }, -- end f:row
    f:row { -- another group, a labeled edit box and button
        f:static_text {
            alignment = "right",
            width = LrView.share "label_width", -- shared with other label
            title = "New value: "
        },
        updateField, -- the edit box we already defined
        -- add push button
        f:push_button {
            title = "Update",
            action = function() -- when clicked, reset values in other controls
                showValue_st.text_color = LrColor( 0, 0, 0 ) -- make text black
                props.myObservedString = updateField.value -- reset data value
                -- from current entered value
            end
            },
    }, -- end row
    } -- end column
    local result = LrDialogs.presentModalDialog {
        title = "Custom Dialog",
        contents = c, -- the view hierarchy we defined
        }
    end )
end
MyDummyPluginLibraryItem.showCustomDialogWithObserver()]]
------------------------------------------------------------------------------------------------------
--Version mit den Slider--
------------------------------------------------------------------------------------------------------
MyDummyPluginLibraryItem = {}
function MyDummyPluginLibraryItem.showCustomDialog()
-- body of show-dialog function
LrFunctionContext.callWithContext( "showCustomDialog", function( context )
    -- body of called function
    local props = LrBinding.makePropertyTable( context ) -- create bound table
    local tableOne = LrBinding.makePropertyTable( context )
    local tableTwo = LrBinding.makePropertyTable( context )
    tableOne.sliderLightExposure = false
    tableOne.sliderLightContrast = false
    -- create view hierarchy
    local f = LrView.osFactory()

    local contents = f:column { -- create view hierarchy
        bind_to_object = tableOne, -- default bound table is the one we made
        spacing = f:control_spacing(),
        f:group_box { -- the root node for Light
            title="Light",
            font="<system>",
                f:row {
                    fill_horizonal = 1,
                    spacing = f:control_spacing(),
                    -- add controls
                    f:radio_button {
                        title = "Exposure", -- label text
                        value = LrView.bind( "sliderLightExposure" ),
                        checked_value="one"
                    },

                    f:slider {
                        enabled= LrView.bind("sliderLightExposure"),
                        value = LrView.bind( "sliderLightExposure" ),
                        min = 0,
                        max = 100,
                        width = LrView.share( "slider_width" ),
                        title= "slider titel 1"
                        
                    },
                },
                f:row {
                    fill_horizonal = 1,
                    spacing = f:label_spacing(),
                    -- add controls
                    f:radio_button {
                        title = "Contrast", -- label text
                        value = LrView.bind( "sliderLightContrast" ),
                        checked_value="two"
                    },
                    f:slider {
                        enabled= LrView.bind("sliderLightContrast"),
                        value = LrView.bind( "sliderLightContrast" ),
                        min = 0,
                        max = 100,
                        width = LrView.share( "slider_width" )
                    },
                },
        },

        f:row{
            f:group_box { -- the root node
                title="Color Red",
                font="<system>",
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Hue",
                            checked_value="three"
                        },
                        f:slider {
                            value = LrView.bind( "sliderRedHue" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Saturation",
                            checked_value="four"
                        },
                        f:slider {
                            value = LrView.bind( "sliderRedSaturation" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Luminance",
                            checked_value="five"
                        },
                        f:slider {
                            value = LrView.bind( "sliderRedLuminance" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
        },
            f:group_box { -- the root node
                title="Color Orange",
                font="<system>",
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Hue",
                            checked_value="three"
                        },
                        f:slider {
                            value = LrView.bind( "SliderOrangeHue" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Saturation",
                            checked_value="four"
                        },
                        f:slider {
                            value = LrView.bind( "sliderOrangeSaturation" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Luminance",
                            checked_value="five"
                        },
                        f:slider {
                            value = LrView.bind( "sliderOrangeLuminance" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
            },
            f:group_box { -- the root node
                title="Color Yellow",
                font="<system>",
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Hue",
                            checked_value="three"
                        },
                        f:slider {
                            value = LrView.bind( "sliderYellowHue" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Saturation",
                            checked_value="four"
                        },
                        f:slider {
                            value = LrView.bind( "sliderYellowSaturation" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Luminance",
                            checked_value="five"
                        },
                        f:slider {
                            value = LrView.bind( "slideryellowLuminance" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
            },
        },

        f:group_box { -- the root node
                title="Effects",
                font="<system>",
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Structure",
                            checked_value="three"
                        },
                        f:slider {
                            value = LrView.bind( "sliderThree" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Grain",
                            checked_value="four"
                        },
                        f:slider {
                            value = LrView.bind( "sliderFour" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
                f:row { -- the root node
                        fill_horizonal = 1,
                        spacing = f:label_spacing(),
                        -- add controls
                        f:radio_button {
                            title = "Vignette",
                            checked_value="five"
                        },
                        f:slider {
                            value = LrView.bind( "sliderFive" ),
                            min = 0,
                            max = 100,
                            width = LrView.share( "slider_width" )
                        },
                },
            },
    }
    
            local result = LrDialogs.presentModalDialog(
                {
                title = "Dummy Plugin",
                contents = contents, -- the view hierarchy we defined
                }
            )                 
    end)
end
MyDummyPluginLibraryItem.showCustomDialog()
