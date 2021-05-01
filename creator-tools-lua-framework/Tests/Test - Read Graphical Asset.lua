--[[ 
Read Graphical Asset
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")

-- Script

local test_file = root_path..filesystem.preferred("/Love/assets/k_logo.png")
local width, height = ctUtil.get_image_width_height(test_file)
print("width: "..width)
print("height: "..height)
