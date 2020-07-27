----------------------------------------------------------------------------------------------------
-- Creator Tools LUA Utilities File 
----------------------------------------------------------------------------------------------------

--[[

	This file includes useful functions for usage in Creator Tools Lua scripts.

	Simply include this line in any script (if running a script from another location that users this file,
	make sure to point to the correct path):
	local ctUtil = require("CtUtil")

	Then you can simply call any function like:
	ctUtil.testFunction()
	
	It is also possible of course to copy entire specific functions from this list directly into your script. 
	In that case remove the CtUtil part from the function name, and then simply call it normally like:
	testFunction

--]]


local CtUtil = {}
 
 -- Test function
function CtUtil.testFunction()

	-- Show that the class import and test function executes by printing a line
	print("Test function called")

end

-- Just a separator for printing to the console. Set an optional global printToConsole boolean variable to control printing.
function CtUtil.dashSepPrint()
    local dashSep = "------------------------------------------------------------"
    if printToConsole == nil then printToConsole = true end
    if printToConsole then print(dashSep) end
end

-- More readable debug printing. Set an optional global printToConsole boolean variable to control printing.
function CtUtil.debugPrint(debugMessage)
    if printToConsole == nil then printToConsole = true end
    if printToConsole then print(debugMessage) end
end

-- Function for nicely printing the table results. Set an optional global printToConsole boolean variable to control printing.
function CtUtil.debugPrintR(arr)
    if printToConsole == nil then printToConsole = true end
    if printToConsole then
        local str = ""
        i = 1
        for index,value in pairs(arr) do
    		indentStr = i.."\t"
            str = str..indentStr..index..": "..value.."\n"
            i = i+1
        end
        print(str)
    end
end

-- Check if a Kontakt instruments is connected and print instruments information
function CtUtil.instrumentConnected()

	print('LUA Script path: '..scriptPath)

	if not instrument then
	    print('Error: The following error message informs you that the Creator Tools are not '..
	          'focused on a Kontakt instrument. To solve this, load an instrument in '..
	          'Kontakt and select it from the instrument dropdown menu on top.')
		else
		print('Instrument connected')          
	end

end

-- Check if a file has a valid audio file extension
function CtUtil.isAudioFile(file)
    local extensionList = {
        ".wav",
        ".aif",
        ".aiff",
        ".rex",
        ".rx2",
        ".snd",
        ".ncw"
    }
    local checkFile = false
    if filesystem.isRegularFile(file) then
        for k,v in pairs(extensionList) do
            if filesystem.extension(file) == v then checkFile = true end
        end
    end
    return checkFile
end

-- Check for a valid path and print the result
function CtUtil.pathCheck(path)

	local path = filesystem.preferred(path)	
		if not filesystem.exists(path) then print ('Path not found') end
	return path

end	

-- Function for nicely printing the table results 
function CtUtil.print_r(arr)

    local str = ""
    i = 1
    for index,value in pairs(arr) do
		indentStr = i.."\t"
        str = str..indentStr..index..": "..value.."\n"
        i = i+1
    end
    print(str)

end

-- Round a number to the nearest integer
function CtUtil.round(n)

	return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)

end

-- Scan a directory and load all files into a table, optionally recursive 
function CtUtil.samplesFolder(path,recursive)

	-- Error handling: If arguments aren't provided, declare defaults
	if path == nil then 
		path = scriptPath 
	else
		path = filesystem.preferred(path)	
	end
	if recursive == nil then recursive = true end

	print ("The samples are located in " .. path)

	-- Declare an empty table which we will fill with the samples.
	samples = {}
	i = 1
	if recursive then
		for _,p in filesystem.directoryRecursive(path) do
		    if filesystem.isRegularFile(p) then
		        samples[i] = p
		        i = i+1
		    end
		end
	else
		for _,p in filesystem.directory(path) do
		    if filesystem.isRegularFile(p) then
		        samples[i] = p
		        i = i+1
		    end
		end
	end

	-- Return a table with the samples
	return samples

end

-- Split a string and return the result after the seperator
function CtUtil.stringSplit(inputString,sep)

	for s in string.gmatch(inputString, "[^"..sep.."]+") do
    	return s
	end

end

-- Function for checking how a string starts.
function CtUtil.stringStarts(inputString,startWith)
   
   return string.sub(inputString,1,string.len(startWith))==startWith

end

-- Return the size of a table
function CtUtil.tableSize(t)

  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count

end

-- Check if a  value exists in a table
function CtUtil.tableValueCheck (t, v)

    for index, value in ipairs(t) do
        if value == v then
            return true
        end
    end
    return false

end

-- Return where a value was found in a table
function CtUtil.tableValueIndex (t, v)

    for index, value in ipairs(t) do
        if value == v then
            return index
        end
    end

end

-- return the CtUtil object
return CtUtil
