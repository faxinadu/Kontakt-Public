--[[ 
Fix Zone Tuning
Author: Native Instruments
Written by: Yaron Eshkar
Modified: August 11, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctZones = require("Modules.CtZones")

local start_group = 0
local end_group = 0
local verbose_mode = true

for i=start_group,end_group do
    ctZones.fix_zone_tune(i,verbose_mode)
end