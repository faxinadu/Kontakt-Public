local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

dofile(root_path .. filesystem.preferred("/Modules/CtWav.lua"))

local ctAudio = require("Modules.CtAudio")
local ctFile = require("Modules.CtFile")
local ctMap = require("Modules.CtMap")
local ctUtil = require("Modules.CtUtil")
local ctInstrument = require("Modules.CtInstrument")

local parameters_table = {}
for line in io.lines(root_path.."/Variables/instrument_parameters.txt") do
      table.insert(parameters_table, line)
end

local path = filesystem.preferred(parameters_table[1])
local verbose_mode = ctUtil.tobool(parameters_table[2])
local perform_mapping = ctUtil.tobool(parameters_table[3])
local reset_groups = tonumber(parameters_table[4])
local playback_mode = parameters_table[5]
local root_detect = ctUtil.tobool(parameters_table[6])
local root_location = tonumber(parameters_table[7])
local low_key_location = tonumber(parameters_table[8])
local high_key_location = tonumber(parameters_table[9])
local low_vel_location = tonumber(parameters_table[10])
local high_vel_location = tonumber(parameters_table[11])
local sample_name_location = tonumber(parameters_table[12])
local signal_name_location = tonumber(parameters_table[13])
local articulation_location = tonumber(parameters_table[14])
local round_robin_location = tonumber(parameters_table[15])
local default_root_value = tonumber(parameters_table[16])
local default_low_key_value = tonumber(parameters_table[17])
local default_high_key_value = tonumber(parameters_table[18])
local default_low_vel_value = tonumber(parameters_table[19])
local default_high_vel_value = tonumber(parameters_table[20])
local key_confine = ctUtil.tobool(parameters_table[21])
local vel_confine = ctUtil.tobool(parameters_table[22])
local token_separator = parameters_table[23]
local fix_tune = ctUtil.tobool(parameters_table[24])
local set_loop = tonumber(parameters_table[25])
local loop_xfade = tonumber(parameters_table[26])
local perform_audio = ctUtil.tobool(parameters_table[27])
local decode_flac = ctUtil.tobool(parameters_table[28])
local perform_filter = ctUtil.tobool(parameters_table[29])
local filter_cut = tonumber(parameters_table[30])
local perform_normalize = ctUtil.tobool(parameters_table[31])
local normalize_db = tonumber(parameters_table[32])
local perform_reverse = ctUtil.tobool(parameters_table[33])
local perform_silence = ctUtil.tobool(parameters_table[34])
local perform_convert_sr = ctUtil.tobool(parameters_table[35])
local out_sample_rate = tonumber(parameters_table[36])
local perform_convert_bd = ctUtil.tobool(parameters_table[37])
local out_bit_depth = tonumber(parameters_table[38])
local encode_ncw = ctUtil.tobool(parameters_table[39])
local encode_flac = ctUtil.tobool(parameters_table[40])
local encode_ogg = ctUtil.tobool(parameters_table[41])
local ksp_script_set = ctUtil.tobool(parameters_table[42])
local ksp_script_path = filesystem.preferred(parameters_table[43])
local ksp_script_linked = ctUtil.tobool(parameters_table[44])
local ksp_script_slot = tonumber(parameters_table[45])
local ksp_script_bypass = ctUtil.tobool(parameters_table[46])
local ksp_script_name = parameters_table[47]
local perform_sample_set_check = ctUtil.tobool(parameters_table[48])
local perform_sample_set_rms_check = ctUtil.tobool(parameters_table[49])
local sample_set_rms_value = tonumber(parameters_table[50])
local perform_sample_set_loudness_check = ctUtil.tobool(parameters_table[51])
local sample_set_loudness_value = tonumber(parameters_table[52])
local perform_sample_set_peak_check = ctUtil.tobool(parameters_table[53])
local sample_set_peak_value = tonumber(parameters_table[54])
local peform_sample_set_sample_rate_check = ctUtil.tobool(parameters_table[55])
local sample_set_sample_rate_value = tonumber(parameters_table[56])
local peform_sample_set_bit_depth_check = ctUtil.tobool(parameters_table[57])
local sample_set_bit_depth_value = tonumber(parameters_table[58])
local peform_sample_set_file_size_check = ctUtil.tobool(parameters_table[59])
local sample_set_file_size_value = tonumber(parameters_table[60])
local perform_sample_set_loop_exists_check = ctUtil.tobool(parameters_table[61])
local sample_set_file_names_check = ctUtil.tobool(parameters_table[62])

if ctFile.get_os() then
	local get_path = "\"".. parameters_table[64] .. "\""
    sox_path = filesystem.preferred(get_path)
	get_path = "\"".. parameters_table[66] .. "\""
    flac_path = filesystem.preferred(get_path)
