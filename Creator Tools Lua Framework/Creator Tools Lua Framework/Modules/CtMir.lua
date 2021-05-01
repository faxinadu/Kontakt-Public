----------------------------------------------------------------------------------------------------
-- Creator Tools LUA MIR Utilities File 
----------------------------------------------------------------------------------------------------
-- Author: Native Instruments
-- Written by: Yaron Eshkar
-- Modified: April 23, 2021
--
-- This file includes useful functions for usage in Creator Tools Lua scripts.
-- 
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local ctMir = require("CtMir")
--
-- Then you can simply call any function like:
-- ctMir.test_function()
--
-- It is also possible of course to copy entire specific functions from this list directly into your script. 
-- In that case remove the CtMir part from the function name, and then simply call it normally like:
-- test_function()
--

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")

-- Declare the CtMir class
local CtMir = {}

--- Test Function.
-- Takes no arguments, prints to console when called.
function CtMir.test_function()
	-- Show that the class import and test function executes by printing a line
	print("Test function called")
end

--- Perform any of the MIR operations. 
-- @tparam string path the path to the audio files. A directory for batch operation, a file for a single operation.
-- @tparam string mir_type the type of MIR operation to perform. Can be one of:
--
-- sample
--
-- drum
--
-- instrument
--
-- pitch
--
-- peak
--
-- rms
--
-- loudness
-- @tparam bool batch when true performs the operation on a directory, otherwise on a single file.
-- @tparam float frame_size_in_seconds the frame size for RMS and loudness detection. Degfault to 0.4.
-- @tparam float hop_size_in_seconds the hop size for RMS and loudness detection. Defaults to 0.1.
-- @return return the operation result. Batch returns a table, single returns a variable.
function CtMir.mir_detect(path,mir_type,batch,frame_size_in_seconds,hop_size_in_seconds)
	-- Error handling: If arguments aren"t provided, declare defaults
	if mir_type == nil then mir_type = "sample" end
	if batch == nil then batch = false end
	if mir_type == "rms" or mir_type == "loudness" then
		if frame_size_in_seconds == nil then frame_size_in_seconds = 0.4 end
		if hop_size_in_seconds == nil then hop_size_in_seconds = 0.1 end
	end

	-- Check that the path meets the assigned function requirements
	if filesystem.isRegularFile(path) then
		if batch == true then
			print("Error: single file selected for batch processing")
		end
	else
		if batch == false then
			print("Error: folder selected for single file processing")
		end
	end

	-- Perform the chosen MIR operation
	local mir_operation
	if batch then
		if mir_type == "sample" then
			mir_operation = mir.detectSampleTypeBatch(path)
		elseif mir_type == "drum" then
			mir_operation = mir.detectDrumTypeBatch(path)
		elseif mir_type == "instrument" then
			mir_operation = mir.detectInstrumentTypeBatch(path)
		elseif mir_type == "pitch" then
			mir_operation = mir.detectPitchBatch(path)
		elseif mir_type == "peak" then
			mir_operation = mir.detectPeakBatch(path)
		elseif mir_type == "rms" then
			mir_operation = mir.detectRMSBatch(path, frame_size_in_seconds, hop_size_in_seconds)
		elseif mir_type == "loudness" then
			mir_operation = mir.detectLoudnessBatch(path, frame_size_in_seconds, hop_size_in_seconds)
		end
	else
		if mir_type == "sample" then
			mir_operation = mir.detectSampleType(path)
		elseif mir_type == "drum" then
			mir_operation = mir.detectDrumType(path)
		elseif mir_type == "instrument" then
			mir_operation = mir.detectInstrumentType(path)
		elseif mir_type == "pitch" then
			mir_operation = mir.detectPitch(path)
		elseif mir_type == "peak" then
			mir_operation = mir.detectPeak(path)
		elseif mir_type == "rms" then
			mir_operation = mir.detectRMS(path, frame_size_in_seconds, hop_size_in_seconds)
		elseif mir_type == "loudness" then
			mir_operation = mir.detectLoudness(path, frame_size_in_seconds, hop_size_in_seconds)
		end
	end

	-- Return the operation result. Batch returns a table, single returns a variable
	return mir_operation
end

