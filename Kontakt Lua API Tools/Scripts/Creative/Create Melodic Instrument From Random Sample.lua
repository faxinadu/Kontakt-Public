local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.user_samples_path

print("Searching for all sample files in: " .. path)
print("Working... this make take some time")
print("--------------------------------------------------")

local paths_table = kUtil.paths_to_table(path)

local instruments_table = {}
for k,v in pairs(paths_table) do
    if MIR.detect_sample_type(v) == "instrument" and (MIR.detect_instrument_type(v) == "synth") then
        table.insert(instruments_table,v)
    end
end

print("Found: " .. #instruments_table .. " sample files")
print("--------------------------------------------------")

local random_path = instruments_table[math.random(#instruments_table)]

print("Loading random sample: " .. Filesystem.filename(random_path))

Kontakt.reset_multi(0)
local instrument = Kontakt.add_instrument()
Kontakt.set_instrument_name(instrument,Filesystem.stem(random_path))
local zone = Kontakt.add_zone(instrument,0,random_path)

