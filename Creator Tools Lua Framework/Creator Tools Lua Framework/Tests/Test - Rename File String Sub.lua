--[[ 
Rename File String Sub
Author: Native Instruments
Written by: Yaron Eshkar
Modified: July 19, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")

-- Script

-- New file name
local expr_1 = "Uni Cycle Longs Vol 1%-31%-Uni Cycle Sync Creative Open 05"
local expr_2 = "Sound 7"

-- Path to the samples
local current_path = root_path .. filesystem.preferred("/Samples/")

sample_paths_table = ctUtil.paths_to_table(current_path,".wav")
table.sort(sample_paths_table)

for index, file in pairs(sample_paths_table) do
    local new_name = string.gsub(file,expr_1,expr_2)
    os.rename(file,new_name)
end