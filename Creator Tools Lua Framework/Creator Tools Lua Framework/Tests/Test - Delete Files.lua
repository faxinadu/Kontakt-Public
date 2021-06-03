--[[ 
Delete Files
Author: Native Instruments
Written by: Yaron Eshkar
Modified: May 7, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")

-- Script

-- Extention to delete
local file_extention = ".sfk"

-- Path to the files
local current_path = root_path .. filesystem.preferred("/Samples/")

file_paths_table = ctUtil.paths_to_table(current_path,file_extention)
table.sort(file_paths_table)

for index, file in pairs(file_paths_table) do
    print(file)
    os.remove(file)
end