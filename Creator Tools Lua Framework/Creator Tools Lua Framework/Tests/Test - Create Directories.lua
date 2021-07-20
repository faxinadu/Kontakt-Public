--[[ 
Create Directories
Author: Native Instruments
Written by: Yaron Eshkar
Modified: June 4, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")
local ctFile = require("Modules.CtFile")
-- Script

-- Base directory name
local base_name = "my_directory"

-- Number to create
local directory_count = 10

-- Base path
local current_path = root_path .. filesystem.preferred("/Samples/")

for i=1,directory_count do 
    ctFile.create_directory(current_path .. base_name .. "_" .. i,true)
end