--[[ 
Set KSP Script
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctInstrument = require("Modules.CtInstrument")
local ctFile = require("Modules.CtFile")

-- Script

local ksp_script_path = root_path..filesystem.preferred("/KSP/Simnple Performant NKS Shell.ksp")
local ksp_script_string = ctFile.read_file_to_string(ksp_script_path,"r")

ctInstrument.apply_script(ksp_script_string,"instrument",0,false,false)