----------------------------------------------------------------------------------------------------
-- Tutorial 06: Group Level
----------------------------------------------------------------------------------------------------

-- Clear Kontakt rack and add an instrument.
Kontakt.reset_multi()
instrument = Kontakt.add_instrument()

-- Add a group.
Kontakt.add_group(instrument)

-- Print the number of groups. There should be two groups.
print("Instrument has: " .. Kontakt.get_num_groups(instrument) .. " groups")

-- Add another group.
Kontakt.add_group(instrument)

-- Let's set some group properties.
-- Remember, Kontakt is zero based so our third group is 2.
Kontakt.set_group_name(instrument,2,"Awesome Group")
Kontakt.set_group_playback_mode(instrument,2,"sampler")
Kontakt.set_group_pan(instrument,2,86.0)
Kontakt.set_group_tune(instrument,2,12.0)
Kontakt.set_group_volume(instrument,2,5.5)

-- Print out the group properties that have been set before.
print("Group " .. 2 .. " name: " .. Kontakt.get_group_name(instrument,2))
print("Playback mode is: " .. Kontakt.get_group_playback_mode(instrument,2))
print("Volume is: " .. Kontakt.get_group_volume(instrument,2))
print("Tune is: " .. Kontakt.get_group_tune(instrument,2))
print("Pan is: " .. Kontakt.get_group_pan(instrument,2))

-- Groups can be removed.
Kontakt.remove_group(instrument,1)

-- Let's confirm that group 2 has been removed. The group that has been edited before is now group 1!
print("Group " .. 1 .. " name: " .. Kontakt.get_group_name(instrument,1))

-- NKG group files can be saved and loaded. 
-- First we save the group. The group can be saved with various options, see the manual for full details.
-- In this example a monolith group will be saved and the samples get compressed to NCW format.
Kontakt.save_group(instrument,1,Filesystem.join(Kontakt.script_path,"my_api_with_monolith_ncw.nkg"),{
    mode = 'monolith',
    compress_samples = true,
  }
)

-- As a demonstration, lets load that group back into the instrument. 
-- First group 2 is created again. The group will be loaded on to the existing group 2.
Kontakt.add_group(instrument)
-- Here is a showcase of an option that prevents the replacement of zones, see the manual for more details.
Kontakt.load_group(instrument,2,Filesystem.join(Kontakt.script_path,"my_api_with_monolith_ncw.nkg"), {replace_zones = false})

-- Group 1 and group 2 should be identical, let's check.
if Kontakt.get_group_pan(instrument,1) == Kontakt.get_group_pan(instrument,2) then
    print("Pan of group 1 is identical to group 2 and is: " .. Kontakt.get_group_pan(instrument,1))
else
    print("Hmmm what did we do wrong?")
end

-- The filesystem API can be used to remove the NKG group file.
Filesystem.remove(Filesystem.join(Kontakt.script_path,"my_api_with_monolith_ncw.nkg"))