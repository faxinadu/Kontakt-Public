--[[ 
Signet Run Command
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 6, 2022

https://github.com/SamWindell/Signet
--]]

-- Script

local root_path = filesystem.parentPath(scriptPath)
local signet_path = root_path .. filesystem.preferred("/Files/Signet/signet")
local samples_path = root_path .. filesystem.preferred("/Samples/")
local signet_options = "--recursive"
local signet_commands = {
  "print-info",
  "norm -1",
  "remove-silence 0",
  "convert sample-rate 44100",
  "convert bit-depth 16"
}

function run_signet_command(signet_path,signet_options,samples_path,signet_command)
  local execute_string = string.format([["%s" %s "%s" %s]],signet_path,signet_options,samples_path,signet_command)

  print("Executing command:")
  print(execute_string)
  print("------------------")

  f = assert (io.popen (execute_string))

  for line in f:lines() do
    print(line)
  end
    
  f:close()
end

for k,v in pairs(signet_commands) do
  run_signet_command(signet_path,signet_options,samples_path,v)
end

