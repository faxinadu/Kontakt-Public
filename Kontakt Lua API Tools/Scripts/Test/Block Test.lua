
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
    -- get_zone_geometry returns a key-value pairs table with information about the zone mapping. See the manual for further info.
    local zone_geometry = Kontakt.get_zone_geometry(0,i)
    -- We can easily iterate over the table and print the results using Lua pairs as before.
    for k,v in pairs(zone_geometry) do
        print(k,v)
    end
    -- Additional getters are available, for example the sample path. See the Lua API manual for all available zone getters.
    print("Sample: " .. Kontakt.get_zone_sample(0,i))
    -- Let's check out the loop information. We can iterate all loops using the max_num_sample_loops constant.
    for x=0,Kontakt.max_num_sample_loops-1 do
        -- Print the mode. See the manual for all available loop getters.
        -- But.. let's apply some logic, and only print the mode if it is not off. For more on Lua if see https://www.lua.org/pil/4.3.1.html
        if not (Kontakt.get_sample_loop_mode(0,i,x) == "off") then
            print("Loop mode: " .. Kontakt.get_sample_loop_mode(0,i,x))
            print("Loop start: " .. Kontakt.get_sample_loop_start(0,i,x))
            print("Loop length: " .. Kontakt.get_sample_loop_length(0,i,x))
        end
    end
end

print(tostring(Kontakt.is_script_protected(0, 0)))

local script_text = Kontakt.get_script_source(0,0)
print(script_text)