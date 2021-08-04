--[[ 
Mix Audio Files
Author: Native Instruments
Written by: Yaron Eshkar
Modified: August 4, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctAudio = require("Modules.CtAudio")
local ctUtil = require("Modules.CtUtil")
local ctFile = require("Modules.CtFile")

-----------------------USER VARIABLES--------------------------------

-- Path to the samples top level
local current_path = root_path .. filesystem.preferred("/Samples/")

-- Path to the folders to mix
local samples_path_1 = current_path .. filesystem.preferred("/Side 1/")
local samples_path_2 = current_path .. filesystem.preferred("/Side 2/")

-- Path to the mixed result folder
local mixed_path = current_path .. filesystem.preferred("/Mixed/")

-- Type of audio files
local audio_extention = ".wav"

-- Mixed project name and mixed file name
local mix_project_name = "Mixed Project"
local mix_file_name = "Mixed File"

-- How to separate the file name tokens
local token_separator = "([^-]+)"

-- Perform normalize on the mixed file
local perform_normalize = true
-- Normlize dB level
local normalize_db = "-1.0"

-----------------------SCRIPT----------------------------------------

-- Check if the mixed directory exists, if not then create it
ctFile.create_directory(mixed_path)

-- Tables for each folder
local sample_paths_table_1 = ctUtil.paths_to_table(samples_path_1,audio_extention)
local sample_paths_table_2 = ctUtil.paths_to_table(samples_path_2,audio_extention)
table.sort(sample_paths_table_1)
table.sort(sample_paths_table_2)

-- Get the tokens for each file
local sample_tokens_table_1 = ctUtil.tokens_to_table(sample_paths_table_1,token_separator)
-- Uncomment if the second folder's tokens are needed
-- local sample_tokens_table_2 = ctUtil.tokens_to_table(sample_paths_table_1,token_separator)

-- Loop through the folders and mix
for index, file in pairs(sample_paths_table_1) do
    -- Increment the mixed file name
    local current_mix_file_name = mix_file_name .. " " .. index
    -- Construct a new file name, optionally adding tokens from the original files
    local full_mixed_name = mixed_path .. mix_project_name .. "-" .. current_mix_file_name .. "-" .. sample_tokens_table_1[index][4] .. audio_extention
    -- Create the mixed file
    ctAudio.run_audio_process(file,"mix",sample_paths_table_2[index],full_mixed_name,true)
    if perform_normalize then ctAudio.run_audio_process(full_mixed_name,"normalize",normalize_db,true) end
end

