local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

print("Hello World from " .. Kontakt.version)
print("With me as your API, you will reach the sky. Vote for Pedro <3")