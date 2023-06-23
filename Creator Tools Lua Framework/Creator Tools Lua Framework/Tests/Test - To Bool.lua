--[[ 
Lua API - To Bool Test
Author: Native Instruments
Written by: Yaron Eshkar
Modified: December 29, 2022
--]]

local function tobool(v)
    return v and ( (type(v)=="number") and (v==1) or ( (type(v)=="string") and (v=="true") ) )
end

local test_string = "true"

if tobool(test_string) then print ("it is true") end
