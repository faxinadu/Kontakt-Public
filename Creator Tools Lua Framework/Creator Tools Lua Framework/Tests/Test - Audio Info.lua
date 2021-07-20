--[[ 
Audio Info
Author: Native Instruments
Written by: Yaron Eshkar
Modified: June 4, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctAudio = require("Modules.CtAudio")
local ctUtil = require("Modules.CtUtil")
require("Modules.paths_file")

-----------------------USER VARIABLES--------------------------------

-- Path to the samples
local current_path = root_path .. filesystem.preferred("/Samples/")

-----------------------SCRIPT----------------------------------------

local sample_paths_table = {}

sample_paths_table = ctUtil.paths_to_table(current_path,".wav")
table.sort(sample_paths_table)

for index, file in pairs(sample_paths_table) do
	ctAudio.audio_info(file,true)
	ctAudio.audio_stats(file,true)

	local execute_string = string.format([[%s "%s" %s %s]],s0,file,s1,s2)
	local params =
		{
			sox_path,
			"'\"'" .. file .. "\"",
			"-n",
			"stats",
		}
	execute_string = table.concat(params, " ")
	print(execute_string)
	local f = assert(io.popen(execute_string, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	print(s)

	local return_val = os.execute(execute_string)
	print(return_val)

	print(sox_path)
	return_val = os.execute(sox_path)
	print(return_val)

end


