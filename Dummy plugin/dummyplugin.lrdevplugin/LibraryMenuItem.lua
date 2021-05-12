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
    props.isChecked = false -- add a property key and initial value
    -- create view hierarchy
    local f = LrView.osFactory()
    local contents = f:column { -- create view hierarchy
        spacing = f:control_spacing(),
        bind_to_object = properties, -- default bound table is the one we made
        f:row { -- the root node
            fill_horizonal = 1,
            spacing = f:label_spacing(),
            -- add controls
            f:checkbox {
                title = "Enable", -- label text
                value = LrView.bind( "isChecked" ) -- bind button state to data key
                },
            f:slider {
                value = LrView.bind( "sliderOne" ),
                min = 0,
                max = 100,
                width = LrView.share( "slider_width" )
            },
    },
        f:row { -- the root node
                fill_horizonal = 1,
                spacing = f:label_spacing(),
                -- add controls
                f:checkbox {
                    title = "Enable", -- label text
                    value = LrView.bind( "isChecked" ) -- bind button state to data key
                    },
                f:slider {
                    value = LrView.bind( "sliderTwo" ),
                    min = 0,
                    max = 100,
                    width = LrView.share( "slider_width" )
                },
        },
        f:row { -- the root node
                fill_horizonal = 1,
                spacing = f:label_spacing(),
                -- add controls
                f:checkbox {
                    title = "Enable", -- label text
                    value = LrView.bind( "isChecked" ) -- bind button state to data key
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
                f:checkbox {
                    title = "Enable", -- label text
                    value = LrView.bind( "isChecked" ) -- bind button state to data key
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
                f:checkbox {
                    title = "Enable", -- label text
                    value = LrView.bind( "isChecked" ) -- bind button state to data key
                    },
                f:slider {
                    value = LrView.bind( "sliderFive" ),
                    min = 0,
                    max = 100,
                    width = LrView.share( "slider_width" )
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
