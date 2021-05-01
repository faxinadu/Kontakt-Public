--[[ 
Sine Partials Generator
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

local base_folder = root_path .. filesystem.preferred("/Generated/Sines/") 
local base_file = "sine_"
local file_extention = ".wav"

local sample_rate = 44100
local length = 12
local notes = 128
local partials = 1
local base_freq = 15.432
local shape = "sine"

local verbose_mode = true

semitone = ctAudio.semitone_interval()
ctFile.create_directory(base_folder)

for i=0,notes do 
	base_freq = base_freq*semitone
	for x=1, partials do
		local partial_freq = base_freq*x
		local output_file = base_folder..base_file..i.."_"..x..file_extention
		ctAudio.wave_synth(output_file,sample_rate,length,shape,partial_freq,verbose_mode)
	end
end

 