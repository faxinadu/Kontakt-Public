--[[ 
Send Midi Example
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctAudio = require("Modules.CtAudio")
local ctUtil = require("Modules.CtUtil")
local ctFile = require("Modules.CtFile")

-- Script

local midi_text = root_path .. filesystem.preferred("/Files/miditext.txt") 
local execute_string = string.format([[sendmidi list]])
local midi_drivers = ctFile.capture_shell_command(execute_string,true)

local midi_drivers_file = root_path .. filesystem.preferred("/Files/drivers.txt")

local selected_midi_driver = 4

local file = io.open(midi_drivers_file,"w")
file:write(midi_drivers)
io.close(file)

local midi_drivers_list = {}
for line in io.lines(midi_drivers_file) do
      table.insert(midi_drivers_list, line)
end

print("Selected driver is: "..midi_drivers_list[selected_midi_driver])

local midi_text_temp = {}
for line in io.lines(midi_text) do
      table.insert(midi_text_temp, line)
end

midi_text_temp[1] = "dev".." "..'"'..midi_drivers_list[selected_midi_driver]..'"'

file = io.open(midi_text,"w")

for k,v in pairs (midi_text_temp) do
	file:write(v,"\n")
end

io.close(file)

execute_string = string.format([[sendmidi "%s"]],midi_text)
a = ctFile.capture_shell_command(execute_string,true)
print(execute_string)
print(a)



