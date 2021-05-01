--[[ 
Sample Set Integrity Check
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctAudio = require("Modules.CtAudio")

-----------------------USER VARIABLES--------------------------------

-- Path to the samples
local path = root_path .. filesystem.preferred("/Samples/")

local verbose_mode = true

local perform_rms_check = true
local deviance_rms_factor = 2

local perform_loudness_check = true
local deviance_loudness_factor = 2

local perform_peak_check = true
local deviance_peak_factor = 0.5

local perform_rate_check = true
local expected_sample_rate = 96000

local perform_depth_check = true
local expected_bit_depth = 16

local perform_loop_check = true
local expected_loop = true

local perform_file_size_check = true
local deviance_file_size_factor = 600000

-----------------------SCRIPT----------------------------------------

if verbose_mode then print("--------------------LUA Sample Set Integrity Check--------------------") end

local check = ctAudio.check_sample_set_integrity(path,verbose_mode,perform_rms_check,deviance_rms_factor,perform_loudness_check,deviance_loudness_factor,perform_peak_check,deviance_peak_factor,perform_rate_check,expected_sample_rate,perform_loop_check,expected_loop,perform_file_size_check,deviance_file_size_factor)
if check then print("Integrity check passed") else print("Integrity check failed") end