----------------------------------------------------------------------------------------------------
-- Creator Tools LUA Zone Utilities File 
----------------------------------------------------------------------------------------------------
-- Author: Native Instruments
-- Written by: Yaron Eshkar
-- Modified: April 23, 2021
--
-- This file includes useful functions for usage in Creator Tools Lua scripts.
-- 
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local ctZones = require("CtZones")
--
-- Then you can simply call any function like:
-- ctZones.test_function()
--
-- It is also possible of course to copy entire specific functions from this list directly into your script. 
-- In that case remove the ctZones part from the function name, and then simply call it normally like:
-- test_function()
--

local CtZones = {}

--- Test Function.
-- Takes no arguments, prints to console when called.
function CtZones.test_function()
	-- Show that the class import and test function executes by printing a line
	print("Test function called")
end

---- Confine a zone so that root key, low key and high key are all the same.
-- @tparam enum zone the zone to confine.
-- @tparam int the value from 0-127 to confine the zone values to.
-- @treturn bool
function CtZones.zone_confine(zone,value)
	zone.rootKey = value
	zone.keyRange.high = value
	zone.keyRange.low = value
	return true
end	

--- Check and print the total zone count of a group or the entire instrument.
-- @tparam int group the group number to check, if none provided checks entire instrument.
-- @treturn bool
function CtZones.zone_count(group)
	local zone_counter = 0
	if group == nil then
		for _,g in pairs(instrument.groups) do
		   for n,z in pairs(g.zones) do
		       zone_counter = zone_counter + 1
		   end
		end
		print("Total instrument zones: " .. zone_counter)
	else
		for n,z in pairs(instrument.groups[group].zones) do
		       zone_counter = zone_counter + 1
		end
		print("Total zones: " .. zone_counter .. " in group: " .. group)
	end
	return true
end	

--- Print detailed information about a zone, all the zones in a group or all the zones in the instrument.
-- @tparam int group the group number to check, if none provided checks entire instrument.
-- @tparam int zone the zone number to check, if none provided checks all the zones in the group.
-- @treturn bool
function CtZones.zone_info(group,zone)
	if group == nil then
		for _,g in pairs(instrument.groups) do
		    print(g.name)
		    for n,z in pairs(g.zones) do
				print("Zone: "..n.." File: "..z.file.." Vol: "..z.volume.." Pan: "..z.pan.." Tune: "..z.tune.." Root: "..z.rootKey.." Key low: "..z.keyRange.low.." Key high: "..z.keyRange.high.." Vel low: "..z.velocityRange.low.." Vel high: "..z.velocityRange.high.." Start: "..z.sampleStart.." Start mod: "..z.sampleStartModRange.." End: "..z.sampleEnd)
		        for n,l in pairs(z.loops) do
		        	if l.mode ~= 0 then
						print ("Loop "..n.. " mode: "..l.mode.." start: "..l.start.." length: "..l.length.." xfade: "..l.xfade.." count: "..l.count.." tune: "..l.tune)
					end
		    	end
		    end
		end
	else	
		local g = instrument.groups[group]
		if zone == nil then	
			for n,z in pairs(g.zones) do
		        print("Zone: "..n.." File: "..z.file.." Vol: "..z.volume.." Pan: "..z.pan.." Tune: "..z.tune.." Root: "..z.rootKey.." Key low: "..z.keyRange.low.." Key high: "..z.keyRange.high.." Vel low: "..z.velocityRange.low.." Vel high: "..z.velocityRange.high.." Start: "..z.sampleStart.." Start mod: "..z.sampleStartModRange.." End: "..z.sampleEnd)
		        for n,l in pairs(z.loops) do
		        	if l.mode ~= 0 then
						print ("Loop "..n.. " mode: "..l.mode.." start: "..l.start.." length: "..l.length.." xfade: "..l.xfade.." count: "..l.count.." tune: "..l.tune)
					end
		    	end
			end
		else
			local z = g.zones[zone]
			print("Zone: "..zone.." File: "..z.file.." Vol: "..z.volume.." Pan: "..z.pan.." Tune: "..z.tune.." Root: "..z.rootKey.." Key low: "..z.keyRange.low.." Key high: "..z.keyRange.high.." Vel low: "..z.velocityRange.low.." Vel high: "..z.velocityRange.high.." Start: "..z.sampleStart.." Start mod: "..z.sampleStartModRange.." End: "..z.sampleEnd)
		        for n,l in pairs(z.loops) do
		        	if l.mode ~= 0 then
						print ("Loop "..n.. " mode: "..l.mode.." start: "..l.start.." length: "..l.length.." xfade: "..l.xfade.." count: "..l.count.." tune: "..l.tune)
					end
		    	end
		end
	end
	return true
end

