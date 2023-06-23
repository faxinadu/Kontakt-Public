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

local drum_table = {}
for k,v in pairs(paths_table) do
    local drum_type =  MIR.detect_drum_type(v)
    print("Checking sample: " .. Filesystem.stem(v))
    if MIR.detect_sample_type(v) == "drum" then
        if not (MIR.detect_drum_type(v) == "kick") then
            drum_table[k] = v
        end
    end
end

print("--------------------------------------------------")

if kUtil.table_size(drum_table) > 0 then 

    print("Found: " .. kUtil.table_size(drum_table) .. " drum samples")

    for k,v in pairs(drum_table) do
        print("Sample file " .. Filesystem.stem(v) .. " is a drum")
    end
    print("--------------------------------------------------")
else
    print("--------------------------------------------------")
    print("No drums found.")
end
print("--------------------------------------------------")


