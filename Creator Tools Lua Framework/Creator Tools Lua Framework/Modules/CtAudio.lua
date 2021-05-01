----------------------------------------------------------------------------------------------------
-- Creator Tools LUA Audio Utilities File 
----------------------------------------------------------------------------------------------------
-- Author: Native Instruments
-- Written by: Yaron Eshkar
-- Modified: April 23, 2021
--
-- This file includes useful functions for usage in Creator Tools Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local ctAudio = require("CtAudio")
-- Then you can simply call any function like:
-- ctAudio.test_function()
--
-- It is also possible of course to copy entire specific functions from this list directly into your script. 
-- In that case remove the CtAudio part from the function name, and then simply call it normally like:
-- test_function()
--
local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

dofile(root_path .. filesystem.preferred("/Modules/CtWav.lua"))
local ctFile = require("Modules.CtFile")
local ctMir = require("Modules.CtMir")
local ctUtil = require("Modules.CtUtil")
if sox_path == nil then require("Modules.paths_file") end

local CtAudio = {}

--- Test Function.
-- Takes no arguments, prints to console when called.
function CtAudio.test_function()
	-- Show that the class import and test function executes by printing a line.
	print("Test function called")
end

--- Sets Verbose Mode for SoX operations.
-- @tparam bool verbose_mode set to true or false.
-- @treturn string returns either "-V3" when verbose_mode is true or "-V0" when false or nil.
function CtAudio.set_verbose_string(verbose_mode)
	local verbose_string
	if verbose_mode then 
		verbose_string = "-V3"
	else
		verbose_string = "-V0"
	end
	return verbose_string
end

