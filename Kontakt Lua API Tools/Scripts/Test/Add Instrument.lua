local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local add_count = 5

Kontakt.reset_multi(0)

for i=0, add_count do
    local instrument = Kontakt.add_instrument()
    print("Instrument Slot ID:" .. instrument)
end


