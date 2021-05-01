--[[ 
Check Duplicate file Names
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctFile = require("Modules.CtFile")
local ctUtil = require("Modules.CtUtil")

-- Script

local path = root_path..filesystem.preferred("/samples/")
local file_extention = ".wav"
local verbose_mode = true

ctFile.check_duplicate_file_names(path,file_extention,verbose_mode)