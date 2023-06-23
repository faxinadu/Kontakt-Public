----------------------------------------------------------------------------------------------------
-- Tutorial 09: Save and Import of Instruments and Snapshots
----------------------------------------------------------------------------------------------------
--[[ 
Import Lua code, saving of NKI files, loading and saving of snapshots.
--]]

-- Lua files can be imported to reuse functions, constants, tables and more.
-- The KUtil.lua file contains a number of functions, that will be used in this example.
local kUtil = require("KUtil")

-- Filepath to the samples.
local path = Filesystem.preferred(Kontakt.script_path .. "/assets/")

-- Filepath to the KSP script.
local ksp_path = Filesystem.preferred(Kontakt.script_path .. "/assets/envelope_and_filter_shell.ksp")

-- Print tutorial headline.
print("--------------------------------------------------")
print("KONTAKT INSTRUMENT CREATOR DEMO")
print("--------------------------------------------------")
-- Print the Kontakt banner art using the kontakt.banner() function from the KUtil.lua file.
print(kUtil.kontakt_banner())
-- Print information about the next actions.
print("Searching for all sample files in: " .. path)
print("Working... this make take some time")
print("--------------------------------------------------")

-- The function to search and store file paths in a table is also contained in the KUtil.lua file.
-- Using imports enables the resusability of code.
local paths_table = kUtil.paths_to_table(path,".wav")

-- Print the number of samples that have been found.
print("Found: " .. #paths_table .. " sample files")
print("--------------------------------------------------")

-- Reset Kontakt rack.
Kontakt.reset_multi()

-- Adding a new instrument to the rack.
local instrument = Kontakt.add_instrument()

-- Selecting a random sample from the paths table.
local random_path = paths_table[math.random(#paths_table)]

-- Add the zone with the sample.
local zone = Kontakt.add_zone(instrument,0,random_path)

-- Print the random sample that was used to create the instrument. 
print("Creating instrument from sample: " .. Filesystem.stem(random_path))

-- Let's use another function defined in the KUtil.lua file.
-- Reusing code is less error prone and improves the readability of scripts.
kUtil.set_instrument_script_source_string_from_file(instrument,0,ksp_path)

-- The instrument name can be set using the file name, stripping the path and file extension.
local instrument_name = Filesystem.stem(random_path)
Kontakt.set_instrument_name(instrument,instrument_name)

-- It is time to save the instrument. First set a path to save the content.
local save_base_path = Filesystem.preferred(Kontakt.script_path .. "/Generated/")
-- Some error handling, if the folder does not exist it will be created.
if not Filesystem.exists(save_base_path) then Filesystem.create_directory(save_base_path) end
-- Now let's set set the base path one level deeper, with the actual instrument name.
save_base_path = Filesystem.preferred(Kontakt.script_path .. "/Generated/" .. instrument_name)

-- When saving a patch with samples, it needs to be confirmed that the target folders exist.
-- If not the folders are created.
-- A folder for wav files.
if not Filesystem.exists(Filesystem.preferred(save_base_path .. "_samples_wav")) then Filesystem.create_directory(Filesystem.preferred(save_base_path .. "_samples_wav")) end
-- A folder for the compressed NCW file.
if not Filesystem.exists(Filesystem.preferred(save_base_path .. "_samples_ncw")) then Filesystem.create_directory(Filesystem.preferred(save_base_path .. "_samples_ncw")) end

-- Print what happens next.
print("Saving instrument with various settings...")

-- Save the patch only as NKI.
Kontakt.save_instrument(0,Filesystem.preferred(save_base_path .. "_patch.nki"))

-- Save the patch and samples. 
-- The table is an optional argument in which different save options can be set.
Kontakt.save_instrument(0,Filesystem.preferred(save_base_path .. "_samples.nki"),
    {
        mode = 'samples',
        absolute_paths = false,
        compress_samples = false,
        samples_sub_dir = Filesystem.preferred(save_base_path .. "_samples_wav"),
    }
)

-- Save patch, samples and compress the samples to NCW.
Kontakt.save_instrument(0,Filesystem.preferred(save_base_path .. "_samples_ncw.nki"),
    {
        mode = 'samples',
        absolute_paths = false,
        compress_samples = true,
        samples_sub_dir = Filesystem.preferred(save_base_path .. "_samples_ncw"),
    }
)

-- Save NKI monolith with wav files.
Kontakt.save_instrument(0,Filesystem.preferred(save_base_path .. "_monolith.nki"),
    {
        mode = 'monolith',
        compress_samples = false
    }
)

-- Save NKI monolith with NCW files.
Kontakt.save_instrument(0,Filesystem.preferred(save_base_path .. "_monolith_ncw.nki"),
    {
        mode = 'monolith',
        compress_samples = true
    }
)

-- The API allows to load and save snapshots.
print("Saving snapshots...")

-- Check for the snapshots folder, if not create it. 
-- The usage of the default snapshot path constant ensures that the script runs on different systems.
if not Filesystem.exists(Filesystem.preferred(Kontakt.snapshot_path .. "Kontakt/" .. instrument_name .. "_monolith_ncw")) then Filesystem.create_directory(Filesystem.preferred(Kontakt.snapshot_path .. "Kontakt/" .. instrument_name .. "_monolith_ncw")) end
-- Looping and saving of 30 snapshots. 
-- In this example the snapshots are all identical.
for i=1,30,1 do
    Kontakt.save_snapshot(0,Filesystem.preferred(Kontakt.snapshot_path .. "Kontakt/" .. instrument_name .. "_monolith_ncw" .. "/Snapshot " .. i .. ".nksn"))    
end
-- Recall the first snapshot.
Kontakt.load_snapshot(0,Filesystem.preferred(Kontakt.snapshot_path .. "Kontakt/" .. instrument_name .. "_monolith_ncw" .. "/Snapshot 1.nksn"))