else
	local get_path = "\"".. parameters_table[63] .. "\""
    sox_path = filesystem.preferred(get_path)
	get_path = "\"".. parameters_table[65] .. "\""
    flac_path = filesystem.preferred(get_path)
end

local free_flag_bool_1 = false
local free_flag_knob_1 = -1
local free_flag_bool_2 = false
local free_flag_knob_2 = 0
local free_flag_bool_3 = false
local free_flag_knob_3 = -1
local free_flag_bool_4 = false
local free_flag_knob_4 = -1

----------------------------------------------------------------------------------------------------

-- A flag that turns to true if there were any parsing errors.
local error_flag = false

-- Just a separator for printing to the console.
local dash_sep = "------------------------------------------------------------"

-- Print the paths.
if verbose_mode then 
	print(dash_sep) 
    if filesystem.exists(path) then 
        print("The samples are located in " .. path) 
    else
        print ("Path ".. path .. " not found, aborting script.") 
        return
    end
	print(dash_sep) 
end

-- Declare an empty table which we will fill with the samples.
local sample_paths_table = {}

-- Fill the table with the paths,
sample_paths_table = ctUtil.paths_to_table(path,".wav")

-- Sort the paths alphabetically,
table.sort(sample_paths_table)

-- Run audio process
if perform_audio then
	assert(ctUtil.command_exists(sox_path),"Can not find SoX command, check path")
	if decode_flac or encode_flac then assert(ctUtil.command_exists(flac_path),"Can not find FLAC command, check path") end
    for index, file in pairs(sample_paths_table) do
    	if decode_flac then ctAudio.decode_flac(file,"same",false,verbose_mode) end
        if perform_filter then ctAudio.run_audio_process(file,"filter","highpass",filter_cut,verbose_mode) end
        if perform_normalize then ctAudio.run_audio_process(file,"normalize",normalize_db,verbose_mode) end
        if perform_reverse then ctAudio.reverse_audio(file,verbose_mode) end
        if perform_silence then ctAudio.run_audio_process(file,"silence",verbose_mode) end
        if perform_convert_sr then ctAudio.run_audio_process(file,"convert_sr",out_sample_rate,verbose_mode) end
        if perform_convert_bd then ctAudio.run_audio_process(file,"convert_bd",out_bit_depth,verbose_mode) end
		if encode_flac then ctAudio.encode_flac(file,"same",false,verbose_mode) end
		if encode_ogg then ctAudio.encode_ogg(file,5,"same",false,verbose_mode) end
    end
end

if perform_sample_set_check then
	local check = ctAudio.check_sample_set_integrity(path,verbose_mode,perform_sample_set_rms_check,sample_set_rms_value,perform_sample_set_loudness_check,sample_set_loudness_value,perform_sample_set_peak_check,sample_set_peak_value,peform_sample_set_sample_rate_check,sample_set_sample_rate_value,peform_sample_set_bit_depth_check,sample_set_bit_depth_value,perform_sample_set_loop_exists_check,true,peform_sample_set_file_size_check,sample_set_file_size_value,sample_set_file_names_check)
	if check then print("Integrity check passed") else print("Integrity check failed") end
end

if perform_mapping then

	-- Check for valid instrument.
	if verbose_mode then ctUtil.instrument_connected() end

	-- Reset the instrument groups.
	if reset_groups == -1 then
		instrument.groups:reset()
		if verbose_mode then 
			print(dash_sep) 
			print("Instrument reset performed")
			print(dash_sep)  
		end
	end	

	-- Declare an array for the tokens.
	local sample_tokens_table = {}

	-- Fill the tokens table,
	sample_tokens_table = ctUtil.tokens_to_table(sample_paths_table,token_separator)

	if verbose_mode then
		print(dash_sep)
		print("Mapping.....")
		print(dash_sep)
	end

	-- Create the mapping
	ctMap.create_mapping(sample_paths_table,sample_tokens_table,playback_mode,sample_name_location,signal_name_location,articulation_location,round_robin_location,root_detect,root_location,key_confine,low_key_location,high_key_location,vel_confine,low_vel_location,high_vel_location,set_loop,loop_xfade,default_root_value,default_low_key_value,default_high_key_value,default_low_vel_value,default_high_vel_value,verbose_mode,fix_tune,reset_groups)

	if verbose_mode then
		print(dash_sep)
		ctMap.mapping_report(error_flag)
		print(dash_sep)
	end
end

if ksp_script_set then
	print("Appling KSP script: "..ksp_script_path)
	local ksp_script_string
	if ksp_script_linked then
		ksp_script_string = ksp_script_path
	else
		ksp_script_string = ctFile.read_file_to_string(ksp_script_path,"r")
	end
	ctInstrument.apply_script(ksp_script_string,"instrument",ksp_script_slot,ksp_script_bypass,ksp_script_linked)
end
