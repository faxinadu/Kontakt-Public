----------------------------------------------------------------------------------------------------
-- Tutorial 12: Instrument Header And Creating a Multi
----------------------------------------------------------------------------------------------------
--[[ 

--]]

-- Lua files can be imported to reuse functions, constants, tables and more.
-- The KUtil.lua file contains a number of functions, that will be used in this example.
local kUtil = require("KUtil")

-- Reset Kontakt rack.
Kontakt.reset_multi()

-- Name the multi.
Kontakt.set_multi_name("Amazing Multi")

-- This time we will use a table to store our instrument indexes.
local instruments = {}

-- Add the center instrument.
table.insert(instruments,Kontakt.add_instrument())

-- Set the MIDI channel for the instrument. If the number is out of range, it will default to omni.
Kontakt.set_instrument_midi_channel(instruments[1],0)
-- Should the instrument be muted.
Kontakt.set_instrument_mute(instruments[1],false)
-- The instrument's name.
Kontakt.set_instrument_name(instruments[1],"Center Instrument")
-- Set the output channel for the instrument. If the channel does not exist, it will default to the first output.
Kontakt.set_instrument_output_channel(instruments[1],1)
-- Set the panning for the instrument from -100 to 100 with 0 being the center.
Kontakt.set_instrument_pan(instruments[1],0)
-- Set the number of voices available to the instrument.
Kontakt.set_instrument_polyphony(instruments[1],32)
-- Should the instrument be soloed.
Kontakt.set_instrument_solo(instruments[1],false)
-- Set the tune for the instrument.
Kontakt.set_instrument_tune(instruments[1],0)
-- Set the instrument volume.
Kontakt.set_instrument_volume(instruments[1],-6)

-- Add the left instrument. Any parameter where the default is not changed does not need to be explicitly set.
table.insert(instruments,Kontakt.add_instrument())
Kontakt.set_instrument_midi_channel(instruments[2],0)
Kontakt.set_instrument_name(instruments[2],"Left Instrument")
Kontakt.set_instrument_pan(instruments[2],-50)
Kontakt.set_instrument_tune(instruments[2],-12)
Kontakt.set_instrument_volume(instruments[2],-8)

-- Add the right instrument.
table.insert(instruments,Kontakt.add_instrument())
Kontakt.set_instrument_midi_channel(instruments[3],0)
Kontakt.set_instrument_name(instruments[3],"Right Instrument")
Kontakt.set_instrument_pan(instruments[3],50)
Kontakt.set_instrument_tune(instruments[3],-12)
Kontakt.set_instrument_volume(instruments[3],-8)

-- Add the top instrument.
table.insert(instruments,Kontakt.add_instrument())
Kontakt.set_instrument_midi_channel(instruments[4],0)
Kontakt.set_instrument_name(instruments[4],"Top Instrument")
Kontakt.set_instrument_pan(instruments[4],0)
Kontakt.set_instrument_tune(instruments[4],24)
Kontakt.set_instrument_volume(instruments[4],-10)

-- Add the bottom instrument.
table.insert(instruments,Kontakt.add_instrument())
Kontakt.set_instrument_midi_channel(instruments[5],0)
Kontakt.set_instrument_name(instruments[5],"Bottom Instrument")
Kontakt.set_instrument_pan(instruments[5],0)
Kontakt.set_instrument_tune(instruments[5],-24)
Kontakt.set_instrument_volume(instruments[5],-10)

-- Path to the Kontakt factory wavetables. 
local path = Filesystem.preferred(Kontakt.factory_path .. "/groups/Wavetables/")

-- Load a group of NKG files.
local paths_table = kUtil.paths_to_table(path,".nkg")

-- Path to the KSP script. 
-- This prepared script creates a basic wavetable instrument.
local ksp_path = Filesystem.preferred(Kontakt.script_path .. "/assets/wavetable_amp_envelope_shell.ksp")

for i=1,Kontakt.get_num_instruments() do
    -- Load the nkg file into the group.
    Kontakt.load_group(instruments[i],0,paths_table[i])
    kUtil.set_instrument_script_source_string_from_file(instruments[i],0,ksp_path)
end

-- It is possible to set the KSP script on the multi level as well.
ksp_path = Filesystem.preferred(Kontakt.script_path .. "/assets/chord_multi_version.ksp")
kUtil.set_multi_script_source_string_from_file(0,ksp_path)

-- We would like to save our instrument. We prepare a folder where we will save it.
local save_base_path = Filesystem.preferred(Kontakt.script_path .. "/Generated/")
-- Some error handling, if this folder does not exist then create it.
if not Filesystem.exists(save_base_path) then Filesystem.create_directory(save_base_path) end

-- Prepare the file path for saving the multi.
local file = Filesystem.preferred(save_base_path .. "/" .. Kontakt.get_multi_name() .. ".nkm")

-- Save the multi, in this case as a monolith with the samples compressed to NCW.
Kontakt.save_multi(file,{mode = "monolith", compress_samples = true})

-- Reset Kontakt rack.
Kontakt.reset_multi()

-- Load the saved multi back into the rack.
Kontakt.load_multi(file)

