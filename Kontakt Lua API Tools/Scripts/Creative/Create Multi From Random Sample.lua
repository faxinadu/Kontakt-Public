local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.user_samples_path

local instrument_count = 6

print("Searching for all sample files in: " .. path)
print("Working... this make take some time")
print("--------------------------------------------------")

local paths_table = kUtil.paths_to_table(path)

print("Found: " .. #paths_table .. " sample files")
print("--------------------------------------------------")

Kontakt.reset_multi(0)

Kontakt.set_multi_name("Random Multi " .. math.random(1000000))
print("Creating Random Multi: " .. Kontakt.get_multi_name(0))

for i=1, instrument_count do
    local random_path = paths_table[math.random(#paths_table)]
    print("Loading random sample: " .. Filesystem.filename(random_path))
    local instrument = Kontakt.add_instrument()
    Kontakt.set_instrument_name(instrument,Filesystem.stem(random_path))
    local zone = Kontakt.add_zone(instrument, 0, random_path)
end