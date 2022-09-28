--[[ 
Rename Zone File String Sub
Author: Native Instruments
Written by: Yaron Eshkar
Modified: June 13, 2022
--]]

-- Script

-- New file name
local expr_1 = "_0"
local expr_2 = ""

local verbose_mode = true

for _,g in pairs(instrument.groups) do
    for n,z in pairs(g.zones) do
        if verbose_mode then print("Old name is: " .. z.file) end
        local new_name = string.gsub(z.file,expr_1,expr_2)   
        if verbose_mode then print("New name is: " .. new_name) end
        z.file = new_name
    end
end