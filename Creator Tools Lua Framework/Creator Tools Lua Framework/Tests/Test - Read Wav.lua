--[[ 
Read Wave
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctAudio = require("Modules.CtAudio")

-- Script

test_file = root_path..filesystem.preferred("/samples/sample.wav")
ctAudio.read_audio_file(test_file)
