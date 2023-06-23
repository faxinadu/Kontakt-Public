local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

print("--------------------------------------------------------------------")
print("--------------------------------------------------------------------")

print("Instruments loaded: " .. Kontakt.get_num_instruments(0))

local indices = Kontakt.get_instrument_indices()
for index, instrument_index in pairs(indices) do
    print(index, instrument_index, Kontakt.get_instrument_name(instrument_index))
end
