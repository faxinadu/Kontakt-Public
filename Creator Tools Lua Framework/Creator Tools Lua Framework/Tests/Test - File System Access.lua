--[[ 
Test File System Access
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 30, 2021
--]]

-- Script

local path_sep = package.config:sub(1,1)
local terminal_command
if path_sep == "\\" then
    terminal_command = "dir"
else
    terminal_command = "ls"
end

f = assert (io.popen(terminal_command))

for line in f:lines() do
  print(line)
end
  
f:close()
