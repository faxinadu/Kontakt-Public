----------------------------------------------------------------------------------------------------
-- Creator Tools LUA Utilities File 
----------------------------------------------------------------------------------------------------

--[[

	This file includes useful functions for usage in Creator Tools Lua scripts.

	Simply include this line in any script (if running a script from another location that users this file,
	make sure to point to the correct path):
	local ctGroups = require("CtGroups")

	Then you can simply call any function like:
	ctGroups.testFunction()
	
	It is also possible of course to copy entire specific functions from this list directly into your script. 
	In that case remove the CtGroups part from the function name, and then simply call it normally like:
	testFunction

--]]


local CtGroups = {}

 -- Test function
function CtGroups.testFunction()

	-- Show that the class import and test function executes by printing a line
	print("Test function called")

end

-- Check and print the total group count of the instrument
function CtGroups.groupCount()

	print('Total groups: '..#instrument.groups)

end

-- Create an x number of groups. Optionally choose where to insert and if and how to rename.
function CtGroups.groupCreate(number,insertAt,groupName,increment,incrementStart)

	-- Error handling: If arguments aren't provided, declare defaults
	if number == nil then number = 0 end
	if groupCreate == nil then groupCreate = 0 end
	if increment == nil then increment = false end
	if incrementStart == nil then incrementStart = 1 end

	for i = 1, number do
		if insertAt == nil then
	    	instrument.groups:add(Group())
	    else
	    	instrument.groups:insert(insertAt, Group())
	    end

	    -- If there is a name parameter, name the group accounting also for the increment parameters
	    if groupName ~= nil then
	    	if increment == false then
				instrument.groups[insertAt].name = groupName
			else
				instrument.groups[insertAt].name = groupName..' '..incrementStart
				incrementStart = incrementStart + 1
			end
			insertAt = insertAt + 1
		end
	end

end

-- Copy a group and paste it x times optionally at the end or by insertion as well as optionally rename the 
-- copied groups.
function CtGroups.groupCopy(groupToCopy,timesToPaste,insertAt,groupName,increment,incrementStart)

	-- Error handling: If arguments aren't provided, declare defaults
	if groupToCopy == nil then groupToCopy = 0 end
	if timesToPaste == nil then timesToPaste = 1 end
	if increment == nil then increment = false end
	if incrementStart == nil then incrementStart = 1 end

	for i = 1, timesToPaste do
		if insertAt == nil then
	    	instrument.groups:add(instrument.groups[groupToCopy])
	    else
	    	instrument.groups:insert(insertAt, instrument.groups[groupToCopy])
	    end
	    if groupName ~= nil then
	    	if increment == false then
				instrument.groups[insertAt].name = groupName
			else
				instrument.groups[insertAt].name = groupName..' '..incrementStart
				incrementStart = incrementStart + 1
			end
			insertAt = insertAt + 1
		end
	end

end

-- Print detailed information about a group or all groups
function CtGroups.groupInfo(group)

	-- If no group is given, report on all the groups
	if group == nil then
		for n,g in pairs(instrument.groups) do
		    print('Number: '..n..' Name: '..g.name..' Vol: '..g.volume..' Tune: '..g.tune..' Pan: '..g.pan)
		end
	else
		local g = instrument.groups[group]
		print('Name: '..g.name..' Vol: '..g.volume..' Tune: '..g.tune..' Pan: '..g.pan)
	end

end

--Rename groups by searching for a string in the group name and replacing it with a new string
function CtGroups.groupNameReplace(replaceThis,replaceWith,startGroup,untilGroup)

	-- Error handling: If arguments aren't provided, declare defaults
	if startGroup == nil then startGroup = 0 end
	if untilGroup == nil then untilGroup = 1 end

	for i = startGroup, untilGroup do
		local oldName = instrument.groups[i].name
		instrument.groups[i].name = oldName:gsub(replaceThis, replaceWith)
	end

end

-- Search for a group name or optionally a string within the name and return a table with all groups that match
function CtGroups.groupNameSearch(searchName,startGroup,untilGroup,contains)

	-- Error handling: If arguments aren't provided, declare defaults
	if untilGroup == nil then untilGroup = startGroup end
	if contains == nil then contains = false end

	local groupsFound = {}

	-- If starting group is not provided, iterate over all groups
	if startGroup == nil then
		for _,g in pairs(instrument.groups) do
			if contains then
				if string.match(g.name, searchName) then 
					table.insert(groupsFound, g.name)
				end
			else
				if g.name == g.name then
			   		table.insert(groupsFound, g.name)
			    end
			end
		end
	else	
		for i = startGroup, untilGroup do
			local g = instrument.groups[i]
			if contains then
				if string.match(g.name, searchName) then 
					table.insert(groupsFound, g.name)
				end
			else
				if g.name == searchName then
			   		table.insert(groupsFound, g.name)
				end
			end
		end	
	end

	-- Return a table containing on all groups with that name
	return groupsFound

end

-- Remove groups
function CtGroups.groupRemove(startGroup,untilGroup)

	-- Error handling: If arguments aren't provided, declare defaults
	if startGroup == nil then startGroup = 0 end
	if untilGroup == nil then untilGroup = 0 end

	-- Loop from the end because we are changing the group index - otherwise wrong groups get removed
	for i = untilGroup, startGroup, -1 do
		instrument.groups:remove(i)
	end

end

-- Rename groups with a group name and an optional incremental count
function CtGroups.groupRename(newName,startGroup,untilGroup,increment,incrementStart)

	-- Error handling: If arguments aren't provided, declare defaults
	if startGroup == nil then startGroup = 0 end
	if untilGroup == nil then untilGroup = 1 end
	if newName == nil then newName = "Group " end
	if increment == nil then increment = true end
	if incrementStart == nil then incrementStart = 1 end

	for i = startGroup, untilGroup do
		if increment then
	    	instrument.groups[i].name = newName..incrementStart
	    	incrementStart = incrementStart + incrementStart
		else	    	
			instrument.groups[i].name = newName
		end
	end

end	

-- Print all the group names
function CtGroups.groupNames()

	print('Group names: ')
	for n=0,#instrument.groups-1 do
		print(instrument.groups[n].name)
	end

end	

-- Set all group parameters
function CtGroups.groupParams(group,volume,tune,pan,name)

	local g = instrument.groups[group]

	-- Error handling: If arguments aren't provided, declare defaults
	if group == nil then group = 0 end
	if volume == nil then volume = 0 end
	if tune == nil then tune = 0 end
	if pan == nil then pan = 0 end

    -- set root key and key ranges
	g.volume = volume
	g.tune = tune
	g.pan = pan
	if g.name ~= nil then
		g.name = name
	end

end

-- return the CtZones object
return CtGroups