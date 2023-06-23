local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local ksp_script_string = kFile.read_file_to_string(kUser.signet_path .. "simple_on_init.ksp")

Kontakt.reset_multi(0)
local instrument = Kontakt.add_instrument()
Kontakt.set_script_source(instrument,0,ksp_script_string)

