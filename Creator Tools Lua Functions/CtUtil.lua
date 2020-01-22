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

function CtUtil.stringSplit(inputString,sep)

	for s in string.gmatch(inputString, "[^"..sep.."]+") do
    	return s
	end

end

function CtUtil.tableSize(t)

  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count

end

-- return the CtUtil object
return CtUtil
