----------------------------------------------------------------------------------------------------
-- Creator Tools LUA Utilities File 
----------------------------------------------------------------------------------------------------

--[[

	This file includes useful functions for usage in Creator Tools Lua scripts.

	Simply include this line in any script (if running a script from another location that users this file,
	make sure to point to the correct path):
	local ctZones = require("CtZones")

	Then you can simply call any function like:
	ctZones.testFunction()
	
	It is also possible of course to copy entire specific functions from this list directly into your script. 
	In that case remove the ctZones part from the function name, and then simply call it normally like:
	testFunction

--]]


local CtZones = {}

 -- Test function
function CtZones.testFunction()

	-- Show that the class import and test function executes by printing a line
	print("Test function called")

end

-- Confine a zone so that root key, low key and high key are all the same
function CtZones.zoneConfine(zone,value)
		zone.rootKey = value
		zone.keyRange.high = value
		zone.keyRange.low = value
end	

-- Check and print the total zone count of a group or the entire instrument
function CtZones.zoneCount(group)
	local zonecounter = 0
	if group == nil then
		for _,g in pairs(instrument.groups) do
		   for n,z in pairs(g.zones) do
		       zonecounter = zonecounter + 1
		   end
		end
		print("Total instrument zones: " .. zonecounter)
	else
		for n,z in pairs(instrument.groups[group].zones) do
		       zonecounter = zonecounter + 1
		end
		print('Total zones: ' .. zonecounter .. ' in group: ' .. group)
	end
end	

-- Print detailed information about a zone, all the zones in a group or all the zones in the instrument
function CtZones.zoneInfo(group,zone)
	if group == nil then
		for _,g in pairs(instrument.groups) do
		    print(g.name)
		    for n,z in pairs(g.zones) do
				print('Zone: '..n..' File: '..z.file..' Vol: '..z.volume..' Pan: '..z.pan..' Tune: '..z.tune..' Root: '..z.rootKey..' Key low: '..z.keyRange.low..' Key high: '..z.keyRange.high..' Vel low: '..z.velocityRange.low..' Vel high: '..z.velocityRange.high..' Start: '..z.sampleStart..' Start mod: '..z.sampleStartModRange..' End: '..z.sampleEnd)
		        for n,l in pairs(z.loops) do
		        	if l.mode ~= 0 then
						print ('Loop '..n.. ' mode: '..l.mode..' start: '..l.start..' length: '..l.length..' xfade: '..l.xfade..' count: '..l.count..' tune: '..l.tune)
					end
		    	end
		    end
		end
	else	
		local g = instrument.groups[group]
		if zone == nil then	
			for n,z in pairs(g.zones) do
		        print('Zone: '..n..' File: '..z.file..' Vol: '..z.volume..' Pan: '..z.pan..' Tune: '..z.tune..' Root: '..z.rootKey..' Key low: '..z.keyRange.low..' Key high: '..z.keyRange.high..' Vel low: '..z.velocityRange.low..' Vel high: '..z.velocityRange.high..' Start: '..z.sampleStart..' Start mod: '..z.sampleStartModRange..' End: '..z.sampleEnd)
		        for n,l in pairs(z.loops) do
		        	if l.mode ~= 0 then
						print ('Loop '..n.. ' mode: '..l.mode..' start: '..l.start..' length: '..l.length..' xfade: '..l.xfade..' count: '..l.count..' tune: '..l.tune)
					end
		    	end
			end
		else
			local z = g.zones[zone]
			print('Zone: '..zone..' File: '..z.file..' Vol: '..z.volume..' Pan: '..z.pan..' Tune: '..z.tune..' Root: '..z.rootKey..' Key low: '..z.keyRange.low..' Key high: '..z.keyRange.high..' Vel low: '..z.velocityRange.low..' Vel high: '..z.velocityRange.high..' Start: '..z.sampleStart..' Start mod: '..z.sampleStartModRange..' End: '..z.sampleEnd)
		        for n,l in pairs(z.loops) do
		        	if l.mode ~= 0 then
						print ('Loop '..n.. ' mode: '..l.mode..' start: '..l.start..' length: '..l.length..' xfade: '..l.xfade..' count: '..l.count..' tune: '..l.tune)
					end
		    	end
		end
	end
