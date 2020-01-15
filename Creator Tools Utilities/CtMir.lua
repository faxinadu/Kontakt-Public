----------------------------------------------------------------------------------------------------
-- Creator Tools LUA Utilities File 
----------------------------------------------------------------------------------------------------

--[[

	This file includes useful functions for usage in Creator Tools Lua scripts.

	Simply include this line in any script (if running a script from another location that users this file,
	make sure to point to the correct path):
	local ctMir = require("CtMir")

	Then you can simply call any function like:
	ctMir.testFunction()
	
	It is also possible of course to copy entire specific functions from this list directly into your script. 
	In that case remove the CtMir part from the function name, and then simply call it normally like:
	testFunction

--]]

-- Import the CtUtil Lua file used by functions in CtMir
local ctUtil = require("CtUtil")

-- Declare the CtMir class
local CtMir = {}

 -- Test function
function CtMir.testFunction()

	-- Show that the class import and test function executes by printing a line
	print("Test function called")

end

-- Perform any of the MIR operations. 
function CtMir.mirDetect(path,mirType,batch,frameSizeInSeconds,hopSizeInSeconds)

	-- Error handling: If arguments aren't provided, declare defaults
	if mirType == nil then mirType = 'sample' end
	if batch == nil then batch = false end
	if mirType == 'rms' or mirType == 'loudness' then
		if frameSizeInSeconds == nil then frameSizeInSeconds = 0.4 end
		if hopSizeInSeconds == nil then hopSizeInSeconds = 0.1 end
	end

	-- Check that the path exists
	CtMir.pathCheck(path)

	-- Check that the path meets the assigned function requirements
	if filesystem.isRegularFile(path) then
		if batch == true then
			print('Error: single file selected for batch processing')
		end
	else
		if batch == false then
			print('Error: folder selected for single file processing')
		end
	end

	-- Perform the chosen MIR operation
	local mirOperation
	if batch then
		if mirType == 'sample' then
			mirOperation = mir.detectSampleTypeBatch(path)
		elseif mirType == 'drum' then
			mirOperation = mir.detectDrumTypeBatch(path)
		elseif mirType == 'instrument' then
			mirOperation = mir.detectInstrumentTypeBatch(path)
		elseif mirType == 'pitch' then
			mirOperation = mir.detectPitchBatch(path)
		elseif mirType == 'peak' then
			mirOperation = mir.detectPeakBatch(path)
		elseif mirType == 'rms' then
			mirOperation = mir.detectRMSBatch(path, frameSizeInSeconds, hopSizeInSeconds)
		elseif mirType == 'loudness' then
			mirOperation = mir.detectLoudnessBatch(path, frameSizeInSeconds, hopSizeInSeconds)
		end
	else
		if mirType == 'sample' then
			mirOperation = mir.detectSampleType(path)
		elseif mirType == 'drum' then
			mirOperation = mir.detectDrumType(path)
		elseif mirType == 'instrument' then
			mirOperation = mir.detectInstrumentType(path)
		elseif mirType == 'pitch' then
			mirOperation = mir.detectPitch(path)
		elseif mirType == 'peak' then
			mirOperation = mir.detectPeak(path)
		elseif mirType == 'rms' then
			mirOperation = mir.detectRMS(path, frameSizeInSeconds, hopSizeInSeconds)
		elseif mirType == 'loudness' then
			mirOperation = mir.detectLoudness(path, frameSizeInSeconds, hopSizeInSeconds)
		end
	end

	-- Return the operation result. Batch returns a table, single returns a variable
	return mirOperation
end

