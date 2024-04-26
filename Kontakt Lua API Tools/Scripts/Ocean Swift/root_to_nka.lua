----------------------------------------------------------------------------------------------------
-- Tutorial 05: MIR
----------------------------------------------------------------------------------------------------
--[[ 
Music Information Retrieval (MIR) is the science of retrieving information from music. 
Among others, it allows the extraction of information from audio files, such as the pitch or velocity of a sample.
The API comes with a collection of MIR functions, that can assist or automate parts of the instrument creation process.
Note that all functions live in the global MIR table.
--]]

-- Set a path to a directory containing example files.
local path = Filesystem.preferred(Kontakt.script_path .. "/root")

local dash_sep = "-------------------------------------------------"

function round_num(float_num) return math.floor(float_num + 0.5) end

local paths_table = {}
for _,p in Filesystem.recursive_directory(path) do
    if Filesystem.extension(p) == ".wav" then
        table.insert(paths_table,p)
    end
end

print("Found: " .. #paths_table .. " sample files")
print(dash_sep)

for k,v in pairs(paths_table) do
    -- It corresponds to the MIDI scale (69 = 440 Hz) and ranges from semitone 15 (~20Hz) to semitone 120 (~8.4 kHz).
    local pitch =  MIR.detect_pitch(v)
    
    print("Sample file " ..Filesystem.stem(v) .. " pitch " .. round_num(pitch))

    print(dash_sep)
end