local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local file_string = kFile.read_file_to_string(Kontakt.script_path .. "/banner.txt")

print(file_string)
