local root_path = Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path))
package.path = root_path .. "/?.lua;" .. package.path

local kAudio = require("Modules.KAudio")
local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local samples_root_path = kUser.framework_samples_path

local sample_paths = {
    samples_root_path .. "/loop.wav",
    samples_root_path .. "/no_loop.wav"
}

for k,v in pairs(sample_paths) do
    print("Checking file:  " .. Filesystem.stem(v))
    if kAudio.get_loop_points(v) then 
        local loop_start, loop_end, loop_length = kAudio.get_loop_points(v)
        print("Loop Start: ".. loop_start)
        print("Loop End: ".. loop_end)
        print("Loop Length: "..loop_length)
    else
        print("No loops found")
    end
end
