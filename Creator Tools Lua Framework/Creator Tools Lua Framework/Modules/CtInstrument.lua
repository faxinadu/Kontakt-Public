----------------------------------------------------------------------------------------------------
-- Creator Tools LUA Instrument Utilities File 
----------------------------------------------------------------------------------------------------
-- Author: Native Instruments
-- Written by: Yaron Eshkar
-- Modified: April 23, 2021
--
-- This file includes useful functions for usage in Creator Tools Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local ctInstrument = require("CtInstrument")
-- Then you can simply call any function like:
-- ctInstrument.test_function()
--
-- It is also possible of course to copy entire specific functions from this list directly into your script. 
-- In that case remove the CtFile part from the function name, and then simply call it normally like:
-- test_function()
--

local CtInstrument = {}

--- Test Function.
-- Takes no arguments, prints to console when called.
function CtInstrument.test_function()
	-- Show that the class import and test function executes by printing a line.
	print("Test function called")
end

--- Applies a KSP Script.
-- Takes no arguments, prints to console when called.
-- @tparam string script_or_file KSP script in string form or a path to the script file. If link param is true, must be a path.
-- @tparam string name set the script name.
-- @tparam int slot set the script slot, defaults to zero if not set.
-- @tparam bool bypass when true the script will be applied but set to bypass.
-- @tparam bool link link to the given path or to apply the script as a string.
-- @treturn bool
function CtInstrument.apply_script(script_or_file,name,slot,bypass,link)
	if slot == nil then slot = 0 end
	if name == nil then name = "edited" end

	if link then 
		instrument.scripts[slot].linked  = true
		instrument.scripts[slot].linkedFileName  = filesystem.stem(script_or_file)
	else
		instrument.scripts[slot].sourceCode = script_or_file
	end
	
	instrument.scripts[slot].name = name

	if bypass then instrument.scripts[slot].bypass = true end

	return true
end

-- return the CtFile object.
return CtInstrument