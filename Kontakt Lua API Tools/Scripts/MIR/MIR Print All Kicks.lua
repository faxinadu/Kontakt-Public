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

print("Found: " .. kUtil.table_size(paths_table) .. " sample files")
print("--------------------------------------------------")

local kicks_table = {}
for k,v in pairs(paths_table) do
    local drum_type =  MIR.detect_drum_type(v)
    print("Checking sample: " .. Filesystem.stem(v))
    if MIR.detect_sample_type(v) == "drum" then
        if MIR.detect_drum_type(v) == "kick" then
            kicks_table[k] = v
        end
    end
end

print("--------------------------------------------------")

if kUtil.table_size(kicks_table) > 0 then 
    print("Found: " .. kUtil.table_size(kicks_table) .. " kick samples")

    for k,v in pairs(kicks_table) do
        print("Sample file " .. Filesystem.stem(v) .. " is a kick")
    end
else
    print("--------------------------------------------------")
    print("No kicks found. M8 do you even kick?")
end

print("--------------------------------------------------")


