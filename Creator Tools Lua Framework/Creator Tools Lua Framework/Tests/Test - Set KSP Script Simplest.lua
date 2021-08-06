--[[ 
Set KSP Script Simplest
Author: Native Instruments
Written by: Yaron Eshkar
Modified: August 6, 2021
--]]

-- Script

local ksp_script_string = [[
on init
declare ui_knob $knob(0,1000000,1)
end on
]]

instrument.scripts[0].sourceCode = ksp_script_string