--- Run MIR detection on a folder or single file and print the results.
-- @tparam bool perform_batch when true performs the batch operation.
-- @tparam bool perform_single when true performs the single operation.
-- @tparam string mir_path_batch the directory path containing audio files for batch operation.
-- @tparam string mir_path_single the file path to an audio file for single file operation.
function CtMir.mir_test(perform_batch,perform_single,mir_path_batch,mir_path_single)

	-- Only perform the tests if the flags are true
	if perform_batch or perform_single then

		print("\n")		print("----------------------------------- MIR IMPLEMENTATION TEST -----------------------------------  \n")

		-- Set the frame and hop variables for the RMS and loudness detection. 
		frame_size_in_seconds =  0.4
		hop_size_in_seconds = 0.1

		-- Perform the batch test if the flag is true
		if perform_batch then

			--Error handling: let the user know if the folder path is valid
			mir_path_batch = ctUtil.pathCheck(mir_path_batch)

			print("-----------------------------------------------------------------------------------------------")
			print("----------------------------------- BATCH TEST ------------------------------------------------")
			print("-----------------------------------------------------------------------------------------------  \n")

			print("----------------------------------- Type Detection -------------------------------------------- \n")

			-- Perform type detections
			mir_batch_sample_type = mir.detectSampleTypeBatch(mir_path_batch)
			mir_batch_sample_drum = mir.detectDrumTypeBatch(mir_path_batch)
			mir_batch_sample_instrument = mir.detectInstrumentTypeBatch(mir_path_batch)

			-- Print type results
			print("----------------------------------- Detect Sample Type Batch")
			ctUtil.print_r(CtMir.type_to_tag(mir_batch_sample_type,"type"))
			print("----------------------------------- Detect Sample Type Drum")
			ctUtil.print_r(CtMir.type_to_tag(mir_batch_sample_drum,"drum"))
			print("----------------------------------- Detect Sample Type Instrument")
			ctUtil.print_r(CtMir.type_to_tag(mir_batch_sample_instrument,"instrument"))

			print("----------------------------------- Sample Information Detection ------------------------------ \n")

			-- Perform information detection
			mir_batch_pitch = mir.detectPitchBatch(mir_path_batch)
			mir_batch_peak = mir.detectPeakBatch(mir_path_batch)
			mir_batch_rms = mir.detectRMSBatch(mir_path_batch, frame_size_in_seconds, hop_size_in_seconds)
			mir_batch_loudness = mir.detectLoudnessBatch(mir_path_batch, frame_size_in_seconds, hop_size_in_seconds)

			-- Print information results
			print("----------------------------------- Detect Pitch Batch")
			ctUtil.print_r(mir_batch_pitch)
			print("----------------------------------- Detect Peak Batch")
			ctUtil.print_r(mir_batch_peak)
			print("----------------------------------- Detect RMS Batch")
			ctUtil.print_r(mir_batch_rms)
			print("----------------------------------- Detect Loudness Batch")
			ctUtil.print_r(mir_batch_loudness)
		end

		-- Perform the single test if the flag is true
		if perform_single then

			--Error handling: let the user know if the sample path is valid
			mir_path_single = ctUtil.pathCheck(mir_path_single)

			print("-----------------------------------------------------------------------------------------------")
			print("----------------------------------- SINGLE TEST -----------------------------------------------")
			print("----------------------------------------------------------------------------------------------- \n")

			print("----------------------------------- Type Detection -------------------------------------------- \n")

			-- Perform type detections
			mir_single_sample_type = mir.detectSampleType(mir_path_single)
			mir_Single_sample_drum = mir.detectDrumType(mir_path_single)
			mir_single_instrument = mir.detectInstrumentType(mir_path_single)

			-- Print type results
			print("----------------------------------- Detect Sample Type Single")
			print(CtMir.type_to_tag(mir_single_sample_type,"type",mir_path_single))
			print("\n")
			print("----------------------------------- Detect Sample Type Single Drum")
			print(CtMir.type_to_tag(mir_Single_sample_drum,"drum",mir_path_single))
			print("\n")
			print("----------------------------------- Detect Sample Type Single Instrument")
			print(CtMir.type_to_tag(mir_Single_sample_drum,"instrument",mir_path_single))
			print("\n")
			print("----------------------------------- Sample Information Detection ------------------------------ \n")

			-- Perform information detection
			mir_single_pitch = mir.detectPitch(mir_path_single)
			mir_single_peak = mir.detectPeak(mir_path_single)
			mir_single_rms = mir.detectRMS(mir_path_single, frame_size_in_seconds, hop_size_in_seconds)
			mir_single_loudness = mir.detectLoudness(mir_path_single, frame_size_in_seconds, hop_size_in_seconds)

			-- Print information results
			print("----------------------------------- Detect Pitch Single")
			print(mir_path_single..": "..mir_single_pitch)
			print("\n")
			print("----------------------------------- Detect Peak Single")
			print(mir_path_single..": "..mir_single_peak)
			print("\n")
			print("----------------------------------- Detect RMS Single")
			print(mir_path_single..": "..mir_single_rms)
			print("\n")
			print("----------------------------------- Detect Loudness Single")
			print(mir_path_single..": "..mir_single_loudness)
			print("\n")
		end

		print("-----------------------------------------------------------------------------------------------")
		print("----------------------------------- TEST COMPLETE ---------------------------------------------")
		print("----------------------------------------------------------------------------------------------- \n")
	else
		print("No tests selected")
	end
end

--- Tune all zones.
-- Use MIR to tune all zones to the nearest note.
-- @treturn bool
function CtMir.tune_all_zones()
	count = 0
	for _,g in pairs(instrument.groups) do
		print("Tuning zones in group["..count.."]: " .. g.name)
		for n,z in pairs(g.zones) do      
			local cur_pitch = mir.detectPitch(z.file)
			z.tune = round(cur_pitch)-cur_pitch
			count = count + 1
		end
	end
	return true