-- Run MIR detection on a folder or single file and print the results
function CtMir.mirTest(performBatch,performSingle,mirPathBatch,mirPathSingle)

	-- Only perform the tests if the flags are true
	if performBatch or performSingle then

		print('\n')
		print('----------------------------------- MIR IMPLEMENTATION TEST -----------------------------------  \n')

		-- Set the frame and hop variables for the RMS and loudness detection. 
		frameSizeInSeconds =  0.4
		hopSizeInSeconds = 0.1

		-- Perform the batch test if the flag is true
		if performBatch then

			--Error handling: let the user know if the folder path is valid
			mirPathBatch = ctUtil.pathCheck(mirPathBatch)

			print('-----------------------------------------------------------------------------------------------')
			print('----------------------------------- BATCH TEST ------------------------------------------------')
			print('-----------------------------------------------------------------------------------------------  \n')

			print('----------------------------------- Type Detection -------------------------------------------- \n')

			-- Perform type detections
			mirBatchSampleType = mir.detectSampleTypeBatch(mirPathBatch)
			mirBatchSampleDrum = mir.detectDrumTypeBatch(mirPathBatch)
			mirBatchSampleInstrument = mir.detectInstrumentTypeBatch(mirPathBatch)

			-- Print type results
			print('----------------------------------- Detect Sample Type Batch')
			ctUtil.print_r(CtMir.type_to_tag(mirBatchSampleType,'type'))
			print('----------------------------------- Detect Sample Type Drum')
			ctUtil.print_r(CtMir.type_to_tag(mirBatchSampleDrum,'drum'))
			print('----------------------------------- Detect Sample Type Instrument')
			ctUtil.print_r(CtMir.type_to_tag(mirBatchSampleInstrument,'instrument'))

			print('----------------------------------- Sample Information Detection ------------------------------ \n')

			-- Perform information detection
			mirBatchPitch = mir.detectPitchBatch(mirPathBatch)
			mirBatchPeak = mir.detectPeakBatch(mirPathBatch)
			mirBatchRMS = mir.detectRMSBatch(mirPathBatch, frameSizeInSeconds, hopSizeInSeconds)
			mirBatchLoudness = mir.detectLoudnessBatch(mirPathBatch, frameSizeInSeconds, hopSizeInSeconds)

			-- Print information results
			print('----------------------------------- Detect Pitch Batch')
			ctUtil.print_r(mirBatchPitch)
			print('----------------------------------- Detect Peak Batch')
			ctUtil.print_r(mirBatchPeak)
			print('----------------------------------- Detect RMS Batch')
			ctUtil.print_r(mirBatchRMS)
			print('----------------------------------- Detect Loudness Batch')
			ctUtil.print_r(mirBatchLoudness)
		end

		-- Perform the single test if the flag is true
		if performSingle then

			--Error handling: let the user know if the sample path is valid
			mirPathSingle = ctUtil.pathCheck(mirPathSingle)

			print('-----------------------------------------------------------------------------------------------')
			print('----------------------------------- SINGLE TEST -----------------------------------------------')
			print('----------------------------------------------------------------------------------------------- \n')

			print('----------------------------------- Type Detection -------------------------------------------- \n')

			-- Perform type detections
			mirSingleSampleType = mir.detectSampleType(mirPathSingle)
			mirSingleSampleDrum = mir.detectDrumType(mirPathSingle)
			mirSingleInstrument = mir.detectInstrumentType(mirPathSingle)

			-- Print type results
			print('----------------------------------- Detect Sample Type Single')
			print(CtMir.type_to_tag(mirSingleSampleType,'type',mirPathSingle))
			print('\n')
			print('----------------------------------- Detect Sample Type Single Drum')
			print(CtMir.type_to_tag(mirSingleSampleDrum,'drum',mirPathSingle))
			print('\n')
			print('----------------------------------- Detect Sample Type Single Instrument')
			print(CtMir.type_to_tag(mirSingleSampleDrum,'instrument',mirPathSingle))
			print('\n')
			print('----------------------------------- Sample Information Detection ------------------------------ \n')

			-- Perform information detection
			mirSinglePitch = mir.detectPitch(mirPathSingle)
			mirSinglePeak = mir.detectPeak(mirPathSingle)
			mirSingleRMS = mir.detectRMS(mirPathSingle, frameSizeInSeconds, hopSizeInSeconds)
			mirSingleLoudness = mir.detectLoudness(mirPathSingle, frameSizeInSeconds, hopSizeInSeconds)

			-- Print information results
			print('----------------------------------- Detect Pitch Single')
			print(mirPathSingle..": "..mirSinglePitch)
			print('\n')
			print('----------------------------------- Detect Peak Single')
			print(mirPathSingle..": "..mirSinglePeak)
			print('\n')
			print('----------------------------------- Detect RMS Single')
			print(mirPathSingle..": "..mirSingleRMS)
			print('\n')
			print('----------------------------------- Detect Loudness Single')
			print(mirPathSingle..": "..mirSingleLoudness)
			print('\n')
		end

		print('-----------------------------------------------------------------------------------------------')
		print('----------------------------------- TEST COMPLETE ---------------------------------------------')
		print('----------------------------------------------------------------------------------------------- \n')
	else
		print('No tests selected')
	end
