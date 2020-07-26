--[[ 

Kontakt Mapping Editor - Lua Auto Mapper
Author: Native Instruments
Written by: Yaron Eshkar
Modified: July 26, 2020

    This script will parse information from file names in order to fill a sample mapping.

	Suppose we have a high number of samples that we want to map according to tokens we place in the sample name.
	
	We can let the script know which token corresponds to which mapping parameter and then use that in order to
	map each sample.

	This script is built to be highly generic and re-usable for many scenarios. 
	
    The first section contains user variables that can be set in order to adapt the script. 
    It is possible to use various naming conventions by telling the script where each token located.

    The second section declares a number of helper functions used in the script.

    The third section looks at the file system and prepares tables containing the paths and the tokens.

    The fourth section prepares the mapping itself.

    The example samples for this tutorial use the following naming convention:
    sampleName_root_lowKey_highKey_lowVel_highVel_roundRobin_articulation_signalType
    e.g.:
    broken piano_r60_lk0_hk127_lv0_hv127_rr0_normal_close

    Open Kontakt and double click in the rack area to create an empty instrument and then run the script.

--]]

----------------------------------------------------------------------------------------------------

-- USER VARIABLES - set these to adapt the script to different mapping scenarios and naming conventions.

-- Set the directory path with the samples. 
-- If using samples that are not part of the directory structure where the script is located use a full path e.g.:
-- mac: local path = filesystem.preferred("/Users/john.doe/Projects/Project/Samples/")
-- win: local path = filesystem.preferred("D:/Projects/Project/Samples/")
local path = scriptPath .. filesystem.preferred("/Lua Mapper Example/")

-- Set to true to reset the instrument.
local resetGroups = true

-- Set to true to print script results to console.
local printToConsole = true

-- Set the tokens the samples include and their order. A value of -1 means the token is not used.

-- These tokens determine zone parameters.
local rootLocation = 2
local lowKeyLocation = 3
local highKeyLocation = 4
local lowVelLocation = 5
local highVelLocation = 6

-- These tokens determine group placement and name.
-- Sample name location should basically always be 1 (and exist) or else error handling gets iffy.
local sampleNameLocation = 1 
local signalNameLocation = -1
local articulationLocation = -1
local roundRobinLocation = 7

-- Default values to replace non existing or erroneous tokens.
local defaultRootValue = 48
local defaultLowKeyValue = 0
local defaultHighKeyValue = 127
local defaultLowVelValue = 0
local defaultHighVelValue = 127

-- Confine each zone to defaults, if set to true will override tokens.
-- Confine each zone low and high key to the root note.
local keyConfine = false
-- Congine each zone low and high velocity to the defaults set in defaultLowVelValue and defaultHighVelValue.
local velConfine = false

-- Set to true if the mapped sample's loop should be on.
local setLoop = false

-- Set the token separator logic using a regular expression. By default it is set to the "_" character. 
local tokenSeparator = "([^_]+)"

----------------------------------------------------------------------------------------------------

