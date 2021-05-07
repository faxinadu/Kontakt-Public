--[[ 
Rename File
Author: Native Instruments
Written by: Yaron Eshkar
Modified: May 7, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")

-- Script

-- New file name
local new_name = "cat"

-- Path to the samples
local current_path = root_path .. filesystem.preferred("/Samples/")

sample_paths_table = ctUtil.paths_to_table(current_path,".wav")
table.sort(sample_paths_table)

for index, file in pairs(sample_paths_table) do
    print(filesystem.parentPath(file))
    os.rename(file, filesystem.parentPath(file).. "/" .. new_name .. index .. ".wav")
end