--- Decode a FLAC file to WAV.
-- @tparam string input_file the path to the FLAC file to decode.
-- @tparam string output_file the desired path of the output file. Defaults to input_file.wav.
-- @tparam bool delete_original when true the original file is deleted after the operation.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool
function CtAudio.decode_flac(input_file,output_file,delete_original,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Decoding FLAC----------") end
	if output_file == nil then output_file = input_file..".wav" end
	local s0 = flac_path
	local s1 = "-d"
	local s2 = "--keep-foreign-metadata"
	local s3 = "-o"
	local execute_string = string.format([[%s %s %s %s "%s" "%s"]],s0,s1,s2,s3,output_file,input_file) 
	if verbose_mode then print("Decoded "..input_file.." to WAV ") end
	ctFile.run_shell_command(execute_string,false)
	if delete_original then ctFile.delete_file(input_file) end
	return true
end

--- Encode a WAV file to FLAC.
-- @tparam string input_file the path to t he WAV file to encode.
-- @tparam string output_file the desired path of the output file. Defaults to input_file.flac.
-- @tparam bool delete_original when true the original file is deleted after the operation.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool
function CtAudio.encode_flac(input_file,output_file,delete_original,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Encoding FLAC----------") end
	if output_file == nil or output_file == "same" then output_file = input_file..".flac" end
	s0 = flac_path
	s1 = "--keep-foreign-metadata"
	s2 = "-o"
	local execute_string = string.format([[%s %s %s "%s" "%s"]],s0,s1,s2,output_file,input_file)
	if verbose_mode then print("Encoded "..input_file.." to FLAC ") end
	ctFile.run_shell_command(execute_string,false)
	if delete_original then ctFile.delete_file(file) end
	return true
end

--- Encode a WAV file to OGG.
-- @tparam string input_file the path to t he WAV file to encode.
-- @tparam string compression_factor the OGG compression factor, defaults to  5.
-- @tparam string output_file the desired path of the output file. Defaults to input_file.ogg.
-- @tparam bool delete_original when true the original file is deleted after the operation.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool
function CtAudio.encode_ogg(input_file,compression_factor,output_file,delete_original,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Encoding OGG---------") end
	if compression_factor == nil then compression_factor = 5 end
	if output_file == nil or output_file == "same" then output_file = input_file..".ogg" end
	local verbose_string = CtAudio.set_verbose_string(verbose_mode)
	local s0 = sox_path
	local s1 = "-C"
	local s2 = compression_factor
	local execute_string = string.format([[%s %s "%s" %s %s "%s"]],s0,verbose_string,input_file,s1,s2,output_file)
	ctFile.run_file_process(execute_string,file,temp_file)
	if verbose_mode then print("Encoded "..input_file.." to OGG ") end
	ctFile.run_shell_command(execute_string,false)
	if delete_original then ctFile.delete_file(input_file) end
	return true
end

--- Filter an audio file.
-- @tparam string file the audio file to filter.
-- @tparam string filter_type filter type. Can be:
--
-- highpass
--
-- lowpass
--
-- @tparam string filter_cut cutoff point of the filter.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool
function CtAudio.filter_audio(file,filter_type,filter_cut,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Apply "..filter_type.." Filter----------") end
	if filter_type == nil then filter_type = "highpass" end
	if filter_cut == nil then filter_cut = "10" end
	local verbose_string = CtAudio.set_verbose_string(verbose_mode)
	local temp_file = scriptPath..filesystem.preferred("/temp.wav")
	local s0 = sox_path
	local execute_string = string.format([[%s %s "%s" "%s" %s %s]],s0,verbose_string,file,temp_file,filter_type,filter_cut)
	ctFile.run_file_process(execute_string,file,temp_file)
	if verbose_mode then print("Performed "..filter_type.." filtering on "..file) end
	return true
end

--- Reverse an audio file.
-- @tparam string file the source file to reverse. 
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool 
function CtAudio.reverse_audio(file,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Apply Reverse----------") end
	local verbose_string = CtAudio.set_verbose_string(verbose_mode)
	local temp_file = scriptPath..filesystem.preferred("/temp.wav")
	local s0 = sox_path
	local execute_string = string.format([[%s %s "%s" "%s" %s]],s0,verbose_string,file,temp_file,"reverse")
	ctFile.run_file_process(execute_string,file,temp_file)
	if verbose_mode then print("Performed reverse on "..file) end
	return true
end

--- Remove silence from the start if an audio file.
-- @tparam string file the source file to remove silence from. 
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool 
function CtAudio.silence_remove_audio(file,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Remove Silence----------") end
	local verbose_string = CtAudio.set_verbose_string(verbose_mode)
	local temp_file = scriptPath..filesystem.preferred("/temp.wav")
	local s0 = sox_path
	local s1 = "silence"
	local s2 = "1"
	local s3 = "0.1"
	local s4 = "1%"
	local execute_string = string.format([[%s %s "%s" "%s" %s %s %s %s]],s0,verbose_string,file,temp_file,s1,s2,s3,s4)
	ctFile.run_file_process(execute_string,file,temp_file)
	if verbose_mode then print("Performed silence removal on "..file) end
	return true
end

--- Normalize peaks of an audio file to set dB.
-- @tparam string file the source file to normalise. 
-- @tparam string dB setting to normalise to. 
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool 
function CtAudio.normalize_audio(file,normalize_db,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------normalize Audio----------") end
	local verbose_string = CtAudio.set_verbose_string(verbose_mode)
	local temp_file = scriptPath..filesystem.preferred("/temp.wav")
	local s0 = sox_path
	local s1 = "gain"
	local s2 = "-n"
	local execute_string = string.format([[%s %s "%s" "%s" %s %s %s]],s0,verbose_string,file,temp_file,s1,s2,normalize_db)
	ctFile.run_file_process(execute_string,file,temp_file)
	if verbose_mode then print("Performed normalize to "..normalize_db.."dB on "..file) end
	return true
end

--- Append an audio file to the end of another.
-- @tparam string file1 the path to the first source audio file. 
-- @tparam string file2 the path to the second source audio file to append to the first. 
-- @tparam string file3 the desired path and name for the resulting audio file. 
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool 
function CtAudio.concatenate_audio(file1,file2,file3,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Concatenate Audio----------") end
	local verbose_string = CtAudio.set_verbose_string(verbose_mode)
	local temp_file = scriptPath..filesystem.preferred("/temp.wav")
	local s0 = sox_path
	local execute_string = string.format([[%s %s "%s" "%s" "%s"]],s0,verbose_string,file1,file2,temp_file)
	ctFile.run_shell_command(execute_string,false)
	ctFile.copy_file(temp_file,file3)
	ctFile.delete_file(temp_file)
	if verbose_mode then print(file2.." appended to "..file1) end
	return true
end

--- Append all audio found in a folder in an alphanumeric order.
-- @tparam string path the path to the directory containing audio files.
-- @tparam string result_file the desired path and name for the resulting audio file. 
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool 
function CtAudio.concatenate_audio_folder(path,result_file,verbose_mode)
	local sample_paths_table = {}
	sample_paths_table = ctUtil.paths_to_table(path,".wav")
	sample_paths_table_sorted = ctUtil.alpha_numeric_sort(sample_paths_table)
	local file = io.open(result_file,"wb")
	io.close(file)
	for i=1,#sample_paths_table_sorted-1 do
		if i==1 then
			CtAudio.concatenate_audio(sample_paths_table_sorted[i],sample_paths_table_sorted[i+1],result_file,verbose_mode)
		else
			CtAudio.concatenate_audio(result_file,sample_paths_table_sorted[i+1],result_file,verbose_mode)
		end
	end
	return true
end

--- Convert an audio file to wav file format.
-- @tparam string input_file the path to the audio file to be converted.
-- @tparam string output_file the desired path and name for the resulting audio file.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool 
function CtAudio.convert_audio_wav(input_file,output_file,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Convert to WAV ------") end
	if output_file == nil or output_file == "same" then output_file = input_file..".wav" end
	local s0 = sox_path
	local verbose_string = CtAudio.set_verbose_string(verbose_mode)
	local execute_string = string.format([[%s %s "%s" "%s"]],s0,verbose_string,input_file,output_file)
	ctFile.run_file_process(execute_string,file,temp_file)
	if verbose_mode then print("File format converted to WAV") end	
	return true
end

--- Convert the bit depth of an audio file.
-- @tparam string file the path to the audio file to be converted.
-- @tparam string original_bit_depth the original sample rate of the audio file.
-- @tparam string out_bit_depth the desired new sample rate for the file.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool 
function CtAudio.convert_audio_bd(file,original_bit_depth,out_bit_depth,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Convert Bit Depth ------") end
	local verbose_string = CtAudio.set_verbose_string(verbose_mode)
	if original_bit_depth == tonumber(out_bit_depth) then 
		if verbose_mode then print("Original and output bit depths are identical, no conversion performed") end
		return
	end
	local temp_file = scriptPath..filesystem.preferred("/temp.wav")
	local s0 = sox_path
	local s1 = "-b"
	local execute_string = string.format([[%s %s "%s" %s %s "%s"]],s0,verbose_string,file,s1,out_bit_depth,temp_file)
	ctFile.run_file_process(execute_string,file,temp_file)
	if verbose_mode then print("Bit depth converted from "..original_bit_depth.." to "..out_bit_depth) end	
	return true
end

--- Convert the sample rate of an audio file.
-- @tparam string file the path to the audio file to be converted.
-- @tparam string original_sample_rate the original sample rate of the audio file.
-- @tparam string out_sample_rate the desired new sample rate for the file.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool 
function CtAudio.convert_audio_sr(file,original_sample_rate,out_sample_rate,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Convert Sample Rate ------") end
	local verbose_string = CtAudio.set_verbose_string(verbose_mode)
	if original_sample_rate == tonumber(out_sample_rate) then 
		if verbose_mode then print("Original and output samplerate are identical, no conversion performed") end
		return
	end
	local temp_file = scriptPath..filesystem.preferred("/temp.wav")
	local s0 = sox_path
	local s1 = "-r"
	local execute_string = string.format([[%s %s "%s" %s %s "%s"]],s0,verbose_string,file,s1,out_sample_rate,temp_file)
	ctFile.run_file_process(execute_string,file,temp_file)
	if verbose_mode then print("Samplerate converted from "..original_sample_rate.." to "..out_sample_rate) end	
	return true
end

--- Wave Synth
-- Synthesize a wave audio file.
-- @tparam string output_file the desired path of the output file. Defaults to synth.wav in the directory where script was run.
-- @tparam string sampl_rate the sample rate of the resulting file. Defaults to 44100.
-- @tparam string length the length of the resulting sample in seconds. Defaults to 0.5.
-- @tparam string shape the shape of the wave. Defaults to sine, can be one of:
--
-- sine
--
-- triangle
--
-- sawtooth
--
-- trapezium
--
-- exp
--
-- noise
--
-- tpdfnoise
--
-- pinknoise
--
-- brownnoise
--
-- pluck
-- @tparam string freq the frequency of the wave.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool 
function CtAudio.wave_synth(output_file,sample_rate,length,shape,freq,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Synth Wave Generator------") end
	if output_file == nil then output_file = scriptPath .. filesystem.preferred("/synth.wav") end
	if sample_rate == nil then sample_rate = "44100" end
	if length == nil then length = "0.5" end
	if shape == nil then shape = "sine" end
	if freq == nil then freq = "130.81" end
	local s0 = sox_path
	local s1 = "-r"
	local s2 = sample_rate
	local s3 = "-n"
	local s4 = output_file
	local s5 = "synth"
	local s6 = length
	local s7 = shape
	local s8 = freq
	local execute_string
	local execute_string = string.format([[%s %s %s %s "%s" %s %s %s %s]],s0,s1,s2,s3,s4,s5,s6,s7,s8)
	ctFile.run_shell_command(execute_string,false)
	if verbose_mode then print(shape.." wave "..output_file.." created") end	
	return true
end

--- Kick Synth.
-- kick audio sample generator.
-- @tparam string output_file output_file the desired path of the output file. Defaults to kick.wav in the directory where script was run.
-- @tparam string sample_rate the sample rate of the resulting files. Defaults to 44100.
-- @tparam string length the total length of the sample in seconds. Defaults to 0.5
-- @tparam string start_freq the starting frequency of the oscillation. Defaults to 100.
-- @tparam string end_freq the end frequency of the oscillation. Defaults to 40.
-- @tparam string bend_start the place in the sample from which to start the bend operation in % of overall sample length. Defaults to 0.
-- @tparam string bend_end the place in the sample where the bend operation will end in % of overall sample length. Defaults to 0.25.
-- @tparam string bend_freq the amount of pitch bend to apply over time from bend_start to bend_end, in cents. Defaults to -1200.
-- @tparam bool bend_twice when true, performs the bend operation twice.
-- @tparam string fade_time the volume fade out time, in % of overall sample length.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool 
function CtAudio.kick_synth(output_file,sample_rate,length,start_freq,end_freq,bend_start,bend_end,bend_freq,bend_twice,fade_time,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("----------Kick Synth Generator------") end
	if output_file == nil then output_file = scriptPath .. filesystem.preferred("/kick.wav") end
	if sample_rate == nil then sample_rate = "44100" end
	if length == nil then length = "0.5" end
	if start_freq == nil then start_freq = "100" end
	if end_freq == nil then end_freq = "40" end
	if bend_start == nil then bend_start = "0" end
	if bend_freq == nil then bend_freq = "-1200" end
	if bend_end == nil then bend_end = "0.25" end
	if fade_time == nil then fade_time = "0.5" end
	local freq_range = start_freq.."-"..end_freq
	local bend_range = bend_start..","..bend_freq..","..bend_end 
	local s0 = sox_path
	local s1 = "-r"
	local s2 = sample_rate
	local s3 = "-n"
	local s4 = output_file
	local s5 = "synth"
	local s6 = length
	local s7 = "sine"
	local s8 = freq_range
	local s9 = "gain"
	local s10 = "-10"
	local s11 = "bend"
	local s12 = bend_range
	local s13 = "highpass"
	local s14 = "10"
	local s15 = "fade"
	local s16 = "t"
	local s17 = "0"
	local s18 = "-0"
	local s19 = fade_time
	local s20 = "gain"
	local s21 = "-n"
	local s22 = "-1"
	local s23 = "silence"
	local s24 = "1"
	local s25 = "0.1"
	local s26 = "1%"
	local s27 = "fade"
	local s28 = "t"
	local s29 = "0.003"
	local execute_string
	if bend_twice then 
		execute_string = string.format([[%s %s %s %s "%s" %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s]],s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24,s25,s26,s27,s28,s29)
	else
		execute_string = string.format([[%s %s %s %s "%s" %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s]],s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24,s25,s26,s27,s28,s29)
	end
	ctFile.run_shell_command(execute_string,false)
	if verbose_mode then print("Kick "..output_file.." created") end	
	return true
end

--- Extract a chunk from a WAV file.
-- @tparam string input_file the file to open.
-- @tparam int chunk_position the starting byte position of the chunk.
-- @tparam int chunk_size the length of the chunk in bytes.
-- @treturn string returns a string containing the chunk.
function CtAudio.get_wav_chunk(input_file,chunk_position,chunk_size)
	local file = io.open(input_file,"rb")
	local wav_chunk
	file:seek("set",chunk_position)
	wav_chunk = file:read(chunk_size)
    io.close(file)
    return wav_chunk
end

--- Inject the smpl chunk into the header of a WAV file.
-- @tparam string input_file the WAV file to inject the smpl chunk into.
-- @tparam string file_size the total file size.
-- @tparam string channels_number the number of audio channels.
-- @tparam string riff_chunk the riff chunk.
-- @tparam string fmt_chunk the fmt chunk.
-- @tparam string data_chunk the data chunk.
-- @tparam string fact_chunk the fact chunk.
-- @tparam string manufacturer manufacturer ID.
-- @tparam string product
-- @tparam string srate sample period.
-- @tparam string mroot MIDI root.
-- @tparam string mpitch MIDI pitch.
-- @tparam string smptef SMPTE format.
-- @tparam string smpteo MPTE offset.
-- @tparam string lnum Number of loops.
-- @tparam string sdata Sampler data size.
-- @tparam string lcue loop cue.
-- @tparam string ltype loop type.
-- @tparam string lstart loop start.
-- @tparam string lend loop end.
-- @tparam string lfraction loop fraction.
-- @tparam string ltimes loop times.
-- @treturn bool
function CtAudio.inject_smpl_chunk(input_file,file_size,channels_number,riff_chunk,fmt_chunk,data_chunk,fact_chunk,manufacturer,product,srate,mroot,mpitch,smptef,smpteo,lnum,sdata,lcue,ltype,lstart,lend,lfraction,ltimes)
	local file = io.open(input_file,"wb")
	file:write(riff_chunk)
	file:seek("set",4)
	file:write(ctUtil.ntob(file_size+60,4))
	file:seek("set",12)
	file:write(fmt_chunk)
	if fact_chunk then file:write(fact_chunk) end
	file:write(data_chunk)
	file:write("smpl",
		ctUtil.ntob(60,4), --chunk size
		ctUtil.ntob(manufacturer,4), --manufacturer
		ctUtil.ntob(product,4), --product
		ctUtil.ntob(string.sub(tostring(1/srate),0,6):gsub("%.",""),4), -- sample period
		ctUtil.ntob(mroot,4), -- midi root
		ctUtil.ntob(mpitch,4), -- midi pitch
		ctUtil.ntob(smptef,4), -- SMPTE format
		ctUtil.ntob(smpteo,4), -- SMPTE offset
		ctUtil.ntob(lnum,4), -- num loops
		ctUtil.ntob(0,4), -- sampler data
		ctUtil.ntob(lcue,4), -- loop cue
		ctUtil.ntob(ltype,4), -- loop type
		ctUtil.ntob(lstart,4), -- loop start
		ctUtil.ntob(lend,4), -- loop end
		ctUtil.ntob(lfraction,4), -- loop fraction
		ctUtil.ntob(ltimes,4)) -- loop times	
    io.close(file)
    return true
end

--- Run an audio process on a WAV file.
-- @tparam string file the path to the file to process.
-- @tparam string process_type the type of process to run. Can be one of:
--
-- normalize
--
-- filter
--
-- reverse
--
-- silence
--
-- convert_sr
--
-- convert_bd
--
-- concatenate
-- @tparam string param1 the first parameter to pass to the audio process.
-- @tparam string param2 the second parameter to pass to the audio process.
-- @tparam string param3 the third parameter to pass to the audio process.
-- @tparam string param4 the fourth parameter to pass to the audio process.
-- @treturn bool
function CtAudio.run_audio_process(file,process_type,param1,param2,param3,param4)
	local reader = wav.create_context(file, "r")
	local original_file_samples = reader.get_samples_per_channel()
	local original_sample_rate = reader.get_sample_rate()
	local original_bit_depth = reader.get_bits_per_sample()
	-- smpl chunk 
	local midi_root = reader.get_midi_root_note()
	if midi_root == nil then midi_root = 0 end
	local midi_pitch = reader.get_midi_pitch_fraction()
	if midi_pitch == nil then midi_pitch = 0 end
	local smptef = reader.get_smpte_format()
	if smptef == nil then smptef = 0 end
	local smpto =  reader.get_smpte_offset()
	if smpteo == nil then smpteo = 0 end
	local loop_count = reader.get_loop_count()

	local loop_cue
	local loop_type
	local loop_start
	local loop_end
	local loop_fraction
	local loop_times
	local loop_start_ms
	local loop_end_ms
	if loop_count and loop_count>0 then
		loop_cue = reader.get_loop_cue()[1]
		loop_start = reader.get_loop_start()[1]
		loop_end = reader.get_loop_end()[1]
		loop_type = reader.get_loop_type()[1]
		loop_fraction = reader.get_loop_fraction()[1]
		loop_times = reader.get_loop_times()[1]
	else
		loop_count = 0
		loop_cue = 0
		loop_type = 0
		loop_start = 0
		loop_end = 0
		loop_fraction = 0
		loop_times = 0
	end

	local process_done

	if process_type == "normalize" then
		process_done = CtAudio.normalize_audio(file,param1,param2)
	elseif process_type == "filter" then
		process_done = CtAudio.filter_audio(file,param1,param2,param3)
	elseif process_type == "reverse" then
		process_done = CtAudio.reverse_audio(file,param1)
	elseif process_type == "silence" then
		process_done = CtAudio.silence_remove_audio(file,param1)
		local reader = wav.create_context(file, "r")
		local new_file_samples = reader.get_samples_per_channel()
		local file_length_change = original_file_samples-new_file_samples
		if loop_count and loop_count>0 then
			loop_start = loop_start-file_length_change
			loop_end =  loop_end-file_length_change
		end
	elseif process_type == "convert_sr" then
		process_done = CtAudio.convert_audio_sr(file,original_sample_rate,param1,param2)
		local reader = wav.create_context(file, "r")
		local new_sample_rate = reader.get_sample_rate()
		if loop_count and loop_count>0 then
			loop_start = loop_start * (new_sample_rate / original_sample_rate)
			loop_end =  loop_end * (new_sample_rate / original_sample_rate)
		end
		original_sample_rate = new_sample_rate
	elseif process_type == "convert_bd" then
		process_done = CtAudio.convert_audio_bd(file,original_bit_depth,param1,param2)
	elseif process_type == "concatenate" then
		CtAudio.concatenate_audio(file,param1,param2,param3)
		-- we don't have an smpl chunk to set after this operation, so do not set process done
	end

	if process_done then
		local reader = wav.create_context(file, "r")

		local fmt_size = reader.get_chunk_size("fmt")
		local fmt_position = reader.get_chunk_position("fmt")
		local data_position = reader.get_chunk_position("data")
		local data_size = reader.get_chunk_size("data")
		local fact_position = reader.get_chunk_position("fact")
		local fact_size = reader.get_chunk_size("fact")
		
		local riff_chunk = CtAudio.get_wav_chunk(file,0,fmt_position) 
		local fmt_chunk = CtAudio.get_wav_chunk(file,fmt_position,fmt_size+8)
		--local data_chunk = CtAudio.get_wav_chunk(file,data_position,data_size+8+1)
		local data_chunk = CtAudio.get_wav_chunk(file,data_position,data_size+8)
		local fact_chunk
		if fact_position then fact_chunk = CtAudio.get_wav_chunk(file,fact_position,fact_size+8) end

		local file_size = reader.get_file_size()
		local channels_number = reader.get_channels_number()
		local sampler_data = 0
	
		CtAudio.inject_smpl_chunk(file,file_size,channels_number,riff_chunk,fmt_chunk,data_chunk,fact_chunk,002109,1,original_sample_rate,midi_root,midi_pitch,smptef,smpteo,loop_count,sampler_data,loop_cue,loop_type,loop_start,loop_end,loop_fraction,loop_times)
	end

	return true
end

--- Check the integrity of a directory of samples using various comparison metrics.
-- @tparam string path the path to the directory of samples to check and compare.
-- @tparam bool verbose_mode when true prints information to console.
-- @tparam bool perform_rms_check when true, compare RMS values.
-- @tparam number deviance_rms_factor the accpetable deviance in RMS valus between the files.
-- @tparam bool perform_loudness_check when true, compare loudness values.
-- @tparam number deviance_loudness_factor the accpetable deviance in loudness valus between the files.
-- @tparam bool perform_peak_check when true, compare peak values.
-- @tparam number deviance_peak_factor the accpetable deviance in peak valus between the files.
-- @tparam bool perform_rate_check when true, compare sample rate values.
-- @tparam int expected_sample_rate the expected sample rate. Defaults to 44100.
-- @tparam bool perform_depth_check when true, compare bit depth values.
-- @tparam int expected_bit_depth the expected bit depth. Defaults to 24.
-- @tparam bool perform_loop_check when true, compare check if loop points exists. 
-- @tparam bool expected_loop when true and performing a loop check, the check should pass if a loop exists.
-- @tparam bool perform_file_size_check when true, compare file size values.
-- @tparam int deviance_file_size_factor the acceptable different between the file sizes.
-- @tparam bool perform_file_names_check when true, compare file names, if duplicates exist the check fails.
-- @treturn bool returns true when all checks pass, false when any check fails.
function CtAudio.check_sample_set_integrity(path,verbose_mode,perform_rms_check,deviance_rms_factor,perform_loudness_check,deviance_loudness_factor,perform_peak_check,deviance_peak_factor,perform_rate_check,expected_sample_rate,perform_depth_check,expected_bit_depth,perform_loop_check,expected_loop,perform_file_size_check,deviance_file_size_factor,perform_file_names_check)

	if verbose_mode == nil then verbose_mode = true end

	if perform_rms_check == nil then perform_rms_check = true end
	if deviance_rms_factor == nil then deviance_rms_factor = 2 end
	if perform_loudness_check == nil then perform_loudness_check = true end
	if deviance_loudness_factor == nil then deviance_loudness_factor = 2 end
	if perform_peak_check == nil then perform_peak_check = true end
	if deviance_peak_factor == nil then deviance_peak_factor = 0.5 end
	if perform_rate_check == nil then perform_rate_check = true end
	if expected_sample_rate == nil then expected_sample_rate = 44100 end
	if perform_depth_check == nil then perform_depth_check = true end
	if expected_bit_depth == nil then expected_bit_depth = 24 end
	if perform_loop_check == nil then perform_loop_check = true end
	if expected_loop == nil then expected_loop = true end
	if perform_file_size_check == nil then perform_file_size_check = true end
	if deviance_file_size_factor == nil then deviance_file_size_factor = 6000000 end

	local sample_paths_table = {}

	sample_paths_table = ctUtil.paths_to_table(path,".wav")
	table.sort(sample_paths_table)

	-- local pitch_table = {}
	local rms_table = {}
	local peak_table = {}
	local loudness_table = {}
	local file_size_table = {}

	local total_rms = 0
	local total_peak = 0
	local total_loudness = 0
	local total_file_size = 0

	local integrity_error

	for index, file in pairs(sample_paths_table) do
		-- local pitch
		local rms
		local peak
		local loudness
		
		if perform_rms_check or perform_loudness_check or perform_peak_check then
			-- pitch = ctUtil.round_num(ctMir.mir_detect(file,"pitch",false))
			rms = ctMir.mir_detect(file,"rms",false)
			peak = ctMir.mir_detect(file,"peak",false)
			loudness = ctMir.mir_detect(file,"loudness",false)
			-- table.insert(pitch_table, pitch)
			table.insert(rms_table, rms)
			table.insert(peak_table, peak)
			table.insert(loudness_table, loudness)

			total_rms = total_rms + rms
			total_peak = total_peak + peak
			total_loudness = total_loudness + loudness
		end

		if perform_file_size_check then
			local reader = wav.create_context(file, "r")
			local file_size = reader.get_file_size()
			
			table.insert(file_size_table, file_size)

			total_file_size = total_file_size + file_size
		end
	end

	if perform_rms_check then 
		ctUtil.dash_sep_print(verbose_mode)
		ctUtil.debug_print("RMS Table",verbose_mode)
		ctUtil.debug_print_r(rms_table,verbose_mode) 
		ctUtil.dash_sep_print(verbose_mode)
	end
	if perform_peak_check then
		ctUtil.dash_sep_print(verbose_mode)
		ctUtil.debug_print("Peak Table",verbose_mode)
		ctUtil.debug_print_r(peak_table,verbose_mode) 
		ctUtil.dash_sep_print(verbose_mode)
	end
	if perform_loudness_check then
		ctUtil.dash_sep_print(verbose_mode)
		ctUtil.debug_print("Loudness Table",verbose_mode)
		ctUtil.debug_print_r(loudness_table,verbose_mode) 
		ctUtil.dash_sep_print(verbose_mode)
	end


	local average_rms
	local average_peak
	local average_loudness
	local average_file_size

	if perform_rms_check then 
		average_rms = total_rms / #sample_paths_table 
		ctUtil.dash_sep_print(verbose_mode)
		ctUtil.debug_print("Average RMS: "..average_rms,verbose_mode)
		ctUtil.dash_sep_print(verbose_mode)
	end
	if perform_peak_check then 
		average_peak = total_peak / #sample_paths_table 
		ctUtil.dash_sep_print(verbose_mode)
		ctUtil.debug_print("Average Peak: "..average_peak,verbose_mode)
		ctUtil.dash_sep_print(verbose_mode)
	end
	if perform_loudness_check then 
		average_loudness = total_loudness / #sample_paths_table 
		ctUtil.dash_sep_print(verbose_mode)
		ctUtil.debug_print("Average Loudness: "..average_loudness,verbose_mode)
		ctUtil.dash_sep_print(verbose_mode)
	end
	if perform_file_size_check then 
		average_file_size = total_file_size / #sample_paths_table 
	end

	if perform_rms_check then
		local rms_check_table = {}
		for i=1,#sample_paths_table do
			local deviance_rms = math.abs(rms_table[i] - average_rms) 
			if deviance_rms > deviance_rms_factor then 
				table.insert(rms_check_table,"Sample: "..sample_paths_table[i].." is deviating from average RMS by "..deviance_rms)
			end
		end
		if #rms_check_table>0 then
			ctUtil.debug_print("RMS deviations detected",verbose_mode)
			for i=1,#rms_check_table do
				print(rms_check_table[i])
			end
			integrity_error = true
			ctUtil.dash_sep_print(verbose_mode)
		end
	end

	if perform_peak_check then
		local peak_check_table = {}
		for i=1,#sample_paths_table do
			local deviance_peak = math.abs(peak_table[i] - average_peak) 
			if deviance_peak > deviance_peak_factor then 
				table.insert(peak_check_table,"Sample: "..sample_paths_table[i].." is deviating from average Peak by "..deviance_peak)
			end
		end
		if #peak_check_table>0 then
			ctUtil.debug_print("Peak deviations detected",verbose_mode)
			for i=1,#peak_check_table do
				print(peak_check_table[i])
			end
			integrity_error = true
			ctUtil.dash_sep_print(verbose_mode)
		end
	end

	if perform_loudness_check then
		local loudness_check_table = {}
		for i=1,#sample_paths_table do
			local deviance_loudness = math.abs(loudness_table[i] - average_loudness) 
			if deviance_loudness > deviance_loudness_factor then 
				table.insert(loudness_check_table,"Sample: "..sample_paths_table[i].." is deviating from average Loudness by "..deviance_loudness)
			end
		end
		if #loudness_check_table>0 then
			ctUtil.debug_print("Loudness deviations detected",verbose_mode)
			for i=1,#loudness_check_table do
				print(loudness_check_table[i])
			end
			integrity_error = true
			ctUtil.dash_sep_print(verbose_mode)
		end
	end

	if perform_rate_check then
		local sample_rate_check_table = {}
		for i=1,#sample_paths_table do
			local reader = wav.create_context(sample_paths_table[i], "r")
			local file_sample_rate = reader.get_sample_rate()
			if file_sample_rate ~= expected_sample_rate then 
				table.insert(sample_rate_check_table,"Sample: "..sample_paths_table[i].." wrong sample rate. Expected "..expected_sample_rate.." got "..file_sample_rate)
			end
		end
		if #sample_rate_check_table>0 then
			ctUtil.debug_print("Sample rate deviations detected",verbose_mode)
			for i=1,#sample_rate_check_table do
				print(sample_rate_check_table[i])
			end
			integrity_error = true
			ctUtil.dash_sep_print(verbose_mode)
		end
	end

	if perform_depth_check then
		local bit_depth_check_table = {}
		for i=1,#sample_paths_table do
			local reader = wav.create_context(sample_paths_table[i], "r")
			local file_bit_depth = reader.get_bits_per_sample()
			if file_bit_depth ~= expected_bit_depth then 
				table.insert(bit_depth_check_table,"Sample: "..sample_paths_table[i].." wrong bit depth. Expected "..expected_bit_depth.." got "..file_bit_depth)
			end
		end
		if #bit_depth_check_table>0 then
			ctUtil.debug_print("Bit depth deviations detected",verbose_mode)
			for i=1,#bit_depth_check_table do
				print(bit_depth_check_table[i])
			end
			integrity_error = true
			ctUtil.dash_sep_print(verbose_mode)
		end
	end	

	if perform_loop_check then
		local loop_check_table = {}
		for i=1,#sample_paths_table do
			local reader = wav.create_context(sample_paths_table[i], "r")
			local loop_exists = reader.get_loop_count()
			if expected_loop and not loop_exists then 
				table.insert(loop_check_table,"Sample: "..sample_paths_table[i].." does not contain a loop, Loop expected")
			elseif not expected_loop and loop_exists then 
				table.insert(loop_check_table,"Sample: "..sample_paths_table[i].." contains a loop, Loop unexpected")
			end
		end
		if #loop_check_table>0 then
			ctUtil.debug_print("Loop check deviations detected",verbose_mode)
			for i=1,#loop_check_table do
				print(loop_check_table[i])
			end
			integrity_error = true
			ctUtil.dash_sep_print(verbose_mode)
		end
	end	

	if perform_file_size_check then
		local file_size_check_table = {}
		for i=1,#sample_paths_table do
			local reader = wav.create_context(sample_paths_table[i], "r")
			local file_size = reader.get_file_size()
			local deviance_file_size = math.abs(file_size_table[i] - average_file_size) 
			if deviance_file_size > deviance_file_size_factor then 
				table.insert(file_size_check_table,"Sample: "..sample_paths_table[i].." is deviating from average file size by "..deviance_file_size)
			end
		end
		if #file_size_check_table>0 then
			ctUtil.debug_print("File size deviations detected",verbose_mode)
			for i=1,#file_size_check_table do
				print(file_size_check_table[i])
			end
			integrity_error = true
			ctUtil.dash_sep_print(verbose_mode)
		end
	end

	if perform_file_names_check then
		ctFile.check_duplicate_file_names(path,".wav",verbose_mode)
	end

	return not integrity_error
end	

--- Reads and prints detailed information about a WAV file.
-- The following information is printed to console:
--
-- File mode
--
-- File name
--
-- Header chunks list
--
-- File size
--
-- Channels
-- 
-- Sample rate
--
-- Byte rate
--
-- Block align
--
-- Bit depth
--
-- Samples per channel
--
-- Header size
--
-- Chunk data size
--
-- Chunk fmt size
--
-- Chunk smpl size
--
-- Chunk fact size
--
-- Extra chunks size
--
-- Chunk fmt position
--
-- Chunk data position
--
-- Chunk smpl position
--
-- Chunk fact position
--
-- Loop count position
--
-- Sampler data size
--
-- Number of loops
--
-- Loop cue
--
-- Loop cue position
--
-- Loop type
-- 
-- Loop type position
--
-- Loop start
--
-- Loop start position
--
-- Loop end
--
-- Loop end position
--
-- Loop fraction
--
-- Loop fraction position
--
-- Loop times
--
-- Loop times position
--
-- @tparam string input_file the WAV file to read.
-- @treturn bool
function CtAudio.read_audio_file(inputFile)
	local dash_sep = "------------------------------------------------"
	-- Read audio file
	local reader = wav.create_context(inputFile, "r")
	print("File mode: "..reader.get_mode())
	print("Filename: " .. reader.get_filename())
	print(dash_sep)
	print("Following header chunks found: ")
	ctUtil.print_r(reader.get_chunk_list())
	print(dash_sep)
	print("File size: " .. reader.get_file_size())
	print("Channels: " .. reader.get_channels_number())
	print("Sample rate: " .. reader.get_sample_rate())
	print("Byte rate: " .. reader.get_byte_rate())
	print("Block align: " .. reader.get_block_align())
	print("Bitdepth: " .. reader.get_bits_per_sample())
	print("Samples per channel: " .. reader.get_samples_per_channel())
	print(dash_sep)
	print ("Header Size: "..reader.get_chunk_size("header") )
	print ("Chunk data size: "..reader.get_chunk_size("data") )
	print ("Chunk fmt size: "..reader.get_chunk_size("fmt") )
	if reader.get_chunk_size("smpl") then print ("Chunk smpl size: "..reader.get_chunk_size("smpl") ) end
		if reader.get_chunk_size("fact") then print ("Chunk fact size: "..reader.get_chunk_size("fact") ) end
	if reader.get_chunk_size("extra") then print ("Extra chunks size: "..reader.get_chunk_size("extra") ) end
	print(dash_sep)
	print("Chunk fmt position: "..reader.get_chunk_position("fmt") )
	print("Chunk data position: "..reader.get_chunk_position("data") )
	if reader.get_chunk_position("smpl") then print("Chunk smpl position: "..reader.get_chunk_position("smpl") ) end
	if reader.get_chunk_position("fact") then print("Chunk fact position: "..reader.get_chunk_position("fact") ) end
	print(dash_sep)
	if reader.get_chunk_size("smpl")>0 then 
		print ("loop count position: "..reader.get_loop_count_position())
		print("Sampler data size: "..reader.get_sampler_data_size())
		if reader.get_loop_count() then
			print("Number of loops: "..reader.get_loop_count())
			if reader.get_loop_count() then
			print("Loop Cue: ")
			ctUtil.print_r(reader.get_loop_cue())
			print("Loop Cue position: ")
			ctUtil.print_r(reader.get_loop_position("cue"))
			print("Loop Type: ")
			ctUtil.print_r(reader.get_loop_type())
			print("Loop Type position: ")
			ctUtil.print_r(reader.get_loop_position("type"))
			print("Loop Start: ")
			ctUtil.print_r(reader.get_loop_start())
			print("Loop Start position: ")
			ctUtil.print_r(reader.get_loop_position("start"))
			print("Loop End:")
			ctUtil.print_r(reader.get_loop_end())
			print("Loop End position: ")
			ctUtil.print_r(reader.get_loop_position("end"))
			print("Loop Fraction:")
			ctUtil.print_r(reader.get_loop_fraction())
			print("Loop Fraction position: ")
			ctUtil.print_r(reader.get_loop_position("fraction"))
			print("Loop Times:")
			ctUtil.print_r(reader.get_loop_times())
			print("Loop Times position: ")
			ctUtil.print_r(reader.get_loop_position("times"))
			end
		end
	end
	return true
end 

--- Helper that returns 1.05946.
-- @treturn float simply returns 1.05946.
function CtAudio.semitone_interval()
	return 1.05946
end

-- return the CtAudio object.
return CtAudio