--[[ 
Audio Example
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctAudio = require("Modules.CtAudio")
local ctUtil = require("Modules.CtUtil")

-----------------------USER VARIABLES--------------------------------

-- Path to the samples
local current_path = root_path .. filesystem.preferred("/Samples/")

-- Global
local verbose_mode = true

-- normalize
local perform_normalize = true
local normalize_db = "-5"

-- Silence
local perform_silence = true

-- Samplerate convert
local perform_samplerate = true
local out_sample_rate = "44100"

local perform_bit_depth = true
local out_bit_depth = "16"

-- Filtering
local perform_filter = true
local filter_type = "highpass"
local filter_cut = "10"

-- FLAC Decode
local perform_decode_flac = true

-- FLAC Encode
local perform_encode_flac = true

-----------------------SCRIPT----------------------------------------

if verbose_mode then print("--------------------LUA Audio Editor--------------------") end
local sample_paths_table = {}

if perform_decode_flac then
	sample_paths_table = ctUtil.paths_to_table(current_path,".flac")
	table.sort(sample_paths_table)
	for index, file in pairs(sample_paths_table) do
		ctAudio.decode_flac(file)
	end
end

sample_paths_table = ctUtil.paths_to_table(current_path,".wav")
table.sort(sample_paths_table)

for index, file in pairs(sample_paths_table) do
	ctAudio.run_audio_process(file,"filter",filter_type,filter_cut,verbose_mode)
	ctAudio.run_audio_process(file,"normalize",normalize_db,verbose_mode)
	ctAudio.run_audio_process(file,"silence",verbose_mode)
	ctAudio.run_audio_process(file,"reverse",verbose_mode)
	ctAudio.run_audio_process(file,"silence",verbose_mode)
	ctAudio.run_audio_process(file,"convert_sr",out_sample_rate,verbose_mode)
	ctAudio.run_audio_process(file,"convert_bd",out_bit_depth,verbose_mode)
	ctAudio.encode_flac(file)
	ctAudio.encode_ogg(file,5)
end
