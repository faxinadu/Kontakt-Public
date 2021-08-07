----------------------------------------------------------------------------------------------------
-- Creator Tools LUA Mapping Utilities File 
----------------------------------------------------------------------------------------------------
-- Author: Native Instruments
-- Written by: Yaron Eshkar
-- Modified: April 23, 2021
--
-- This file includes useful functions for usage in Creator Tools Lua scripts.
--
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local ctMap = require("CtMap")
--
-- Then you can simply call any function like:
-- ctMap.test_function()
--
-- It is also possible of course to copy entire specific functions from this list directly into your script. 
-- In that case remove the CtMap part from the function name, and then simply call it normally like:
-- test_function()
--

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")

-- Just a separator for printing to the console.
local dash_sep = "------------------------------------------------------------"

local CtMap = {}

--- Test Function.
-- Takes no arguments, prints to console when called.
function CtMap.test_function()
	-- Show that the class import and test function executes by printing a line.
	print("Test function called")
end

--- Creates a sample map for Kontakt.
-- Generic sample map function that takes many argument and applies the resulting map to the Kontakt mapping editor.
-- @tparam table sample_paths_table table containing the paths to the sample files.
-- @tparam table sample_tokens_table table containing the tokens contained in the name of each sample file.
-- @tparam string playback_mode sets the playback mode for the created groups. Can be one of:
--
-- dfd
--
-- sampler
--
-- wavetable
--
-- tone_machine
--
-- time_machine
--
-- time_machine_2
--
-- time_machine_pro
--
-- beat_machine
--
-- s1200
--
-- mp60
-- @tparam int sample_name_location the expected location of the sample name token in the sample_tokens_table.
-- @tparam int signal_name_location the expected location of the signal name token in the sample_tokens_table.
-- @tparam int articulation_location the expected location of the articulation token in the sample_tokens_table.
-- @tparam int round_robin_location the expected location of the round robin token in the sample_tokens_table.
-- @tparam bool root_detect if set to true, root will be detected using MIR. When set to false, root will be set manually by the relvent variables.
-- @tparam int root_location the expected location of the root note token in the sample_tokens_table.
--
-- Set to 0 to use the default value, set to -1 to not set the parameter at all.
-- @tparam bool key_confine when set to true, the zone low key, high key will be the same as the root key.
-- @tparam int low_key_location the expected location of the low key token in the sample_tokens_table. 
--
-- Set to 0 to use the default value, set to -1 to not set the parameter at all.
-- @tparam int high_key_location the expected location of the high key token in the sample_tokens_table. 
--
-- Set to 0 to use the default value, set to -1 to not set the parameter at all.
-- @tparam bool vel_confine if set to true, low vel and high vel will be set to the default parameters.
-- @tparam int low_vel_location the expected location of the low vel token in the sample_tokens_table. 
--
-- Set to 0 to use the default value, set to -1 to not set the parameter at all.
-- @tparam int high_vel_location the expected location of the high vel token in the sample_tokens_table. 
--
-- Set to 0 to use the default value, set to -1 to not set the parameter at all.
-- @tparam int set_loop 
--
-- 0: No loop.
--
-- 1: Turn on the first loop of the sample in mode 1.
--
-- 2: Turn on the first loop of the sample in mode 1 and set the loop parameters by reading the loop points from the file.
--
-- 3: Turn on the first loop of the sample in mode 1 and set the loop parameters by using MIR loop detection.
-- @tparam int loop_xfade anything greater than 0 sets the xfade to the given value.
-- @tparam int default_root_value the default root value to use if explicity told too or if an error is encountered parsing the token.
-- @tparam int default_low_key_value the default low key value to use if explicity told too or if an error is encountered parsing the token.
-- @tparam int default_high_key_value the default high key value to use if explicity told too or if an error is encountered parsing the token.
-- @tparam int default_low_vel_value the default low vel value to use if explicity told too or if an error is encountered parsing the token.
-- @tparam int default_high_vel_value the default high vel value to use if explicity told too or if an error is encountered parsing the token.
-- @tparam bool verbose_mode when true, prints the results of the mapping operation to console.
-- @tparam bool fix_tune When true MIR is used to fine tune each sample to the nearest note.
-- @tparam bool reset_groups If this value is greater than -1, the created groups will be a deep copy of this value's group slot instead of empty groups.
-- @treturn bool
function CtMap.create_mapping(sample_paths_table,sample_tokens_table,playback_mode,sample_name_location,signal_name_location,articulation_location,round_robin_location,root_detect,root_location,key_confine,low_key_location,high_key_location,vel_confine,low_vel_location,high_vel_location,set_loop,loop_xfade,default_root_value,default_low_key_value,default_high_key_value,default_low_vel_value,default_high_vel_value,verbose_mode,fix_tune,reset_groups)
	if verbose_mode == nil then verbose_mode = true end
	if reset_groups == nil then reset_groups = -1 end
	
	-- Set the playback mode.
	if playback_mode == "dfd" then playback_mode = PlaybackMode.DirectFromDisk 
		elseif playback_mode == "sampler" then playback_mode = PlaybackMode.Sampler
		elseif playback_mode == "wavetable" then playback_mode = PlaybackMode.Wavetable
		elseif playback_mode == "tone_machine" then playback_mode = PlaybackMode.ToneMachine
		elseif playback_mode == "time_machine" then playback_mode = PlaybackMode.TimeMachine
		elseif playback_mode == "time_machine_2" then playback_mode = PlaybackMode.TimeMachine2
		elseif playback_mode == "time_machine_pro" then playback_mode = PlaybackMode.TimeMachinePro
		elseif playback_mode == "beat_machine" then playback_mode = PlaybackMode.BeatMachine
		elseif playback_mode == "s1200" then playback_mode = PlaybackMode.S1200Machine
		elseif playback_mode == "mp60" then playback_mode = PlaybackMode.MP60Machine
	end

	if verbose_mode then print("Group mode: "..playback_mode) end

	-- Checks that a proposed zone value is in the right range.
	local function check_zone_value(token_value,token_type)
	    local token_types = {"Root","Low Key","High Key","Low Vel","High Vel"}    
	    local default_values = {default_root_value,default_low_key_value,default_high_key_value,default_low_vel_value,default_high_vel_value}    
	    -- Check that the value is valid and in range.
	    if ctUtil.is_in_range(token_value,0,127) then
	        if verbose_mode then print(token_types[token_type].." set: " .. token_value) end
	    else
	        token_value = default_values[token_type]
	        if verbose_mode then print("ERROR: ".. token_types[token_type] .." OUT OF RANGE , SET TO: " .. token_value) end
	        error_flag = true
	    end	
	    return token_value
	end

	-- Table with note names.
	local note_names = {
	"C-2","C#-2","D-2","D#-2","E-2","F-2","F#-2","G-2","G#-2","A-2","A#-2","B-2",
	"C-1","C#-1","D-1","D#-1","E-1","F-1","F#-1","G-1","G#-1","A-1","A#-1","B-1",
	"C0","C#0","D0","D#0","E0","F0","F#0","G0","G#0","A0","A#0","B0",
	"C1","C#1","D1","D#1","E1","F1","F#1","G1","G#1","A1","A#1","B1",
	"C2","C#2","D2","D#2","E2","F2","F#2","G2","G#2","A2","A#2","B2",
	"C3","C#3","D3","D#3","E3","F3","F#3","G3","G#3","A3","A#3","B3",
	"C4","C#4","D4","D#4","E4","F4","F#4","G4","G#4","A4","A#4","B4",
	"C5","C#5","D5","D#5","E5","F5","F#5","G5","G#5","A5","A#5","B5",
	"C6","C#6","D6","D#6","E6","F6","F#6","G6","G#6","A6","A#6","B6",
	"C7","C#7","D7","D#7","E7","F7","F#7","G7","G#7","A7","A#7","B7",
	"C8","C#8","D8","D#8","E8","F8","F#8","G8","G#8"
	}

	-- Create the mapping.

	-- Initialize a table to fill with the group names.
	local groups_list = {}

	-- Variable for easier indexing.
	local x = 1

	-- Variable for the token values
	local token_value

	-- Loop through all the sample paths and map each sample according to the tokens.
	for index, file in next,sample_paths_table do

	    -- Initialize a variable for the current group name.
	    local curent_group_name
		
	    if verbose_mode then print(dash_sep) end

		-- Set the proposed group name based on the tokens.
	    -- If there is a sample name token, add that to the proposed name.
	    if sample_name_location > 0 then
	        if sample_tokens_table[index][sample_name_location] ~= nil then
	            print("Sample name found: "..sample_tokens_table[index][sample_name_location])
	            curent_group_name = sample_tokens_table[index][sample_name_location]
	        else
	            if verbose_mode then print("ERROR: Sample name token set but not found") end
	            error_flag = true
	        end
	    end

	    -- If there is a signal name token, add that to the proposed name.
	    if signal_name_location > 0 then 
	        if sample_tokens_table[index][signal_name_location] ~= nil then
	            print("Signal name found: "..sample_tokens_table[index][signal_name_location])
	            curent_group_name = curent_group_name.."_"..sample_tokens_table[index][signal_name_location] 
	        else
	            if verbose_mode then print("ERROR: Signal name token set but not found") end
	            error_flag = true
	        end
	    end

	    -- If there is an articulation name token, add that to the proposed name.
	    if articulation_location > 0 then 
	        if sample_tokens_table[index][articulation_location] ~= nil then
	            print("Articulation name found: "..sample_tokens_table[index][articulation_location])
	            curent_group_name = curent_group_name.."_"..sample_tokens_table[index][articulation_location] 
	        else
	            if verbose_mode then print("ERROR: Articulation name token set but not found") end
	            error_flag = true
	        end  
	    end

	    -- If there is a round robin name token, add that to the proposed name.
	    if round_robin_location > 0 then 
	        if sample_tokens_table[index][round_robin_location] ~= nil then
	            print("sample name is: "..sample_tokens_table[index][sample_name_location])
	            curent_group_name = curent_group_name.."_"..sample_tokens_table[index][round_robin_location] 
	        else
	            if verbose_mode then print("ERROR: Round robin name token set but not found") end
	            error_flag = true  
	        end        
	    end

		if curent_group_name == nil then curent_group_name = "Group"..x end
		
	    -- Print the proposed group name.
	    if verbose_mode then print ("Group name: "..curent_group_name) end

	    -- Initialize the zone variable.
	    local z = Zone()

	    -- If a group for this name exists, put the sample in that group. Otherwise create a group for that name.
		if ctUtil.table_value_check(groups_list,curent_group_name) == true then
			local temp_group_index = ctUtil.table_value_index(groups_list,curent_group_name)
		    -- Add a zone for each sample.
	    	instrument.groups[temp_group_index].zones:add(z)
	    	if verbose_mode then print("Group exists. Sample put in group #"..temp_group_index) end
		else
			-- Initialize a new group.
            local g
            -- If told to copy a group, copy that one.
            if reset_groups > -1 then 
                instrument.groups:insert(x,instrument.groups[reset_groups])
				g = instrument.groups[x]
            -- Create a new group.
            else
                g = Group()
                -- Set playback mode
                g.playbackMode = playback_mode
                -- Add the group to the instrument.
                instrument.groups:add(g)
            end

			-- Add a zone for each sample.
			g.zones:add(z)
			-- Name the group.
			g.name = curent_group_name	
			-- Add the name to the list.
			groups_list[x] = curent_group_name	
			if verbose_mode then print("Group created: "..groups_list[x]) end
			-- Increment the group list index.
	        x = x + 1
		end

	    -- Set the zone root key.
	    -- If MIR Detection is on, override token setting and perform MIR pitch detect
	    if root_detect then
	        token_value = ctUtil.round_num(mir.detectPitch(file))
	        if verbose_mode then print("MIR Pitch detected as: " .. token_value) end
	        token_value = check_zone_value(token_value,1)
	        z.rootKey = token_value
	    else
	    	if root_location == 0 then
	    		z.rootKey = default_root_value
	        elseif root_location > 0 then
	        	if sample_tokens_table[index][root_location] then
		            if ctUtil.table_value_index(note_names,sample_tokens_table[index][root_location]) == nil then
		                -- Remove non numerical characters from the token.
		                token_value = tonumber(sample_tokens_table[index][root_location]:match('%d[%d.,]*'))
		            else
		                -- Check for the index value of the note string
		                token_value = tonumber(ctUtil.table_value_index(note_names,sample_tokens_table[index][root_location]))-1
		            end
		        else
		        	token_value = -1
		        end
	            token_value = check_zone_value(token_value,1)
	            z.rootKey = token_value
	        end
	    end

	    -- Check if key confine is on.
	    if key_confine then
	        z.keyRange.low = z.rootKey
	        z.keyRange.high = z.rootKey
	    else
			if low_key_location == 0 then
	    		z.keyRange.low = default_low_key_value
	        -- Set the zone low key.
	        elseif low_key_location > 0 then
				if sample_tokens_table[index][low_key_location] then
		            if ctUtil.table_value_index(note_names,sample_tokens_table[index][low_key_location]) == nil then
		                -- Remove non numerical characters from the token.
		            	token_value = tonumber(sample_tokens_table[index][low_key_location]:match('%d[%d.,]*'))
		            else
		                -- Check for the index value of the note string
		                token_value = tonumber(ctUtil.table_value_index(note_names,sample_tokens_table[index][low_key_location]))-1
		            end
				else
					token_value = -1
				end		          
	            token_value = check_zone_value(token_value,2)		
	            z.keyRange.low = token_value
	        end
	        -- Set the zone high key.
	       	if high_key_location == 0 then
	    		z.keyRange.high = default_high_key_value
	        elseif high_key_location > 0 then
				if sample_tokens_table[index][high_key_location] then
		            if ctUtil.table_value_index(note_names,sample_tokens_table[index][high_key_location]) == nil then
		                -- Remove non numerical characters from the token.
		            	token_value = tonumber(sample_tokens_table[index][high_key_location]:match('%d[%d.,]*'))
		            else
		                -- Check for the index value of the note string
		                token_value = tonumber(ctUtil.table_value_index(note_names,sample_tokens_table[index][high_key_location]))-1
		            end
				else
					token_value = -1
				end		 
	            token_value = check_zone_value(token_value,3)	 
	            z.keyRange.high = token_value 		
	        end
	    end

	    -- Check if velocity confine is on.
	    if vel_confine then
	        z.velocityRange.low = default_low_vel_value
	        z.velocityRange.high = default_high_vel_value
	    else
	    	if low_vel_location == 0 then
	    		z.velocityRange.low = default_low_vel_value
	        elseif low_vel_location > 0 then
				if sample_tokens_table[index][low_vel_location] then
		            -- Remove non numerical characters from the token.
		        	token_value = tonumber(sample_tokens_table[index][low_vel_location]:match('%d[%d.,]*'))
				else
					token_value = -1
				end		 
				token_value = check_zone_value(token_value,4)
				z.velocityRange.low = token_value
	        end

	        -- Set the zone high  velocity.
			if high_vel_location == 0 then
	    		z.velocityRange.high = default_high_vel_value
	        elseif high_vel_location > 0 then
				if sample_tokens_table[index][high_vel_location] then
		            -- Remove non numerical characters from the token.
		        	token_value = tonumber(sample_tokens_table[index][high_vel_location]:match('%d[%d.,]*'))
				else
					token_value = -1
				end		 
				token_value = check_zone_value(token_value,5)
				z.velocityRange.high = token_value
	        end
	    end

	    -- Turn on the loop for the zone if required.
	    if set_loop>0 then
	        z.loops:resize(1)
	        z.loops[0].mode = 1
	        if set_loop>1 then
				local loop_start = {}
				local loop_end = {}
				local loop_length
		        if set_loop==2 then
		            local file_reader = wav.create_context(file, "r")
		            local original_loop_count = file_reader.get_loop_count()
		            if original_loop_count == 1 then
		                loop_start = file_reader.get_loop_start()
		                loop_end = file_reader.get_loop_end()
		                if verbose_mode then print("Loop Start: "..loop_start[1]) end
		                if verbose_mode then print("Loop Length: "..loop_end[1] - loop_start[1]) end
		                z.loops[0].start = loop_start[1]
		                loop_length = loop_end[1] - loop_start[1]
		            else
		                if verbose_mode then print("ERROR: Loop not found, finding best loop") end
						loop_start[1],loop_end[1] = mir.findLoop(file)
		        		loop_length = loop_end[1] - loop_start[1]
						if verbose_mode then print("Loop start: "..loop_start[1].." Loop length: "..loop_length) end
		                error_flag = true  
		            end 
		        elseif set_loop>2 then
					if verbose_mode then print("Finding loop points...") end
			        if set_loop==3 then -- default
			        	loop_start[1],loop_end[1] = mir.findLoop(file)
			        	loop_length = loop_end[1] - loop_start[1]
			        elseif set_loop==4 then  -- settings for type?
			        	loop_start[1],loop_end[1] = mir.findLoop(file)
			        	loop_length = loop_end[1] - loop_start[1]
			        elseif set_loop==5 then -- settings for type?
			        	loop_start[1],loop_end[1] = mir.findLoop(file)
			        	loop_length = loop_end[1] - loop_start[1]
			        end
					if verbose_mode then print("Loop start: "..loop_start[1].." Loop length: "..loop_length) end
			    end
		    	z.loops[0].start = loop_start[1]
				z.loops[0].length = loop_length
				if loop_xfade>0 then z.loops[0].xfade = loop_xfade end
			end
	    end        

	    if fix_tune then
	    	local cur_pitch = mir.detectPitch(file)
    		z.tune = ctUtil.round_num(cur_pitch)-cur_pitch
    	end

    	-- Populate the zone with a sample from our table.
	    z.file = file

	end

	-- Fix wrong group indexing annoyance.
	instrument.groups:remove(0)

	return true
