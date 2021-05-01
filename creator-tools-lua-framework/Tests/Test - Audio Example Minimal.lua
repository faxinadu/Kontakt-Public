--[[ 
Audio Example Minima;
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

-- FLAC Encode
local perform_encode_flac = true

-----------------------SCRIPT----------------------------------------

if verbose_mode then print("--------------------LUA Audio Editor--------------------") end
local sample_paths_table = {}

sample_paths_table = ctUtil.paths_to_table(current_path,".wav")
table.sort(sample_paths_table)

for index, file in pairs(sample_paths_table) do
	ctAudio.encode_flac(file)
    ctAudio.encode_ogg(file)
end

sample_paths_table = ctUtil.paths_to_table(current_path,".aif")
table.sort(sample_paths_table)

for index, file in pairs(sample_paths_table) do
    ctAudio.convert_audio_wav(file)
end