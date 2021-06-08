--============================SDK===============================--
local LrView = import 'LrView'
local prefs = import 'LrPrefs'
--local logger = import'LrLogger'('BlogAPI')
--==============================================================--
ExportDialogs = {}

local function updateProperties(propertyTable)
    local preferences = prefs.prefsForPlugin()

    if propertyTable.editedPhotos ~= nil then
        preferences.editedPhotos = propertyTable.editedPhotos
    end

end

function ExportDialogs.startDialog(propertyTable)
    local preferences = prefs.prefsForPlugin()
    propertyTable.editedPhotos = preferences.editedPhotos
    propertyTable:addObserver('editedPhotos', updateProperties)

end

function ExportDialogs.endDialog(propertyTable)

end


function ExportDialogs.sectionsForTopOfDialog( _, propertyTable )
    local f = LrView.osFactory()

    local result = {
        {
        title = "Exporting edited photos into matrix modification",
        synopsis = LrView.bind{key = 'fullPath', object = propertyTable }, --?? hab ich mal übernommen
        f:row{
            f:static_text {
                title = "Path for matrix format"
            },
            f:edit_field {
                value = LrView.bind('pathToFolder'),
                enabled = true,
                immediate= true,
                fill_horizontal = 1
            }
        }
        },
    }
  
    return result
  
end
return ExportDialogs