----------------------------------------------------------------------------------------------------
-- Tutorial 08: KSP - Kontakt Script Processor
----------------------------------------------------------------------------------------------------
--[[ 
The Lua API allows to set and get KSP scripts, as well as manipulating the names and states of the five script slots.
--]]

-- Reset Kontakt rack.
Kontakt.reset_multi()

-- Add an instrument.
instrument = Kontakt.add_instrument()

-- Name the first script slot.
Kontakt.set_instrument_script_name(instrument,0,"My Script")

-- Write a KSP script example that creates a slider.
local my_ksp_script = [[
    on init
        make_perfview
        declare ui_slider $slider (0,1000000)
    end on
]]

-- Set the example script into the first Kontakt KSP slot.
Kontakt.set_instrument_script_source(instrument,0,my_ksp_script)

-- KSP scripts can be loaded from a file.
-- Let's save the previously created KSP code into a text file.
local my_ksp_script_file = Kontakt.script_path .. Filesystem.preferred("/my_ksp_script.txt")
local file = io.open(my_ksp_script_file,"w")
file:write(my_ksp_script)
io.close(file)

-- Load the content of the saved text file into a string variable.
local f = assert(io.open(my_ksp_script_file, "r"))
local file_content = f:read("*all")
f:close()

-- Name the second script slot.
Kontakt.set_instrument_script_name(instrument,1,"My Script 2")
-- Script slots can be bypassed. 
Kontakt.set_instrument_script_bypassed(instrument,1,true)
-- Now let's set the script for the second slot using the content of the loaded file.
Kontakt.set_instrument_script_source(instrument,1,file_content)

-- Remove the KSP script file from disk.
Filesystem.remove(my_ksp_script_file)

-- The used set functions above have corresponding get functions. See manual for more information.
-- Additionally there are three commands that check script states.
print("Is the first script bypassed? " .. tostring(Kontakt.is_instrument_script_bypassed(instrument,0)))
print("Is the first script linked? " .. tostring(Kontakt.is_instrument_script_linked(instrument,0)))
print("Is the first script protected? " .. tostring(Kontakt.is_instrument_script_protected(instrument,0)))