local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local dash_sep = "--------------------------------------------------------------------"

print(dash_sep)

print("Multi: " .. Kontakt.get_multi_name(0))
print("Instruments loaded: " .. Kontakt.get_num_instruments(0))
local indices = Kontakt.get_instrument_indices()
for index, instrument_index in pairs(indices) do
    print(dash_sep)
    print("Instrument at index " .. index .. " name: " .. Kontakt.get_instrument_name(instrument_index))
    print("Number of groups: " .. Kontakt.get_num_groups(instrument_index))
    print("Number of zones: " .. Kontakt.get_num_zones(instrument_index))
    for i=0,Kontakt.get_num_groups(instrument_index)-1 do
        print(dash_sep)
        print("Group " .. i .. " name: " .. Kontakt.get_group_name(instrument_index,i))
        print("Group source mode: " .. Kontakt.get_group_playback_mode(instrument_index,i))
        for x=0,Kontakt.get_num_zones(instrument_index)-1 do
            if Kontakt.get_zone_group(instrument_index,x) == i then
                print(Kontakt.get_zone_sample(instrument_index,x))
            end
        end
    end
end
print(dash_sep)