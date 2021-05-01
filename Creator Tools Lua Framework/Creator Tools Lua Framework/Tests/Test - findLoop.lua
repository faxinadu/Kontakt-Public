--[[ 
Find Loop
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Script

-- Set the directory path with the samples. Print the directory of the loaded script to reveal where the samples are 
-- located.
local root_path = filesystem.parentPath(scriptPath)
local path = root_path .. filesystem.preferred("/Samples/")
print("The samples are located in " .. path)

-- Declare an empty table which we will fill with the samples.
local samples = {}

-- Fill the table with the sample files from the directory, it is also possible to scan all the sub-directories 
-- recursively as we are doing here.
local i = 1
for _,p in filesystem.directoryRecursive(path) do
    -- We only want the sample files to be added to our table and not the directories, we can do this by checking 
    -- if the item is a file or not.
    if filesystem.isRegularFile(p) then
      -- Then we add only audio files to our table.
      if filesystem.extension(p) == '.wav' or filesystem.extension(p) == '.aif' or filesystem.extension(p) == '.aiff' or filesystem.extension(p) == '.ncw' then
        samples[i] = p
        i = i+1
      end
    end
end

-- Create zones and place one file in each of the created groups.
for index, file in next, samples do
    local loop_start,loop_end = mir.findLoop(file)
    print(file .. " loop start: " .. loop_start )
    print(file .. " loop end: " .. loop_end )
end