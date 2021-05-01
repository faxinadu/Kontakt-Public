--[[ 
Set Zone Params
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctZones = require("Modules.CtZones")

-- Script

local group = 0
local zone = 0
local root_key = 60
local high_key = 127
local low_key = 0
local high_vel = 127
local low_vel = 0
local volume = 0
local tune = 0
local pan = 0
local loop_number = 0
local loop_mode = 1

ctZones.zone_params(group,zone,root_key,high_key,low_key,high_vel,low_vel,volume,tune,pan,loop_mode,loop_number,loop_start,loop_length)
