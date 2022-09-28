--[[ 
Group Rename Example
Author: Native Instruments
Written by: Yaron Eshkar
Modified: May 9, 2022
--]]

local replace_this = "Group 1"
local replace_with = "GROUP"
local start_group = 0
local until_group = #instrument.groups-1
local verbose_mode = true

function group_name_replace(replace_this,replace_with,start_group,until_group,verbose_mode)
	if start_group == nil then start_group = 0 end
	if until_group == nil then until_group = #instrument.groups-1 end
    if verbose_mode == nil then verbose_mode = true end
	for i = start_group, until_group do
		local old_name = instrument.groups[i].name
        if string.find(old_name,replace_this) then
		    instrument.groups[i].name = old_name:gsub(replace_this, replace_with)
            if verbose_mode then 
                print("Replaced found string " .. replace_this .. " with " .. replace_with .. " in group " .. i .. " name " )
                print("New group name is " ..  instrument.groups[i].name)
            end
        end
	end
end

group_name_replace(replace_this,replace_with,start_group,until_group,verbose_mode)