--[[ 
Wavetable Sewing Machine
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
local current_path = root_path .. filesystem.preferred("/Samples/")

-- Global
local verbose_mode = true

-- Result file
local result_file = current_path.."result.wav"

-----------------------SCRIPT----------------------------------------

if verbose_mode then print("--------------------LUA Wavetable Editor--------------------") end

ctAudio.concatenate_audio_folder(current_path,result_file,verbose_mode)

