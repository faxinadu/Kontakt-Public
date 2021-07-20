--[[ 
Normalize Audio
Author: Native Instruments
Written by: Yaron Eshkar
Modified: June 4, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctAudio = require("Modules.CtAudio")
local ctUtil = require("Modules.CtUtil")

-----------------------USER VARIABLES--------------------------------

-- Path to the samples
local current_path = root_path .. filesystem.preferred("/Samples/")

-- normalize value
local normalize_db = "-1.0"

-----------------------SCRIPT----------------------------------------

local sample_paths_table = {}

sample_paths_table = ctUtil.paths_to_table(current_path,".wav")
table.sort(sample_paths_table)

for index, file in pairs(sample_paths_table) do
	ctAudio.run_audio_process(file,"normalize",normalize_db,true)
end
