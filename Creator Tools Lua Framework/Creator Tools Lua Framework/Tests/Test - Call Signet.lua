--[[ 
Call Signet
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 5, 2022

https://github.com/SamWindell/Signet
--]]

-- Script

local root_path = filesystem.parentPath(scriptPath)
local signet_path = root_path .. filesystem.preferred("/Files/Signet/signet")
local signet_command = "--help"

local execute_string = string.format([["%s" %s]],signet_path,signet_command)

print("Executing command:")
print(execute_string)
print("------------------")

f = assert (io.popen (execute_string))

for line in f:lines() do
  print(line)
end
  
f:close()