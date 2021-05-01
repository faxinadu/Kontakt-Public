--[[ 
Test File System Access
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 30, 2021
--]]

-- Script

local some_text = "best text ever"

local some_file = scriptPath .. filesystem.preferred("/some_file.txt")

file = io.open(some_file,"w")
file:write(some_text)
io.close(file)