local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.user_samples_path

local zone_count = 127

print("Searching for all sample files in: " .. path)
print("Working... this make take some time")
print("--------------------------------------------------")

local paths_table = kUtil.paths_to_table(path)

print("Found: " .. #paths_table .. " sample files")

Kontakt.reset_multi(0)
local instrument = Kontakt.add_instrument()
Kontakt.set_instrument_name(instrument,"Random Mapped " .. math.random(0,1000000))

print("Creating random mapped instrument: " .. Kontakt.get_instrument_name(instrument))
print("--------------------------------------------------")

for i=1, zone_count do
    local random_path = paths_table[math.random(#paths_table)]
    print("Loading random sample: " .. Filesystem.filename(random_path))
    local zone = Kontakt.add_zone(instrument,0,random_path)
    Kontakt.set_zone_low_key(instrument,zone,i)
    Kontakt.set_zone_high_key(instrument,zone,i)
    Kontakt.set_zone_root_key(instrument,zone,i)
end