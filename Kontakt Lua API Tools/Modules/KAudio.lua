----------------------------------------------------------------------------------------------------
-- Kontakt LUA Audio Utilities File 
----------------------------------------------------------------------------------------------------
-- This file includes useful functions for usage in Kontakt Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local kAudio = require("KAudio")

local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = root_path .. "/?.lua;" .. package.path

dofile("Modules/KWav.lua")
local kFile = require("Modules.KFile")
local kUtil = require("Modules.KUtil")
local kUser = require("Modules.KUser")

local KAudio = {}

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
function KAudio.check_sample_set_integrity(path,verbose_mode,perform_rms_check,deviance_rms_factor,perform_loudness_check,deviance_loudness_factor,perform_peak_check,deviance_peak_factor,perform_rate_check,expected_sample_rate,perform_depth_check,expected_bit_depth,perform_loop_check,expected_loop,perform_file_size_check,deviance_file_size_factor,perform_file_names_check)

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

	sample_paths_table = kUtil.paths_to_table(path,".wav")
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
			-- pitch = kUtil.round_num(MIR.detect_pitch(file))
			rms = MIR.detect_rms(file)
			peak = MIR.detect_peak(file)
			loudness = MIR.detect_loudness(file)
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

			reader.close_file()

			table.insert(file_size_table, file_size)

			total_file_size = total_file_size + file_size
		end
	end

	if perform_rms_check then 
		kUtil.dash_sep_print(verbose_mode)
		kUtil.debug_print("RMS Table",verbose_mode)
		kUtil.print_r(rms_table,verbose_mode) 
		kUtil.dash_sep_print(verbose_mode)
	end
	if perform_peak_check then
		kUtil.dash_sep_print(verbose_mode)
		kUtil.debug_print("Peak Table",verbose_mode)
		kUtil.print_r(peak_table,verbose_mode) 
		kUtil.dash_sep_print(verbose_mode)
	end
	if perform_loudness_check then
		kUtil.dash_sep_print(verbose_mode)
		kUtil.debug_print("Loudness Table",verbose_mode)
		kUtil.print_r(loudness_table,verbose_mode) 
		kUtil.dash_sep_print(verbose_mode)
	end

	local average_rms
	local average_peak
	local average_loudness
	local average_file_size

	if perform_rms_check then 
		average_rms = total_rms / #sample_paths_table 
		kUtil.dash_sep_print(verbose_mode)
		kUtil.debug_print("Average RMS: "..average_rms,verbose_mode)
		kUtil.dash_sep_print(verbose_mode)
	end
	if perform_peak_check then 
		average_peak = total_peak / #sample_paths_table 
		kUtil.dash_sep_print(verbose_mode)
		kUtil.debug_print("Average Peak: "..average_peak,verbose_mode)
		kUtil.dash_sep_print(verbose_mode)
	end
	if perform_loudness_check then 
		average_loudness = total_loudness / #sample_paths_table 
		kUtil.dash_sep_print(verbose_mode)
		kUtil.debug_print("Average Loudness: "..average_loudness,verbose_mode)
		kUtil.dash_sep_print(verbose_mode)
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
			kUtil.debug_print("RMS deviations detected",verbose_mode)
			for i=1,#rms_check_table do
				print(rms_check_table[i])
			end
			integrity_error = true
			kUtil.dash_sep_print(verbose_mode)
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
			kUtil.debug_print("Peak deviations detected",verbose_mode)
			for i=1,#peak_check_table do
				print(peak_check_table[i])
			end
			integrity_error = true
			kUtil.dash_sep_print(verbose_mode)
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
			kUtil.debug_print("Loudness deviations detected",verbose_mode)
			for i=1,#loudness_check_table do
				print(loudness_check_table[i])
			end
			integrity_error = true
			kUtil.dash_sep_print(verbose_mode)
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
			reader.close_file()
		end
		if #sample_rate_check_table>0 then
			kUtil.debug_print("Sample rate deviations detected",verbose_mode)
			for i=1,#sample_rate_check_table do
				print(sample_rate_check_table[i])
			end
			integrity_error = true
			kUtil.dash_sep_print(verbose_mode)
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
			reader.close_file()
		end
		if #bit_depth_check_table>0 then
			kUtil.debug_print("Bit depth deviations detected",verbose_mode)
			for i=1,#bit_depth_check_table do
				print(bit_depth_check_table[i])
			end
			integrity_error = true
			kUtil.dash_sep_print(verbose_mode)
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
			reader.close_file()
		end
		if #loop_check_table>0 then
			kUtil.debug_print("Loop check deviations detected",verbose_mode)
			for i=1,#loop_check_table do
				print(loop_check_table[i])
			end
			integrity_error = true
			kUtil.dash_sep_print(verbose_mode)
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
			reader.close_file()
		end
		if #file_size_check_table>0 then
			kUtil.debug_print("File size deviations detected",verbose_mode)
			for i=1,#file_size_check_table do
				print(file_size_check_table[i])
			end
			integrity_error = true
			kUtil.dash_sep_print(verbose_mode)
		end
	end

	if perform_file_names_check then
		kFile.check_duplicate_file_names(path,".wav",verbose_mode)
	end

	return not integrity_error
end	

--- Returns loop points if a sample has them or false otherwise.
-- @tparam string input_file the WAV file to read.
function KAudio.get_loop_points(file)
    local reader = wav.create_context(file, "r")
    local original_loop_count = reader.get_loop_count()
    if original_loop_count == 1 then
        loop_start = eader.get_loop_start()
        loop_end = reader.get_loop_end()
        loop_length = loop_end[1] - loop_start[1]
		reader.close_file()
        return loop_start[1], loop_end[1], loop_length
    else
		reader.close_file()
        return false
    end
end

--- Reads and prints detailed information about a WAV file.
-- @tparam string input_file the WAV file to read.
function KAudio.read_audio_file(input_file)
	local dash_sep = "------------------------------------------------"
	local reader = wav.create_context(input_file, "r")
	print("File mode: "..reader.get_mode())
	print("Filename: " .. reader.get_filename())
	print(dash_sep)
	print("Following header chunks found: ")
	kUtil.print_r(reader.get_chunk_list())
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
			if reader.get_loop_count() > 0 then
				print("Loop Cue: ")
				kUtil.print_r(reader.get_loop_cue())
				print("Loop Cue position: ")
				kUtil.print_r(reader.get_loop_position("cue"))
				print("Loop Type: ")
				kUtil.print_r(reader.get_loop_type())
				print("Loop Type position: ")
				kUtil.print_r(reader.get_loop_position("type"))
				print("Loop Start: ")
				kUtil.print_r(reader.get_loop_start())
				print("Loop Start position: ")
				kUtil.print_r(reader.get_loop_position("start"))
				print("Loop End:")
				kUtil.print_r(reader.get_loop_end())
				print("Loop End position: ")
				kUtil.print_r(reader.get_loop_position("end"))
				print("Loop Fraction:")
				kUtil.print_r(reader.get_loop_fraction())
				print("Loop Fraction position: ")
				kUtil.print_r(reader.get_loop_position("fraction"))
				print("Loop Times:")
				kUtil.print_r(reader.get_loop_times())
				print("Loop Times position: ")
				kUtil.print_r(reader.get_loop_position("times"))
			end
		end
	end
	reader.close_file()
end 

--- Helper that returns 1.05946.
-- @treturn float simply returns 1.05946.
function KAudio.semitone_interval()
	return 1.05946
end

-- return the KAudio object.
return KAudio