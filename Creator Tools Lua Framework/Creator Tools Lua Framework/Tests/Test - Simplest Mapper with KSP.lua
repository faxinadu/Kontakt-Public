--[[ 
Simplest Mapper with KSP Example
Author: Native Instruments
Written by: Yaron Eshkar
Modified: August 6, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")
local ctMap = require("Modules.CtMap")
local ctInstrument = require("Modules.CtInstrument")
local ctFile = require("Modules.CtFile")

-----------------------USER VARIABLES--------------------------------

-- Path to the samples top level
local current_path = root_path .. filesystem.preferred("/Samples/")

-- File type
local audio_extention = ".wav"

-- Tables for each folder
local sample_paths_table= ctUtil.paths_to_table(current_path,audio_extention)
table.sort(sample_paths_table)

-- KSP script path
local ksp_script_path = root_path..filesystem.preferred("/KSP/Shells/source_select_shell.ksp")

-- Mapping variables
local verbose_mode = true
local root_key = 60
local low_key = 0
local high_key = 127
local low_vel = 0
local high_vel = 127
local set_loop = false
local loop_xfade = 20

--ctMap.simplest_mapper_zones(sample_paths_table,root_key,low_vel,high_vel,set_loop,loop_xfade,verbose_mode)
ctMap.simplest_mapper_groups(sample_paths_table,root_key,low_key,high_key,low_vel,high_vel,set_loop,loop_xfade,verbose_mode)

-- Set KSP
local ksp_script_string = ctFile.read_file_to_string(ksp_script_path,"r")
ctInstrument.apply_script(ksp_script_string,"instrument",0,false,false)