local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

print ("Kontakt version is: " .. Kontakt.version)
print ("Maximum number of groups in this version is " .. Kontakt.max_num_groups)
print ("Maximum number of zones in this version is " .. Kontakt.max_num_zones)