--[[ 
Environment Variables
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Script

local total_lines

print("try flac in environment path")

f = assert (io.popen ("flac"))

total_lines = 0

for line in f:lines() do
  total_lines = total_lines + 1
end
  
f:close()

if total_lines == 0 then print ("flac in path not found, lines: " .. total_lines) else print ("flac path found, lines: " ..  total_lines) end

print("try flac with absolute path")

total_lines = 0

f = assert (io.popen ("/opt/homebrew/bin/flac"))
  
for line in f:lines() do
  total_lines = total_lines +1
end
  
f:close()

if total_lines == 0 then print ("flac in path not found, lines: " .. total_lines) else print ("flac path found, lines: " ..  total_lines) end