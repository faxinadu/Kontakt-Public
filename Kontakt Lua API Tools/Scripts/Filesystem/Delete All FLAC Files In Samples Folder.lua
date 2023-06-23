local root_path = Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path))
package.path = root_path .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUtil = require("Modules.KUtil")
local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.framework_samples_path

local paths_table = kUtil.paths_to_table(path,".flac",false)

for k,v in pairs(paths_table) do
    kFile.delete_file(v)
    print("Deleted: " .. v)
end