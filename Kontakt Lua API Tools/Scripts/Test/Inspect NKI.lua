local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

Kontakt.reset_multi()

local file = '/Users/Shared/Bioscape/Instruments/Bioscape.nki'
local info = Kontakt.get_file_info(file)

for k,v in pairs(info) do
    print(k,v)
end

print("Created by: " .. info["version"])
