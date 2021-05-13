--[[ 
Scale Value Example
Author: Native Instruments
Written by: Yaron Eshkar
Modified: May 13, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")

local old_val = 50
local old_min = 0
local old_max = 100
local new_min = 500
local new_max = 1000

local new_val = ctUtil.scale_value(old_val,old_min,old_max,new_min,new_max)

print(new_val)