end

-- Function for converting MIR type tags to strings
function CtMir.type_tags(v,mode)

	-- Error handling: If mode isn't provided default to 'type'
	if mode == nil then mode = 'type' end

	-- if we are looking for the sample type
	if mode == 'type' then
		if v == SampleType.INVALID then
			v = 'Invalid'
		elseif v == SampleType.INSTRUMENT then
			v = 'Instrument'
		elseif v == SampleType.DRUM then
			v = 'Drum'
		end

	-- if we are looking for the drum type
	elseif mode == 'drum' then			
		if v == DrumType.INVALID then
			v = 'Invalid'
		elseif v == DrumType.KICK then
			v = 'Kick'
		elseif v == DrumType.SNARE then
			v = 'Snare'
		elseif v == DrumType.CLOSED_HH then
			v = 'Closed Hat'	
		elseif v == DrumType.OPEN_HH then
			v = 'Open Hat'	
		elseif v == DrumType.TOM then
			v = 'Tom'	
		elseif v == DrumType.CYMBAL then
			v = 'Cymbal'	
		elseif v == DrumType.CLAP then
			v = 'Clap'	
		elseif v == DrumType.SHAKER then
			v = 'Shaker'	
		elseif v == DrumType.PERC_DRUM then
			v = 'Perc Drum'	
		elseif v == DrumType.PERC_OTHER then
			v = 'Perc Other'	
		end

	-- if we are looking for the instrument type
	elseif mode == 'instrument' then
		if v == InstrumentType.INVALID then
			v = 'Invalid'
		elseif v == InstrumentType.BASS then
			v = 'Bass'
		elseif v == InstrumentType.BOWED_STRING then
			v = 'Bowed String'
		elseif v == InstrumentType.BRASS then
			v = 'Brass'	
		elseif v == InstrumentType.FLUTE then
			v = 'Flute'	
		elseif v == InstrumentType.GUITAR then
			v = 'Guitar'	
		elseif v == InstrumentType.KEYBOARD then
			v = 'Keyboard'	
		elseif v == InstrumentType.MALLET then
			v = 'Mallet'	
		elseif v == InstrumentType.ORGAN then
			v = 'Organ'	
		elseif v == InstrumentType.PLUCKED_STRING then
			v = 'Plucked String'	
		elseif v == InstrumentType.REED then
			v = 'Reed'	
		elseif v == InstrumentType.SYNTH then
			v = 'Synth'	
		elseif v == InstrumentType.VOCAL then
			v = 'Vocal'	
		end
	end	

	-- Return the tag
	return v

end

-- Function for implementing MIR type tags to strings
function CtMir.type_to_tag(var,mode,mirPathSingle)

	local tagVar
	-- if called with a batch MIR operation, the variable is a table
	if type(var) == 'table' then
		tagVar = {}
		for k,v in pairs(var) do
			tagVar[k] = CtMir.type_tags(v,mode)
		end
	-- if called with a single MIR operation, the variable is a string and the mirPathSingle argument must be present
	else
		tagVar = mirPathSingle..": "..CtMir.type_tags(var,mode)
	end

	-- Return the type
	return tagVar

end 

-- return the CtZones object
return CtMir