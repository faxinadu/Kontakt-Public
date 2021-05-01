--[[ 
Call SoX
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

require("Modules.paths_file")

-- Script

f = assert (io.popen (sox_path))

for line in f:lines() do
  print(line)
end
  
f:close()
