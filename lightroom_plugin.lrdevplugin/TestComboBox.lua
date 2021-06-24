local LrBinding = import "LrBinding"
local LrDialogs = import "LrDialogs"
local LrFunctionContext = import "LrFunctionContext"
local LrStringUtils = import "LrStringUtils"
local LrView = import "LrView"
local bind= LrView.bind
-- Create an observable table within a function context.
LrFunctionContext.callWithContext('bindingExample', function(context)
    -- Obtain the view factory.
    local f = LrView.osFactory()
    -- Create the observable table.
    local properties = LrBinding.makePropertyTable(context)
    -- Add an observer of the storeValue property.
    
    -- Create the view hierarchy for the dialog.
    local contents = f:column{
        spacing = f:control_spacing(),
        bind_to_object = properties, -- bound to the table we created
        f:group_box { 
            title = "Popup Menu", 
            fill_horizontal = 1, 
            spacing = f:control_spacing(),
            f:popup_menu {
            value = bind 'my_value', -- current value bound to same key as static text
            items = { -- the menu items and their values
            { title = "Value 1", value = 'value_1' },
            { title = "Value 2", value = 'value_2' },
            { title = "Value 3", value = 'value_3' },
            }
            },
            f:static_text { 
            fill_horizontal = 1,
            title = bind 'my_value', -- bound to same key as current selection
            },
            }
    }
    -- Display the dialog.
    local result = LrDialogs.presentModalDialog({
        title = "Dialog Example",
        contents = contents
    })
end)
