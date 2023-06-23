----------------------------------------------------------------------------------------------------
-- Tutorial 10: Instrument with Wavetables
----------------------------------------------------------------------------------------------------
--[[ 
Example instrument, using Kontakt's factory wavetables.
--]]

-- Include the KUtil.lua script file.
local kUtil = require("KUtil")

-- Path to the Kontakt factory wavetables. 
local path = Filesystem.preferred(Kontakt.factory_path .. "/groups/Wavetables/")

-- Path to the KSP script. 
-- This prepared script creates a basic wavetable instrument.
local ksp_path = Filesystem.preferred(Kontakt.script_path .. "/assets/wavetable_amp_envelope_shell.ksp")

-- Reset Kontakt rack.
Kontakt.reset_multi()

-- Add an instrument.
local instrument = Kontakt.add_instrument()

-- Load a group of NKG files.
local paths_table = kUtil.paths_to_table(path,".nkg")

-- Print how many groups were found.
print("Found: " .. #paths_table .. " group files")

-- Iterate through the table, adding a group for each wavetable and load the NKG file into it.
for k,v in pairs(paths_table) do
    -- Add the group.
    local group = Kontakt.add_group(instrument)
    -- Load the nkg file into the group.
    Kontakt.load_group(instrument,group,v)
end

-- Since the above loop was used to add and load the groups, there is an empty default group.
-- This group can be removed.
Kontakt.remove_group(instrument,0)

-- Apply the KSP script.
kUtil.set_instrument_script_source_string_from_file(instrument,0,ksp_path)

-- Name the instrument.
local instrument_name = "Instrument with Wavetables"
Kontakt.set_instrument_name(instrument,instrument_name)

-- Save the instrument. First prepare a folder to save the content.
local save_base_path = Filesystem.preferred(Kontakt.script_path .. "/Generated/")
-- Error handling, if the folder does not exist then it will be created.
if not Filesystem.exists(save_base_path) then Filesystem.create_directory(save_base_path) end
-- Now let's set the base path one level deeper, with the actual instrument name.
save_base_path = Filesystem.preferred(Kontakt.script_path .. "/Generated/" .. instrument_name)

-- This instrument uses only wavetables from the Kontakt factory library.
-- Only the NKI patch needs to be saved.
Kontakt.save_instrument(0,Filesystem.preferred(save_base_path .. ".nki"))

