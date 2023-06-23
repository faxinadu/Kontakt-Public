----------------------------------------------------------------------------------------------------
-- Tutorial 07: Zone Level
----------------------------------------------------------------------------------------------------

-- Let's play with things learned in previous tutorials and start using tables and MIR. 

-- Let's first set a path to a directory containing the example files.
local path = Filesystem.preferred(Kontakt.script_path .. "/assets")

local dash_sep = "-------------------------------------------------"

-- Printing what is going to happen next.
print("Searching for all sample files in: " .. path)
print("Working... this make take some time")
print(dash_sep)

-- Let's define a table.
local paths_table = {}

-- This for loop will check for wav files and insert their paths into the table.
for _,p in Filesystem.recursive_directory(path) do
    -- Wav files only.
    if Filesystem.extension(p) == ".wav" then
        -- Grab instrument type samples only using MIR.
        if MIR.detect_sample_type(p) == "instrument" then
            table.insert(paths_table,p)
        else 
            print(Filesystem.stem(p) .. " is not an instrument")
        end
    end
end

-- Let's print how many sample files were found.
print("Found: " .. #paths_table .. " sample files with are instruments")
print(dash_sep)

-- Reset the Kontakt rack.
Kontakt.reset_multi()

-- Add an instrument.
instrument = Kontakt.add_instrument()

-- Let's insert the found samples into zones using the table.
-- In this case v represents the value of each table entry, ie a sample path.
for k,v in pairs(paths_table) do
    -- Add a zone with a sample.
    zone = Kontakt.add_zone(instrument,0,v)
    -- set_zone_geometry accepts mapping values based on key value pairs, each entry is optional. 
    -- See the manual for further info.
    Kontakt.set_zone_geometry(instrument,zone,{
        low_key_fade = 64,
        high_key_fade = 64,
        low_velocity_fade = 63
    })
    -- As an alternative, it is possible to set each value individually.
    Kontakt.set_zone_high_velocity_fade(instrument,zone,64)

    -- Besides the mapping geometry there are additional zone parameters available. See the manual for the full list.
    Kontakt.set_zone_volume(instrument,zone,5.3)
    Kontakt.set_zone_tune(instrument,zone,12.0)
    Kontakt.set_zone_pan(instrument,zone,85.0)

    -- Each zone can define up to 8 loops.
    -- MIR can be used to find loop points.
    local loop_start, loop_end = MIR.find_loop(v)

    -- Set loop points for samples where loop points were identified.
    if loop_start then
        -- Let's set one loop for each zone.
        Kontakt.set_sample_loop_mode(instrument,zone,0,"until_end")
        -- Calculate the length from loop start to loop end.
        local loop_length = loop_end - loop_start
        -- Set loop start and length.
        Kontakt.set_sample_loop_start(instrument,zone,0,loop_start)
        Kontakt.set_sample_loop_length(instrument,zone,0,loop_length)
        -- Add a bit of crossfading.
        Kontakt.set_sample_loop_xfade(instrument,zone,0,20)
    end
end

-- Zones can be removed, based on an instrument-wide index.
Kontakt.remove_zone(instrument,0)

-- Using the getters and the setters in tandem, parameters can be copied from one zone to another.
-- Print the samples from the first two zones.
print("Original files: ")
print(Kontakt.get_zone_sample(instrument,0))
print(Kontakt.get_zone_sample(instrument,1))
-- Let's put the same sample from the second zone, into the first.
Kontakt.set_zone_sample(instrument,0,Kontakt.get_zone_sample(instrument,1))
-- Print again.
print("Current files: ")
print(Kontakt.get_zone_sample(instrument,0))
print(Kontakt.get_zone_sample(instrument,1))

