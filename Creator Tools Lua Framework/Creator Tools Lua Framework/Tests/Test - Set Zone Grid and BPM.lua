--[[ 
Set Zone Grid and BPM
Author: Native Instruments
Written by: Yaron Eshkar
Modified: July 30, 2021
--]]


local start_group = 0
local until_group = #instrument.groups-1
local start_zone = 0

-- set until_zone inside the loop
for i=start_group,until_group do
	local until_zone = #instrument.groups[i].zones
	for x=start_zone,until_zone-1 do
		instrument.groups[i].zones[x].grid.mode = 1
		instrument.groups[i].zones[x].grid.bpm = 120
	end
end	