end

--- Helper function for converting MIR type tag enums to strings.
-- tparam enum v the enum to be parsed. Depending on the mode, can be one of:
--
--  SampleType.INVALID
--
-- SampleType.INSTRUMENT
--
-- SampleType.DRUM
-- 
-- DrumType.INVALID
--
-- DrumType.KICK
--
-- DrumType.SNARE
--
-- DrumType.CLOSED_HH
--
-- DrumType.OPEN_HH
--
-- DrumType.TOM
--
-- DrumType.CYMBAL
--
-- DrumType.CLAP
--
-- DrumType.SHAKER
--
-- DrumType.PERC_DRUM
--
-- DrumType.PERC_OTHER
--
-- InstrumentType.INVALID
--
-- InstrumentType.BASS
--
-- InstrumentType.BOWED_STRING
--
-- InstrumentType.BRASS
--
-- InstrumentType.FLUTE
--
-- InstrumentType.GUITAR
--
-- InstrumentType.KEYBOARD
--
-- InstrumentType.MALLET
--
-- InstrumentType.ORGAN
--
-- InstrumentType.PLUCKED_STRING
--
-- InstrumentType.REED
--
-- InstrumentType.SYNTH
--
-- InstrumentType.VOCAL
-- @tparam string mode the expected type tag mode. Can be one of:
--
-- type
--
-- drum
--
-- instrument
-- @treturn string returns a string with the parsed tag.
function CtMir.type_tags(v,mode)
	-- Error handling: If mode isn"t provided default to "type"
	if mode == nil then mode = "type" end

	-- if we are looking for the sample type
	if mode == "type" then
		if v == SampleType.INVALID then
			v = "Invalid"
		elseif v == SampleType.INSTRUMENT then
			v = "Instrument"
		elseif v == SampleType.DRUM then
			v = "Drum"
		end

	-- if we are looking for the drum type
	elseif mode == "drum" then			
		if v == DrumType.INVALID then
			v = "Invalid"
		elseif v == DrumType.KICK then
			v = "Kick"
		elseif v == DrumType.SNARE then
			v = "Snare"
		elseif v == DrumType.CLOSED_HH then
			v = "Closed Hat"	
		elseif v == DrumType.OPEN_HH then
			v = "Open Hat"	
		elseif v == DrumType.TOM then
			v = "Tom"	
		elseif v == DrumType.CYMBAL then
			v = "Cymbal"	
		elseif v == DrumType.CLAP then
			v = "Clap"	
		elseif v == DrumType.SHAKER then
			v = "Shaker"	
		elseif v == DrumType.PERC_DRUM then
			v = "Perc Drum"	
		elseif v == DrumType.PERC_OTHER then
			v = "Perc Other"	
		end

	-- if we are looking for the instrument type
	elseif mode == "instrument" then
		if v == InstrumentType.INVALID then
			v = "Invalid"
		elseif v == InstrumentType.BASS then
			v = "Bass"
		elseif v == InstrumentType.BOWED_STRING then
			v = "Bowed String"
		elseif v == InstrumentType.BRASS then
			v = "Brass"	
		elseif v == InstrumentType.FLUTE then
			v = "Flute"	
		elseif v == InstrumentType.GUITAR then
			v = "Guitar"	
		elseif v == InstrumentType.KEYBOARD then
			v = "Keyboard"	
		elseif v == InstrumentType.MALLET then
			v = "Mallet"	
		elseif v == InstrumentType.ORGAN then
			v = "Organ"	
		elseif v == InstrumentType.PLUCKED_STRING then
			v = "Plucked String"	
		elseif v == InstrumentType.REED then
			v = "Reed"	
		elseif v == InstrumentType.SYNTH then
			v = "Synth"	
		elseif v == InstrumentType.VOCAL then
			v = "Vocal"	
		end
	end	

	-- Return the tag
	return v
end

--- Helper function for implementing MIR type tags to strings.
-- @param var table or enum. If called with a single MIR operation, var is a string and the mir_path_single argument must be present.
-- @tparam string mode the mode to pass to the next function. Can be one of:
--
-- type
--
-- drum
--
-- instrument
-- @tparam string mir_path_single if the input type is not a table, path must be provided.
-- @treturn var returns either a string or a table depending on the input type.
function CtMir.type_to_tag(var,mode,mir_path_single)
	local tag_var
	-- if called with a batch MIR operation, the variable is a table
	if type(var) == "table" then
		tag_var = {}
		for k,v in pairs(var) do
			tag_var[k] = CtMir.type_tags(v,mode)
		end
	-- if called with a single MIR operation, the variable is a string and the mir_path_single argument must be present
	else
		tag_var = mir_path_single..": "..CtMir.type_tags(var,mode)
	end

	-- Return the type
	return tag_var
end 

-- return the CtMir object.
return CtMir