--- Move all zones or a specific zone from one group to another.
-- @tparam int from_group the source group index.
-- @tparam int to_group the destination group index.
-- @tparam int zone_number the zone to move, if not specified all zones will be moved from the source group to the destination.
-- @treturn bool
function CtZones.zone_move(from_group,to_group,zone_number)
	-- Error handling: If arguments aren"t provided default to group 0 and 1, and to zone 0
	if from_group == nil then from_group = 0 end
	if to_group == nil then to_group = 1 end
	
	local gFrom = instrument.groups[from_group]
	local gTo = instrument.groups[to_group]
	
	if zone_number == nil then
		for n,z in pairs(gFrom.zones) do
			gTo.zones:add(z)
		end
		gFrom.zones:reset()
	else
		local z = gFrom.zones[zone_number]
		gTo.zones:add(z)
		gFrom.zones:remove(zone_number)
	end
	return true
end

--- Set the loop points of a zone.
-- @tparam int group the group indez of the zone to loop.
-- @tparam int zone the zone index of the zone to loop.
-- @tparam bool find_loop when true uses MIR to find the loop points.
-- @tparan int loop_mode set the loop mode.
-- @tparam int loop_number the loop number (0-7) to set.
-- @tparam int loop_start the start point of the loop.
-- @tparam int loop_length the length of the loop.
-- @treturn bool

function CtZones.zone_loop(group,zone,find_loop,loop_mode,loop_number,loop_start,loop_length)
	local z = instrument.groups[group].zones[zone]

	-- Error handling: If arguments aren"t provided, declare defaults
	if group == nil then group = 0 end
	if zone == nil then zone = 0 end
 
	if loop_mode == nil then loop_mode = 1 end
	
	if loop_mode > 0 then 
		if loop_number == nil then loop_number = 0 end
		if find_loop == nil then
			if loop_start == nil then loop_start = 0 end 
			if loop_length == nil then loop_length = 500000000 end
		end
	end

	if find_loop then
		local loop_end
		loop_start, loop_end = mir.findLoop(z.file)
		loop_length = loop_end - loop_start
	end
	
	z.loops[loop_number].mode = loop_mode
	z.loops[loop_number].start = loop_start
	z.loops[loop_number].length = loop_length

	return true
end	

--- Set all zone parameters.
-- @tparam int group the group index.
-- @tparam int zone the zone index witin the group.
-- @tparam int root_key the root key valuae to set.
-- @tparam int high_key the high key value to set.
-- @tparam int low_key the low key value to set.
-- @tparam int high_vel the high vel value to set.
-- @tparam int low_vel the low vel value to set.
-- @tparam int volume the volume value to set.
-- @tparam int tune the tune value to set.
-- @tparam int pan the pan value to set.
-- @tparam int loop_mode set the loop mode for the xone.
-- @tparam int loop_number the loop number (0-7) to set when loop mode is above 0.
-- @tparam int loop_start where to start the loop.
-- @tparam int loop_length the length of the loop.
-- @treturn bool
function CtZones.zone_params(group,zone,root_key,high_key,low_key,high_vel,low_vel,volume,tune,pan,loop_mode,loop_number,loop_start,loop_length)
	local z = instrument.groups[group].zones[zone]

	-- Error handling: If arguments aren"t provided, declare defaults
	if group == nil then group = 0 end
	if zone == nil then zone = 0 end
	if root_key == nil then root_key = 60 end
	if high_key == nil then high_key = 127 end
	if low_key == nil then low_key = 0 end
	if high_vel == nil then high_vel = 127 end
	if low_vel == nil then low_vel = 0 end
	if volume == nil then volume = 0 end
	if tune == nil then tune = 0 end
	if pan == nil then pan = 0 end

	if loop_mode == nil then loop_mode = 0 end
	
	if loop_mode > 0 then 
		if loop_number == nil then loop_number = 0 end
		if loop_start == nil then loop_start = 0 end 
		if loop_length == nil then loop_length = 500000000 end
	end

    -- set root key and key ranges
    z.rootKey = root_key
    z.keyRange.low = low_key
    z.keyRange.high = high_key

    -- set the velocity range:
    z.velocityRange.low = low_vel
    z.velocityRange.high = high_vel

    -- set tune, volume and pan
    z.volume = volume
    z.tune = tune
	z.pan = pan
	
	if loop_mode > 0 then
		z.loops[loop_number].mode = loop_mode
		z.loops[loop_number].start = loop_start
		z.loops[loop_number].length = loop_length
	end

    return true
end

