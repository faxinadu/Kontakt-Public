--[[ 
KSP Simple Test
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Script

print(instrument.scripts[0].sourceCode)
instrument.scripts[1].sourceCode = "on init end on"
instrument.scripts[0].name = "Best Script Ever"
instrument.scripts[1].bypass = true
instrument.scripts[1].scriptSource  = ScriptSource.Linked
instrument.scripts[1].linkedFileName  = "Honulullu"