end

-- Move all zones or a specific zone from one group to another
function CtZones.zoneMove(fromGroup,toGroup,zoneNumber)

	-- Error handling: If arguments aren't provided default to group 0 and 1, and to zone 0
	if fromGroup == nil then fromGroup = 0 end
	if toGroup == nil then toGroup = 1 end
	
	local gFrom = instrument.groups[fromGroup]
	local gTo = instrument.groups[toGroup]
	
	if zoneNumber == nil then
		for n,z in pairs(gFrom.zones) do
			gTo.zones:add(z)
		end
		gFrom.zones:reset()
	else
		local z = gFrom.zones[zoneNumber]
		gTo.zones:add(z)
		gFrom.zones:remove(zoneNumber)
	end

end

-- Set all zone parameters
function CtZones.zoneParams(group,zone,rootKey,highKey,lowKey,highVel,lowVel,volume,tune,pan)
	local z = instrument.groups[group].zones[zone]

	-- Error handling: If arguments aren't provided, declare defaults
	if group == nil then group = 0 end
	if zone == nil then zone = 0 end
	if rootKey == nil then rootKey = 60 end
	if highKey == nil then highKey = 127 end
	if lowKey == nil then lowKey = 0 end
	if highVel == nil then highVel = 127 end
	if lowVel == nil then lowVel = 0 end
	if volume == nil then volume = 0 end
	if tune == nil then tune = 0 end
	if pan == nil then pan = 0 end

    -- set root key and key ranges
    z.rootKey = rootKey
    z.keyRange.low = lowKey
    z.keyRange.high = highKey

    -- set the velocity range:
    z.velocityRange.low = lowVel
    z.velocityRange.high = highVel

    -- set tune, volume and pan
    z.volume = volume
    z.tune = tune
    z.pan = pan
end

-- Set the root note of zones with optional arguments
function CtZones.zoneRoot(startRoot,startZone,untilZone,startGroup,untilGroup,increment,confine)

	-- Error handling: If arguments aren't provided, declare defaults
	if startRoot == nil then startRoot = 60 end
	if startZone == nil then startZone = 0 end
	if untilZone == nil then untilZone = 0 end
	if startGroup == nil then startGroup = 0 end
	if untilGroup == nil then untilGroup = 0 end
	if increment == nil then increment = false end
	if confine == nil then confine = false end

	for i = startGroup, untilGroup do
		local root = startRoot
		local g = instrument.groups[i]
		for n,z in pairs(g.zones) do
			if n>startZone and n<untilZone then
				instrument.groups[i].zones[z].rootKey = root
				if confine then
					z.keyRange.low = root
    				z.keyRange.high = root
    			end
    			if increment then root = root + 1 end
			end
		end
	end

end

--Find and count the number of all zones that have the same rootKey within a group or all groups
function CtZones.zonesWithSameKey(rootKey,group)

	local zonesWithSameKeyIdx = {}
	if group == nil then
		local g = instrument.groups
		for _,g in pairs(g) do
		    for n,z in pairs(g.zones) do
		        if z.rootKey == rootKey then
		            table.insert(zonesWithSameKeyIdx, n)
		        end
		    end
		end
	else
		local g = instrument.groups[group]
			for n,z in pairs(g.zones) do
		        if z.rootKey == rootKey then
		            table.insert(zonesWithSameKeyIdx, n)
		        end
		    end
	end
    
    -- Return table with zones with the same key
    return zonesWithSameKeyIdx

end

-- return the CtZones object
return CtZones