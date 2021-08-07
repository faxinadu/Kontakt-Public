--[[ 
Simplest Mapper Example
Author: Native Instruments
Written by: Yaron Eshkar
Modified: August 4, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")
local ctMap = require("Modules.CtMap")

-----------------------USER VARIABLES--------------------------------

-- Path to the samples top level
local current_path = root_path .. filesystem.preferred("/Samples/")

-- File type
local audio_extention = ".wav"

-- Tables for each folder
local sample_paths_table= ctUtil.paths_to_table(current_path,audio_extention)
table.sort(sample_paths_table)

local verbose_mode = true
local root_key = 60
local low_key = 0
local high_key = 127
local low_vel = 0
local high_vel = 127
local set_loop = false
local loop_xfade = 20

-- Call simplest
-- No loop
ctMap.simplest_mapper_groups(sample_paths_table)
--ctMap.simplest_mapper_zones(sample_paths_table)
--Loop
--ctMap.simplest_mapper_groups(sample_paths_table,true)
--ctMap.simplest_mapper_zones(sample_paths_table,true)

-- Call with parameters
--ctMap.simplest_mapper_groups(sample_paths_table,set_loop,loop_xfade,root_key,low_key,high_key,low_vel,high_vel,verbose_mode)
--ctMap.simplest_mapper_zones(sample_paths_table,set_loop,loop_xfade,root_key,low_vel,high_vel,verbose_mode)