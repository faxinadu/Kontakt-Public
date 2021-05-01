--[[ 
Kick Synth Generator
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

local base_folder = root_path .. filesystem.preferred("/Generated/Kicks/") 
local base_file = "kick_"
local file_extention = ".wav"

local kick_count = 10
local sample_rate = 44100
local min_length = 0.3
local max_length = 0.6
local min_start_freq = 150
local max_start_freq = 500
local min_end_freq = 30
local max_end_freq = 60
local min_bend_freq = -8400
local max_bend_freq = -2400
local bend_start = 0

local verbose_mode = true

ctFile.create_directory(base_folder)

for i=1,kick_count do 
	local length = ctUtil.random_float(min_length,max_length)
	local fade_time = length
	local start_freq = math.random(min_start_freq,max_start_freq)
	local end_freq = math.random(min_end_freq,max_end_freq)
	local bend_end = length * math.random(1,2)
	local bend_freq = math.random(min_bend_freq,max_bend_freq)
	local bend_twice_check = math.random(0,1)
	local bend_twice
	if bend_twice_check == 1 then bend_twice = true else bend_twice = false end
	local output_file = base_folder..base_file..i..file_extention
	ctAudio.kick_synth(output_file,sample_rate,length,start_freq,end_freq,bend_start,bend_end,bend_freq,bend_twice,fade_time,verbose_mode)
end

