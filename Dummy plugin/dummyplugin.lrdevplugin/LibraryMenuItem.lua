local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrColor = import 'LrColor'

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
