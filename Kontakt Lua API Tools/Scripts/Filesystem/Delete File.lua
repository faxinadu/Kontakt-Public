local root_path = Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path))
package.path = root_path .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local file = root_path .. Filesystem.preferred("/Generated/1.wav")

kFile.delete_file(file)