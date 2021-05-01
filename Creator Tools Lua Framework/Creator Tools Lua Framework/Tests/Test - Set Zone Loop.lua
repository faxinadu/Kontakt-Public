--[[ 
Set Zone Loop
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 04, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctZones = require("Modules.CtZones")

-- Script

local group = 0
local zone = 0
find_loop = true

ctZones.zone_loop(group,zone,find_loop,loop_mode,loop_number,loop_start,loop_length)
