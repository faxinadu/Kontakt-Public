--[[ 
Environment Variables 2
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Script

f = assert (io.popen ("printenv"))

for line in f:lines() do
  print(line)
end
  
f:close()