local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")
local kFile = require("Modules.KFile")

Kontakt.colored_output = kUser.terminal_colored_output

--local path = "/Users/yaron.eshkar/Faxi/Sample Robot Exports/Spectral Oscs Vol 2 - Sorted No Tune Check BACKUP 270825 2000"
local path = "/Users/yaron.eshkar/Faxi/Sample Robot Exports/Spectral Oscs Vol 2 - Sorted No Tune Check BACKUP 270825 2000/Spectral Oscs Vol 2 - Dreamer Stash Roland JV1080/1Tone/0Untuned"

local move_untuned_files = false

print("Searching for all sample files in: " .. path)
print("Working... this make take some time")
print("--------------------------------------------------")

local paths_table = kUtil.paths_to_table(path)

print("Found: " .. #paths_table .. " sample files")
print("--------------------------------------------------")
print("The following files are not tuned to a C note:")
print("--------------------------------------------------")
print("--------------------------------------------------")

for k,v in pairs(paths_table) do
    local pitch = MIR.detect_pitch(v)
    local rounded = kUtil.round_even(pitch)
    -- print("Sample file " ..Filesystem.stem(v) .. " pitch " .. pitch)
    if rounded % 12 ~= 0 then
        print("Sample file " ..Filesystem.stem(v) .. " pitch rounded: " .. rounded)
        print("Sample file " ..Filesystem.stem(v) .. " pitch detect: " .. pitch)
        if move_untuned_files == true then
            local new_path = Filesystem.parent_path(v) .. "/0Untuned/" .. Filesystem.stem(v) .. ".wav"
            print ("Moving File to: " .. new_path)
            kFile.move_file(v, new_path)
    end
end

print("--------------------------------------------------")


