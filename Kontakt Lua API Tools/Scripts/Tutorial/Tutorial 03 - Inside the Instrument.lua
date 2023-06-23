----------------------------------------------------------------------------------------------------
-- Tutorial 03: Inside the Instrument
----------------------------------------------------------------------------------------------------
--[[ 
On instrument level groups and zones can be edited. Zones have further access to loop information.
--]]

-- Reset the multi to start with a clean state.
Kontakt.reset_multi()

-- Set a filepath for an instrument, see tutorial 4 for additional Filesystem information.
local path = Filesystem.preferred(Kontakt.script_path .. "/assets/Example.nki")

-- Load the instrument using the filepath.
Kontakt.load_instrument(path)

-- get_file_info extracts information from an instrument. 
-- The returned table contains the fields: version, num_groups, library, format, num_instruments, num_zones and filename.
local file_info = Kontakt.get_file_info(path)
-- Lua pairs can be used to iterate over the table to print the content. For more info see https://www.lua.org/pil/7.3.html
for k,v in pairs(file_info) do
    print(k,v)
end

-- A seperator can be used to structure the printed output. 
-- The separator can be re-used by storing it in a variable.
local dash_sep = "-------------------------------------------------"
print(dash_sep)

-- The Lua API provides a set of get and set functions. 
-- For every getter there is usually a corresponding setter and vice versa.
-- These functions are used to set various parameters, and query their state.

-- Let's get information about groups, zones and loops.

-- Print information for any group of the instrument.
-- For loops in Lua use a simple syntax. For more info see https://www.lua.org/pil/4.3.4.html
for i=0,Kontakt.get_num_groups(0)-1 do
    print("Group " .. i .. " name: " .. Kontakt.get_group_name(0,i))
    print("Playback mode is: " .. Kontakt.get_group_playback_mode(0,i))
    print("Volume is: " .. Kontakt.get_group_volume(0,i))
    print("Tune is: " .. Kontakt.get_group_tune(0,i))
    print("Pan is: " .. Kontakt.get_group_pan(0,i))
    print(dash_sep)
end

-- For every zone in the instrument, print information about the zone.
for i=0,Kontakt.get_num_zones(0)-1 do
    -- Every zone belongs to a group.
    print("Zone belongs to Group: ".. Kontakt.get_zone_group(0,i))
    -- get_zone_geometry returns a table of key-value pairs with information about the zone mapping. See the manual for further info.
    local zone_geometry = Kontakt.get_zone_geometry(0,i)
    -- Lua pairs make it easy again to iterate the table and print the results.
    for k,v in pairs(zone_geometry) do
        print(k,v)
    end
    -- Additional information is available, e.g. the sample path. See the Lua API manual for all available zone functions.
    print("Sample: " .. Kontakt.get_zone_sample(0,i))
    -- The max_num_sample_loops constant is helpful to gather information of all loops.
    for x=0,Kontakt.max_num_sample_loops-1 do
        -- Check the manual for more information about available loop functions.
        -- If a loop mode is set for a sample, print the used mode, start and length of the loop. For more on Lua if see https://www.lua.org/pil/4.3.1.html
        if not (Kontakt.get_sample_loop_mode(0,i,x) == "off") then
            print("Loop mode: " .. Kontakt.get_sample_loop_mode(0,i,x))
            print("Loop start: " .. Kontakt.get_sample_loop_start(0,i,x))
            print("Loop length: " .. Kontakt.get_sample_loop_length(0,i,x))
        end
    end
    print(dash_sep)
end