end

--- Simple mapper that maps each sample to its own group.
-- All options except sample_paths table are optional.
-- @tparam table sample_paths_table
-- @tparam int root_key
-- @tparam int low_key
-- @tparam int high_key
-- @tparam int low_vel
-- @tparam int high_vel
-- @tparam bool set_loop
-- @tparam int loop_xfade
-- @tparam bool verbose_mode
-- @treturn bool
function CtMap.simplest_mapper_groups(sample_paths_table,set_loop,loop_xfade,root_key,low_key,high_key,low_vel,high_vel,verbose_mode)
	if set_loop == nil then set_loop = false end
	if loop_xfade == nil then loop_xfade = 20 end
	if root_key == nil then root_key = 60 end
	if low_key == nil then low_key = 0 end
	if high_key == nil then high_key = 127 end
	if low_vel == nil then low_vel = 0 end
	if high_vel == nil then high_vel = 127 end
	if verbose_mode == nil then verbose_mode = true end
	for index, file in pairs(sample_paths_table) do
        instrument.groups:insert(#instrument.groups,instrument.groups[0])
        local g = instrument.groups[#instrument.groups-1]
                -- Name the group.
                g.name = "group ".. index
        local z = Zone()
        g.zones:add(z)
        z.rootKey = root_key
        z.keyRange.low = low_key
        z.keyRange.high = high_key
        z.velocityRange.low = low_vel
        z.velocityRange.high = high_vel
        if set_loop then 
            local loop_start,loop_end = mir.findLoop(file)
            local loop_length = loop_end - loop_start
            z.loops:resize(1)
            z.loops[0].mode = 1
            z.loops[0].start = loop_start
            z.loops[0].length = loop_length
            z.loops[0].xfade = loop_xfade
            if verbose_mode then print("Loop start: "..loop_start.." Loop length: "..loop_length) end
        end
        -- Populate the zone with a sample from our table.
        z.file = file
    end
    -- Fix wrong group indexing annoyance.
	instrument.groups:remove(0)
    if verbose_mode then print("Mapping complete, no errors") end
	return true
end

--- Simple mapper that maps each sample to one key confined zone.
-- All options except sample_paths table are optional.
-- @tparam table sample_paths_table
-- @tparam int root_key
-- @tparam int low_vel
-- @tparam int high_vel
-- @tparam bool set_loop
-- @tparam int loop_xfade
-- @tparam bool verbose_mode
-- @treturn bool
function CtMap.simplest_mapper_zones(sample_paths_table,set_loop,loop_xfade,root_key,low_vel,high_vel,verbose_mode)
	if set_loop == nil then set_loop = false end
	if loop_xfade == nil then loop_xfade = 20 end
	if root_key == nil then root_key = 60 end
	if low_vel == nil then low_vel = 0 end
	if high_vel == nil then high_vel = 127 end
	if verbose_mode == nil then verbose_mode = true end
    for index, file in pairs(sample_paths_table) do
        local g = instrument.groups[#instrument.groups-1]
        local z = Zone()
        g.zones:add(z)
        z.rootKey = root_key
        z.keyRange.low = root_key
        z.keyRange.high = root_key
        z.velocityRange.low = low_vel
        z.velocityRange.high = high_vel
        if set_loop then 
            local loop_start,loop_end = mir.findLoop(file)
            local loop_length = loop_end - loop_start
            z.loops:resize(1)
            z.loops[0].mode = 1
            z.loops[0].start = loop_start
            z.loops[0].length = loop_length
            z.loops[0].xfade = loop_xfade
            if verbose_mode then print("Loop start: "..loop_start.." Loop length: "..loop_length) end
        end
        -- Populate the zone with a sample from our table.
        z.file = file
        root_key = root_key + 1
    end
    if verbose_mode then print("Mapping complete, no errors") end
	return true
end

--- Report map status.
-- Report success or mapping with errors.
-- @tparam bool error_flag determines whether to print a sucess or an error message.
-- @treturn bool
function CtMap.mapping_report(error_flag)
	if error_flag == true then
		print("Mapping complete but with zone parsing errors, see log...")
		return false
	else
		print("Mapping complete, no errors")
		return true
	end
end

-- return the CtMap object.
return CtMap