--- Copy zone parameters from one zone to another.
-- @tparam int source_group the group index of the source group.
-- @tparam int source_zone the zone index of the source zone within the source group.
-- @tparam int dest_group the group index of the destination group.
-- @tparam int dest_zone the zone index of the destination zone within the destination group.
-- @tparam string param if set to "all" copies all zone parameters.
-- @treturn bool
function CtZones.zone_param_single(source_group,source_zone,dest_group,dest_zone,param)
    if param == nil then param = "all" end
    local source_zone = instrument.groups[source_group].zones[source_zone]
    local dest_zone = instrument.groups[dest_group].zones[dest_zone]
    if param == "sample" then dest_zone.file = source_zone.file end
    if param == "sample_start" then dest_zone.sampleStart = source_zone.sampleStart end
    if param == "sample_start_range" then dest_zone.sampleStartModRange = source_zone.sampleStartModRange end
    if param == "sample_end" then dest_zone.sampleEnd = source_zone.sampleEnd end
    if param == "root" then dest_zone.rootKey = source_zone.rootKey end
    if param == "low_key" then dest_zone.keyRange.low = source_zone.keyRange.low end
    if param == "high_key" then dest_zone.keyRange.high = source_zone.keyRange.high end
    if param == "low_vel" then dest_zone.velocityRange.low = source_zone.velocityRange.low end
    if param == "high_vel" then dest_zone.velocityRange.high = source_zone.velocityRange.high end
    if param == "volume" then dest_zone.volume = source_zone.volume end
    if param == "tune" then dest_zone.tune = source_zone.tune end
    if param == "pan" then dest_zone.pan = source_zone.pan end
    if param == "loop_mode" then dest_zone.loops[0].mode = source_zone.loops[0].mode end
    if param == "loop_start" then dest_zone.loops[0].start = source_zone.loops[0].start end
    if param == "loop_length" then dest_zone.loops[0].length = source_zone.loops[0].length end
    if param == "loop_xfade" then dest_zone.loops[0].xfade = source_zone.loops[0].xfade end
    if param == "loop_count" then dest_zone.loops[0].count = source_zone.loops[0].count end
    if param == "loop_tune" then dest_zone.loops[0].tune = source_zone.loops[0].tune end
    if param == "all" then
        dest_zone.file = source_zone.file
        dest_zone.sampleStart = source_zone.sampleStart
        dest_zone.sampleStartModRange = source_zone.sampleStartModRange
        dest_zone.sampleEnd = source_zone.sampleEnd
        dest_zone.rootKey = source_zone.rootKey
        dest_zone.keyRange.low = source_zone.keyRange.low
        dest_zone.keyRange.high = source_zone.keyRange.high
        dest_zone.velocityRange.low = source_zone.velocityRange.low
        dest_zone.velocityRange.high = source_zone.velocityRange.high
        dest_zone.volume = source_zone.volume
        dest_zone.tune = source_zone.tune
        dest_zone.pan = source_zone.pan
        dest_zone.loops[0].mode = source_zone.loops[0].mode
        dest_zone.loops[0].start = source_zone.loops[0].start
        dest_zone.loops[0].length = source_zone.loops[0].length
        dest_zone.loops[0].xfade = source_zone.loops[0].xfade
        dest_zone.loops[0].count = source_zone.loops[0].count
        dest_zone.loops[0].tune = source_zone.loops[0].tune
    end
    return true
end

--- Set the root note of a range of zones over a range of groups with optional arguments.
-- @tparam int start_root the root note number to start from for every zone. Defaults to 60.
-- @tparam int start_zone the index of the zone to start the iteration from. Defaults to 0.
-- @tparam int until_zone the index of the zone to end the iteration on. Defaults to 0.
-- @tparam int start_group the index of the group to start the iteration from. Defaults to 0.
-- @tparam int until_group the index of the group to end the iteration on. Defaults to 0. 
-- @tparam bool increment when true will increment the root note for each zone in the set zone range starting from the start_root value.
-- @tparam bool confine when true, sets the zone low key and high key to the same value as the root note.
-- @treturn bool
function CtZones.zone_root(start_root,start_zone,until_zone,start_group,until_group,increment,confine)
	-- Error handling: If arguments aren"t provided, declare defaults
	if start_root == nil then start_root = 60 end
	if start_zone == nil then start_zone = 0 end
	if until_zone == nil then until_zone = 0 end
	if start_group == nil then start_group = 0 end
	if until_group == nil then until_group = 0 end
	if increment == nil then increment = false end
	if confine == nil then confine = false end

	for i = start_group, until_group do
		local root = start_root
		local g = instrument.groups[i]
		for n,z in pairs(g.zones) do
			if n>start_zone and n<until_zone then
				instrument.groups[i].zones[z].rootKey = root
				if confine then
					z.keyRange.low = root
    				z.keyRange.high = root
    			end
    			if increment then root = root + 1 end
			end
		end
	end
	return true
end

--- Find and count the number of all zones that have the same root key within a group or all groups.
-- @tparam int root_key the root key to compare.
-- @tparam int group the group to check in, if none specified checks in all groups.
-- @treturn table returns a table containing a list of zones that are in the same key as the specified one.
function CtZones.zones_with_same_key(root_key,group)
	local zones_with_same_key_idx = {}
	if group == nil then
		local g = instrument.groups
		for _,g in pairs(g) do
		    for n,z in pairs(g.zones) do
		        if z.rootKey == root_key then
		            table.insert(zones_with_same_key_idx, n)
		        end
		    end
		end
	else
		local g = instrument.groups[group]
			for n,z in pairs(g.zones) do
		        if z.rootKey == root_key then
		            table.insert(zones_with_same_key_idx, n)
		        end
		    end
	end
    
    -- Return table with zones with the same key
    return zones_with_same_key_idx
end

-- return the CtZones object.
return CtZones