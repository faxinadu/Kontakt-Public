--[[ 
Pluck Generator
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctAudio = require("Modules.CtAudio")
local ctUtil = require("Modules.CtUtil")
local ctFile = require("Modules.CtFile")

-- Script

local base_folder = root_path .. filesystem.preferred("/Generated/Plucks/") 
local base_file = "pluck_"
local file_extention = ".wav"

local sample_rate = 44100
local length = 4
local notes = 60
local from_center = -45
local note_number = 12
local shape = "pluck"

local verbose_mode = true

ctFile.create_directory(base_folder)

for i=0,notes do 
	local output_file = base_folder..base_file..note_number..file_extention
	ctAudio.wave_synth(output_file,sample_rate,length,shape,"%"..from_center,verbose_mode)
	from_center = from_center + 1
	note_number = note_number + 1
end
