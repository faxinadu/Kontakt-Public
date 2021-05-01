--[[ 
Send MIDI Program Change
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Script

local root_path = filesystem.parentPath(scriptPath)

local send_midi_path = filesystem.preferred("/Users/yaron.eshkar/Faxi/MIDI-Tools/sendmidi-macos-1.0.15/sendmidi")
local midi_text_file = scriptPath .. filesystem.preferred("/Files/miditext.txt") 
local midi_text

local midi_driver_list = "list"
local midi_driver_dev = "dev"
local midi_program_change = "pc"
local midi_channel = "ch"

local midi_time_stamp = "+00.0200"

local midi_driver_selected = 1

local midi_drivers_found = {}

f = assert (io.popen (send_midi_path .. " " .. midi_driver_list))

for line in f:lines() do
  table.insert(midi_drivers_found, line)
end
  
f:close()

print("Selected driver is: "..midi_drivers_found[midi_driver_selected])

local midi_text = midi_driver_dev .. " " .. midi_drivers_found[midi_driver_selected] .. "\n"

midi_text = midi_text .. midi_time_stamp .. "\n"
midi_text = midi_text .. "cc 20 5" .. "\n"

for i=1,16 do
    midi_text = midi_text .. midi_time_stamp .. "\n"
    midi_text = midi_text .. midi_channel .. " " .. i .. "\n"
    for x=0,127 do
        midi_text = midi_text .. midi_time_stamp .. "\n" 
        midi_text = midi_text .. midi_program_change .. " " .. x .. "\n"
    end
end

file = assert (io.open(midi_text_file,"w"))
file:write(midi_text)
io.close(file)

f = assert (io.popen (send_midi_path .. " " .. midi_text_file))
f:close()