-- Check if a value exists in a table.
local function tableValueCheck (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

-- Return where a value was found in a table.
local function tableValueIndex (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return index
        end
    end
end

-- Split a string and return the result after the separator.
local function stringSplit(inputString,sep)
	for s in string.gmatch(inputString, "[^"..sep.."]+") do
    	print(s)
    	return s
	end
end

-- Function for nicely printing the table results.
local function print_r(arr)
    local str = ""
    i = 1
    for index,value in pairs(arr) do
		indentStr = i.."\t"
        str = str..indentStr..index..": "..value.."\n"
        i = i+1
    end
    print(str)
end

----------------------------------------------------------------------------------------------------
-- A flag that turns to true if there were any parsing errors.
local errorFlag = false

-- Just a separator for printing to the console.
local dashesSep = "------------------------------------------------------------"

-- Check for valid instrument.
if not instrument and printToConsole then
    print("The following error message informs you that the Creator Tools are not "..
        "focused on a Kontakt instrument. To solve this, load an instrument in "..
        "Kontakt and select it from the instrument dropdown menu on top.")
    return
end

-- Print the paths.
if printToConsole then 
	print(dashesSep) 
    if filesystem.exists(path) then 
        print("The samples are located in " .. path) 
    else
        print ('Path not found... aborting script...') 
        return
    end

	print(dashesSep) 
end

-- Reset the instrument groups.
if resetGroups then
	instrument.groups:reset()
	if printToConsole then 
		print(dashesSep) 
		print("Instrument reset performed")
		print(dashesSep)  
	end
end	

-- Declare an empty table which we will fill with the samples.
local samplesPaths = {}
local samplesTokens = {}

-- Fill the table with the sample files from the directory, it is also possible to scan all the sub-directories 
-- recursively as we are doing here.
local i = 1
for _,p in filesystem.directoryRecursive(path) do
    -- We only want the sample files to be added to our table and not the directories, we can do this by checking 
    -- if the item is a file or not.
    if filesystem.isRegularFile(p) then
      -- Then we add only audio files to our table.
      if filesystem.extension(p) == ".wav" or filesystem.extension(p) == ".aif" or filesystem.extension(p) == ".aiff" then
        -- print the sample path.
        if printToConsole then print("Sample path found: "..p) end
        samplesPaths[i] = p
        i = i+1
      end
    end
end

-- Sort the paths alphabetically
table.sort(samplesPaths)

-- Parse each file and make a tokens list.
for index, file in pairs(samplesPaths) do
    -- Initialize a table for the tokens of each sample
    tempTokens = {}
    -- Get the clean file name (without path and extension) to parse.
    fileName =  filesystem.filename(file):gsub(filesystem.extension(file),"")
    if printToConsole then 
    	print(dashesSep) 
    	print("File to parse: "..fileName) 
    end
	-- Prepare a table with the tokens from each sample. 
	for token in fileName:gmatch(tokenSeparator) do
		table.insert(tempTokens, token)
	end 
	-- Print the token list of each sample.
	if printToConsole then 
		print("Tokens found: ") 
		print_r(tempTokens) 
	end
	-- Insert each sample's token list into the main tokens list.
	table.insert(samplesTokens, tempTokens)
end

if printToConsole then
	print(dashesSep)
	print(dashesSep)
	print("Mapping.....")
	print(dashesSep)
	print(dashesSep)
end

----------------------------------------------------------------------------------------------------

-- Create the mapping.

-- Initialize a table to fill with the group names.
local groupsList = {}

-- Variable for easier indexing.
local x = 1

-- Loop through all the sample paths and map each sample according to the tokens.
for index, file in next,samplesPaths do

    -- Initialize a variable for the current group name.
    local curentGroupName
	
    if printToConsole then print(dashesSep) end

	-- Set the proposed group name based on the tokens.
    -- If there is a sample name token, add that to the proposed name.
    if sampleNameLocation ~= -1 then
        if samplesTokens[index][sampleNameLocation] ~= nil then
            print("Sample name found: "..samplesTokens[index][sampleNameLocation])
            curentGroupName = samplesTokens[index][sampleNameLocation]
        else
            if printToConsole then print("ERROR: Sample name token set but not found") end
            errorFlag = true
        end
    end

    -- If there is a signal name token, add that to the proposed name.
    if signalNameLocation ~= -1 then 
        if samplesTokens[index][signalNameLocation] ~= nil then
            print("Signal name found: "..samplesTokens[index][signalNameLocation])
            curentGroupName = curentGroupName.."_"..samplesTokens[index][signalNameLocation] 
        else
            if printToConsole then print("ERROR: Signal name token set but not found") end
            errorFlag = true
        end
    end

    -- If there is an articulation name token, add that to the proposed name.
    if articulationLocation ~= -1 then 
        if samplesTokens[index][articulationLocation] ~= nil then
            print("Articulation name found: "..samplesTokens[index][articulationLocation])
            curentGroupName = curentGroupName.."_"..samplesTokens[index][articulationLocation] 
        else
            if printToConsole then print("ERROR: Articulation name token set but not found") end
            errorFlag = true
        end  
    end

    -- If there is a round robin name token, add that to the proposed name.
    if roundRobinLocation ~= -1 then 
        if samplesTokens[index][roundRobinLocation] ~= nil then
            print("sample name is: "..samplesTokens[index][sampleNameLocation])
            curentGroupName = curentGroupName.."_"..samplesTokens[index][roundRobinLocation] 
        else
            if printToConsole then print("ERROR: Round robin name token set but not found") end
            errorFlag = true  
        end        
    end
	
    -- Print the proposed group name.
    if printToConsole then print ("Group name: "..curentGroupName) end

    -- Initialize the zone variable.
    local z = Zone()

    -- If a group for this name exists, put the sample in that group. Otherwise create a group for that name.
	if tableValueCheck(groupsList,curentGroupName) == true then
		local tempGroupIndex = tableValueIndex(groupsList,curentGroupName)
	    -- Add a zone for each sample.
    	instrument.groups[tempGroupIndex].zones:add(z)
    	if printToConsole then print("Group exists. Sample put in group #"..tempGroupIndex) end
	else
		-- Initialize a new group.
		local g = Group()
		-- Add the group to the instrument.
		instrument.groups:add(g)
		-- Add a zone for each sample.
		g.zones:add(z)
		-- Name the group.
		g.name = curentGroupName	
		-- Add the name to the list.
		groupsList[x] = curentGroupName	
		if printToConsole then print("Group created: "..groupsList[x]) end
		-- Increment the group list index.
        x = x + 1
	end

    -- Set the zone root key.
    if rootLocation ~= -1 then
        -- Remove non numerical characters from the token.
    	local value = tonumber(samplesTokens[index][rootLocation]:match('%d[%d.,]*'))
    	-- Check that the value is valid and in range.
        if value > -1 and value < 128 then
    		z.rootKey = value
    		if printToConsole then print("Root set: " .. z.rootKey) end
    	else
    		z.rootKey = defaultRootValue
    		if printToConsole then print("ERROR: ROOT OUT OF RANGE , SET TO: " .. z.rootKey) end
    		errorFlag = true
    	end	
    end

    -- Check if key confine is on.
    if keyConfine then
        z.keyRange.low = z.rootKey
        z.keyRange.high = z.rootKey
    else
        -- Set the zone low key.
        if lowKeyLocation ~= -1 then
            -- Remove non numerical characters from the token.
        	local value = tonumber(samplesTokens[index][lowKeyLocation]:match('%d[%d.,]*'))
            -- Check that the value is valid and in range.
        	if value > -1 and value < 128 then
        		z.keyRange.low = value
        		if printToConsole then print("Low key set: " .. z.keyRange.low) end
        	else
        		z.keyRange.low = defaultLowKeyValue
        	    if printToConsole then print("ERROR: LOW KEY OUT OF RANGE , SET TO: " .. z.keyRange.low) end
        		errorFlag = true
        	end			
        end
        -- Set the zone high key.
        if highKeyLocation ~= -1 then
            -- Remove non numerical characters from the token.
        	local value = tonumber(samplesTokens[index][highKeyLocation]:match('%d[%d.,]*'))
            -- Check that the value is valid and in range.
        	if value > -1 and value < 128 then
        		z.keyRange.high = value
        		if printToConsole then print("High key set: " .. z.keyRange.high) end
        	else
          		z.keyRange.high = defaultHighKeyValue
        	    if printToConsole then print("ERROR: HIGH KEY OUT OF RANGE , SET TO: " .. z.keyRange.high) end
        		errorFlag = true
        	end		  		
        end
    end

    -- Check if velocity confine is on.
    if velConfine then
        z.velocityRange.low = defaultLowVelValue
        z.velocityRange.high = defaultHighVelValue
    else
        -- Set the zone low velocity.
        if lowVelLocation ~= -1 then
            -- Remove non numerical characters from the token.
        	local value = tonumber(samplesTokens[index][lowVelLocation]:match('%d[%d.,]*'))
            -- Check that the value is valid and in range.
        	if value > -1 and value < 128 then
        		z.velocityRange.low = value
        		if printToConsole then print("Low velocity set: " .. z.velocityRange.low) end
        	else
           		z.velocityRange.low = defaultLowVelValue
        	    if printToConsole then print("ERROR: LOW VELOCITY OUT OF RANGE , SET TO: " .. z.velocityRange.low) end
        		errorFlag = true
        	end	
        end

        -- Set the zone high  velocity.
        if highVelLocation ~= -1 then
            -- Remove non numerical characters from the token.
        	local value = tonumber(samplesTokens[index][highVelLocation]:match('%d[%d.,]*'))
            -- Check that the value is valid and in range.
    		if value > -1 and value < 128 then
        		z.velocityRange.high = value
        		if printToConsole then print("High velocity set: " .. z.velocityRange.high) end
        	else
        	    z.velocityRange.high = defaultHighVelValue
        	    if printToConsole then print("ERROR: HIGH VELOCITY OUT OF RANGE , SET TO: " .. z.velocityRange.high) end
        		errorFlag = true
        	end		
        end
    end

    -- Turn on the loop for the zone if required.
    if setLoop then
        z.loops:resize(1)
        z.loops[0].mode = 1
    end        

    -- Populate the zone with a sample from our table.
    z.file = file

end

----------------------------------------------------------------------------------------------------

-- Fix wrong group indexing annoyance.
instrument.groups:remove(0)

if printToConsole then
	print (dashesSep)
	print (dashesSep)
	print ("Mapping Complete")
	print (dashesSep)
	print (dashesSep)
end

-- Ready to push.
if printToConsole then 
	if errorFlag == true then
		print("Script complete but with zone parsing errors, see log...")
	else
		print("Script complete, no errors")
	end	
	print("You can now press Push(↑) in order to apply the changes to Kontakt") 
end

