local LrFileUtils = import 'LrFileUtils'

local ExportPhotos = {}

function ExportPhotos.makeDirectory(new_dir)
    LrFileUtils.createDirectory(new_dir)

end

return ExportPhotos
