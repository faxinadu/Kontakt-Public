--[[ 
Group Deep Copy Example
Author: Native Instruments
Written by: Yaron Eshkar
Modified: May 17, 2021
--]]

local insert_at = 1
local group_to_copy = 0

assert(instrument,"not connected")
instrument.groups:insert(insert_at, instrument.groups[group_to_copy])