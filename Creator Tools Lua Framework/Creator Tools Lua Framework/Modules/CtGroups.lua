----------------------------------------------------------------------------------------------------
-- Creator Tools LUA Group Utilities File 
----------------------------------------------------------------------------------------------------
-- Author: Native Instruments
-- Written by: Yaron Eshkar
-- Modified: April 23, 2021
--
-- This file includes useful functions for usage in Creator Tools Lua scripts.
--
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local ctGroups = require("CtGroups")
--
-- Then you can simply call any function like:
-- ctGroups.test_function()
-- 
-- It is also possible of course to copy entire specific functions from this list directly into your script. 
-- In that case remove the CtGroups part from the function name, and then simply call it normally like:
-- test_function()
--

local CtGroups = {}

--- Test Function.
-- Takes no arguments, prints to console when called.
function CtGroups.test_function()
	-- Show that the class import and test function executes by printing a line
	print("Test function called")
end

--- Check group count.
-- Takes no arguments, check and print the total group count of the instrument.
function CtGroups.group_count()
	print("Total groups: "..#instrument.groups)
end

--- Create an x number of groups.
-- Optionally choose where to insert and if and how to rename.
-- @tparam int number the number of groups to create.
-- @tparam int insert_at the group index after which to start creating new groups.
-- @tparam string group_name the name for the created groups.
-- @tparam bool increment when set to true, add an incremental numeric count to the group name.
-- @tparam int increment_start the number from which to start incrementing from.
-- @treturn bool
function CtGroups.group_create(number,insert_at,group_name,increment,increment_start)
	-- Error handling: If arguments aren't provided, declare defaults
	if number == nil then number = 0 end
	if group_create == nil then group_create = 0 end
	if increment == nil then increment = false end
	if increment_start == nil then increment_start = 1 end

	for i = 1, number do
		if insert_at == nil then
	    	instrument.groups:add(Group())
	    else
	    	instrument.groups:insert(insert_at, Group())
	    end

	    -- If there is a name parameter, name the group accounting also for the increment parameters
	    if group_name ~= nil then
	    	if increment == false then
				instrument.groups[insert_at].name = group_name
			else
				instrument.groups[insert_at].name = group_name..' '..increment_start
				increment_start = increment_start + 1
			end
			insert_at = insert_at + 1
		end
	end
	return true
end

--- Copy a group and paste it x times.
-- Optionally at the end or by insertion as well as optionally rename the copied groups.
-- @tparam int group_to_copy the group to copy.
-- @tparam int times_to_paste how many copies should be created.
-- @tparam int insert_at the group index after which to start creating new groups.
-- @tparam string group_name the name for the created groups.
-- @tparam bool increment when set to true, add an incremental numeric count to the group name.
-- @tparam int increment_start the number from which to start incrementing from.
-- @treturn bool
function CtGroups.group_copy(group_to_copy,times_to_paste,insert_at,group_name,increment,increment_start)
	-- Error handling: If arguments are nott provided, declare defaults
	if group_to_copy == nil then group_to_copy = 0 end
	if times_to_paste == nil then times_to_paste = 1 end
	if increment == nil then increment = false end
	if increment_start == nil then increment_start = 1 end

	for i = 1, times_to_paste do
		if insert_at == nil then
	    	instrument.groups:add(instrument.groups[group_to_copy])
	    else
	    	instrument.groups:insert(insert_at, instrument.groups[group_to_copy])
	    end
	    if group_name ~= nil then
	    	if increment == false then
				instrument.groups[insert_at].name = group_name
			else
				instrument.groups[insert_at].name = group_name..' '..increment_start
				increment_start = increment_start + 1
			end
			insert_at = insert_at + 1
		end
	end
	return true
end

--- Print detailed information about a group or all groups.
-- @tparam int group the group to check. If no group is given, report on all the groups.
-- @treturn bool
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
	return true
end

--- Replace group name.
-- Searches for a string in the group name and replaces it with a new string.
-- @tparam string replace_this the sub-string in the group name to look for.
-- @tparam string replace_with the sub-string to replace matches with.
-- @tparam int start_group the index of the first group to start checking in. Defaults to 0.
-- @tparam int until_group the index of the last group to start checking in. Defaults to start_group.
-- @treturn bool
function CtGroups.group_name_replace(replace_this,replace_with,start_group,until_group)
	-- Error handling: If arguments aren't provided, declare defaults
	if start_group == nil then start_group = 0 end
	if until_group == nil then until_group = start_group end

	for i = start_group, until_group do
		local old_name = instrument.groups[i].name
		instrument.groups[i].name = old_name:gsub(replace_this, replace_with)
	end
	return true
end

--- Search for a group name or a string in the name.
-- Return a table with all groups that match.
-- @tparam string search_name the group name or sub-string in the name to look for.
-- @tparam int start_group the index of the first group to start checking in. Defaults to 0.
-- @tparam int until_group the index of the last group to start checking in. Defaults to start_group.
-- @tparam bool contains when true searches for a sub-string within the group name, otherwise searches for matches in the entire group name.
-- @treturn table returns a table with the indexes of the groups matching the condition.
function CtGroups.group_name_search(search_name,start_group,until_group,contains)
	-- Error handling: If arguments aren't provided, declare defaults
	if until_group == nil then until_group = start_group end
	if contains == nil then contains = false end

	local groups_found = {}

	-- If starting group is not provided, iterate over all groups
	if start_group == nil then
		for _,g in pairs(instrument.groups) do
			if contains then
				if string.match(g.name, search_name) then 
					table.insert(groups_found, g.name)
				end
			else
				if g.name == search_name then
			   		table.insert(groups_found, g.name)
			    end
			end
		end
	else	
		for i = start_group, until_group do
			local g = instrument.groups[i]
			if contains then
				if string.match(g.name, search_name) then 
					table.insert(groups_found, g.name)
				end
			else
				if g.name == search_name then
			   		table.insert(groups_found, g.name)
				end
			end
		end	
	end

	-- Return a table containing on all groups with that name
	return groups_found
end

--- Remove groups within a range of groups.
-- @tparam int start_group the index of the first group to remove. Defaults to 0.
-- @tparam int until_group the index of the last group to remove. Defaults to start_group.
-- @treturn bool
function CtGroups.group_remove(start_group,until_group)
	-- Error handling: If arguments aren't provided, declare defaults
	if start_group == nil then start_group = 0 end
	if until_group == nil then until_group = start_group end

	-- Loop from the end because we are changing the group index - otherwise wrong groups get removed
	for i = until_group, start_group, -1 do
		instrument.groups:remove(i)
	end
	return true
end

--- Rename groups.
-- Change name and an add optional incremental count
-- @tparam string new_name the new name for the groups.
-- @tparam int start_group the index of the group to start renaming. Defaults to 0.
-- @tparam int until_group the index of the last group to be renamed. Defaults to start_group.
-- @tparam bool increment when true will add an incremental count to every group name.
-- @tparam int increment_start the number from which to start the incremental count from. Defaults to 1.
-- @treturn bool
function CtGroups.group_rename(new_name,start_group,until_group,increment,increment_start)
	-- Error handling: If arguments aren't provided, declare defaults
	if start_group == nil then start_group = 0 end
	if until_group == nil then until_group = start_group end
	if new_name == nil then new_name = "Group " end
	if increment == nil then increment = true end
	if increment_start == nil then increment_start = 1 end

	for i = start_group, until_group do
		if increment then
	    	instrument.groups[i].name = new_name..increment_start
	    	increment_start = increment_start + increment_start
		else	    	
			instrument.groups[i].name = new_name
		end
	end
	return true
end	

--- Print group names.
-- Takes no arguments, prints all group names.
-- @treturn bool
function CtGroups.group_names()
	print('Group names: ')
	for n=0,#instrument.groups-1 do
		print(instrument.groups[n].name)
	end
	return true
end	

--- Set all group parameters.
-- @tparam int group the index of the group to set. Defaults to 0.
-- @tparam int volume the group volume. Defaults to 0.
-- @tparam int tune the group tune. Defaults to 0.
-- @tparam int pan the group pan. Defaults to 0.
-- @tparam string name the name of the group, if specified.
-- @treturn bool
function CtGroups.group_params(group,volume,tune,pan,name)
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
	return true
end

-- return the CtGroups object.
return CtGroups