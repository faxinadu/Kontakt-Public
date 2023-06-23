----------------------------------------------------------------------------------------------------
-- Kontakt LUA SoX Utilities File 
----------------------------------------------------------------------------------------------------
-- This file includes useful functions for usage in Kontakt Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local kSox = require("KSox")

local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = root_path .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUtil = require("Modules.KUtil")
local kUser = require("Modules.KUser")

local sox_path = kUser.sox_path

local KSox = {}

--- Sets Verbose Mode for SoX operations.
-- @tparam bool verbose_mode set to true or false.
-- @treturn string returns either "-V3" when verbose_mode is true or "-V0" when false or nil.
function KSox.set_verbose_string(verbose_mode)
	local verbose_string
	if verbose_mode then 
		verbose_string = "-V3"
	else
		verbose_string = "-V0"
	end
	return verbose_string
end

--- Print info of an audio file to console.
-- @tparam string file the source file to analyze. 
-- @tparam bool verbose_mode when true prints information to console.
function KSox.audio_info(file,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Audio Info----------") end
	local verbose_string = KSox.set_verbose_string(verbose_mode)
	local s0 = sox_path
	local s1 = "--info"
	local execute_string = string.format([[%s %s "%s"]],s0,s1,file)
	local result = kFile.capture_shell_command(execute_string,true)
	if verbose_mode then print(result) end
end

--- Print stats of an audio file to console.
-- @tparam string file the source file to analyze. 
-- @tparam bool verbose_mode when true prints information to console.
function KSox.audio_stats(file,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Audio Stats----------") end
	local s0 = sox_path
	local s1 = "-n"
	local s2 = "stats"
	local execute_string = string.format([[%s "%s" %s %s]],s0,file,s1,s2)
	local result = kFile.capture_shell_command(execute_string,true)
	if verbose_mode then print(result) end
end

--- Encode a WAV file to OGG.
-- @tparam string input_file the path to t he WAV file to encode.
-- @tparam string compression_factor the OGG compression factor, defaults to  5.
-- @tparam string output_file the desired path of the output file. Defaults to input_file.ogg.
-- @tparam bool delete_original when true the original file is deleted after the operation.
-- @tparam bool verbose_mode when true prints information to console.
function KSox.encode_ogg(input_file,compression_factor,output_file,delete_original,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Encoding OGG---------") end
	if compression_factor == nil then compression_factor = 5 end
	if output_file == nil or output_file == "same" then output_file = Filesystem.parent_path(input_file) .. "/" .. Filesystem.stem(input_file)..".ogg" end
	output_file = Filesystem.preferred(output_file)
	local verbose_string = KSox.set_verbose_string(verbose_mode)
	local s0 = sox_path
	local s1 = "-C"
	local s2 = compression_factor
	local execute_string = string.format([[%s %s "%s" %s %s "%s"]],s0,verbose_string,input_file,s1,s2,output_file)
	kFile.run_file_process(execute_string,file,temp_file)
	if verbose_mode then print("Encoded "..input_file.." to OGG ") end
	if delete_original then kFile.delete_file(input_file) end
end

--- Reverse an audio file.
-- @tparam string file the source file to reverse. 
-- @tparam bool verbose_mode when true prints information to console.
function KSox.reverse_audio(file,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Apply Reverse----------") end
	local verbose_string = KSox.set_verbose_string(verbose_mode)
	local temp_file = Kontakt.script_path .. Filesystem.preferred("/temp.wav")
	local s0 = sox_path
	local execute_string = string.format([[%s %s "%s" "%s" %s]],s0,verbose_string,file,temp_file,"reverse")
	kFile.run_file_process(execute_string,file,temp_file)
	if verbose_mode then print("Performed reverse on "..file) end
end

--- Mix two audio files.
-- @tparam string file_1 the first file to mix.
-- @tparam string file_2 the second file to mix.
-- @tparam string file_2 the desired path to the result file.
-- @tparam bool verbose_mode when true prints information to console.
function KSox.mix_audio(file_1,file_2,output_file,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Mix Audio----------") end
	local verbose_string = KSox.set_verbose_string(verbose_mode)
	if output_file == nil then output_file = Kontakt.script_path..Filesystem.preferred("/temp.wav") end
	local s0 = sox_path
	local s1 = "-m"
	local execute_string = string.format([[%s %s %s "%s" "%s" "%s"]],s0,verbose_string,s1,file_1,file_2,output_file)
	if verbose_mode then print ("Audio files mixed to: " .. output_file) end
	kFile.run_shell_command(execute_string,false)
end

--- Append an audio file to the end of another.
-- @tparam string file1 the path to the first source audio file. 
-- @tparam string file2 the path to the second source audio file to append to the first. 
-- @tparam string file3 the desired path and name for the resulting audio file. 
-- @tparam bool verbose_mode when true prints information to console.
function KSox.concatenate_audio(file1,file2,file3,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Concatenate Audio----------") end
	local verbose_string = KSox.set_verbose_string(verbose_mode)
	local temp_file = Kontakt.script_path..Filesystem.preferred("/temp.wav")
	local s0 = sox_path
	local execute_string = string.format([[%s %s "%s" "%s" "%s"]],s0,verbose_string,file1,file2,temp_file)
	kFile.run_shell_command(execute_string,false)
	kFile.copy_file(temp_file,file3)
	kFile.delete_file(temp_file)
	if verbose_mode then print(file2.." appended to "..file1) end
end

--- Append all audio found in a folder in an alphanumeric order.
-- @tparam string path the path to the directory containing audio files.
-- @tparam string result_file the desired path and name for the resulting audio file. 
-- @tparam bool verbose_mode when true prints information to console.
function KSox.concatenate_audio_folder(path,result_file,verbose_mode)
	local sample_paths_table = {}
	sample_paths_table = kUtil.paths_to_table(path,".wav")
	sample_paths_table_sorted = kUtil.alpha_numeric_sort(sample_paths_table)
	local file = io.open(result_file,"wb")
	io.close(file)
	for i=1,#sample_paths_table_sorted-1 do
		if i==1 then
			KSox.concatenate_audio(sample_paths_table_sorted[i],sample_paths_table_sorted[i+1],result_file,verbose_mode)
		else
			KSox.concatenate_audio(result_file,sample_paths_table_sorted[i+1],result_file,verbose_mode)
		end
	end
end

--- Convert an audio file to wav file format.
-- @tparam string input_file the path to the audio file to be converted.
-- @tparam string output_file the desired path and name for the resulting audio file.
-- @tparam bool verbose_mode when true prints information to console.
function KSox.convert_audio_wav(input_file,output_file,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Convert to WAV ------") end
	if output_file == nil or output_file == "same" then output_file = input_file..".wav" end
	local s0 = sox_path
	local verbose_string = KSox.set_verbose_string(verbose_mode)
	local execute_string = string.format([[%s %s "%s" "%s"]],s0,verbose_string,input_file,output_file)
	kFile.run_file_process(execute_string,file,temp_file)
	if verbose_mode then print("File format converted to WAV") end	
end

-- return the KSox object.
return KSox