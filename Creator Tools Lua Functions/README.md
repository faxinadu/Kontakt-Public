# Creator Tools LUA Utilities

These files include useful functions for usage in Native Instruments Creator Tools Lua scripts.

This is an experimental work in progress and community input is more than welcome. Feel free to contribute code or ask for changes, fixes and new functions.

Simply include this line in any script (if running a script from another location that users this file,
make sure to point to the correct path):
```lua
local ctZones = require("CtZones")
```

Then you can simply call any function like:
```lua
ctZones.testFunction()
```

It is also possible of course to copy entire specific functions from this list directly into your script. 
In that case remove the ctZones part from the function name, and then simply call it normally like:
testFunction


# Functions List

Listed below are all the available functions for easy reference any copy pasting with the arguments into scripts.

```lua

-- GROUPS

 -- Test function
 ctGroups.testFunction()

-- Check and print the total group count of the instrument
ctGroups.groupCount()

-- Create an x number of groups. Optionally choose where to insert and if and how to rename.
ctGroups.groupCreate(number,insertAt,groupName,increment,incrementStart)

-- Copy a group and paste it x times optionally at the end or by insertion as well as optionally rename the 
-- copied groups.
ctGroups.groupCopy(groupToCopy,timesToPaste,insertAt,groupName,increment,incrementStart)

-- Print detailed information about a group or all groups
ctGroups.groupInfo(group)

--Rename groups by searching for a string in the group name and replacing it with a new string
ctGroups.groupNameReplace(replaceThis,replaceWith,startGroup,untilGroup)

-- Search for a group name or optionally a string within the name and return a table with all groups that match
ctGroups.groupNameSearch(searchName,startGroup,untilGroup,contains)

-- Remove groups
ctGroups.groupRemove(startGroup,untilGroup)

-- Rename groups with a group name and an optional incremental count
ctGroups.groupRename(newName,startGroup,untilGroup,increment,incrementStart)

-- Print all the group names
ctGroups.groupNames()

-- Set all group parameters
ctGroups.groupParams(group,volume,tune,pan,name)

-- MIR

-- Test function
ctMir.testFunction()

-- Perform any of the MIR operations. 
ctMir.mirDetect(path,mirType,batch,frameSizeInSeconds,hopSizeInSeconds)

-- Run MIR detection on a folder or single file and print the results
ctMir.mirTest(performBatch,performSingle,mirPathBatch,mirPathSingle)

-- Function for converting MIR type tags to strings
ctMir.type_tags(v,mode)

-- Function for implementing MIR type tags to strings
ctMir.type_to_tag(var,mode,mirPathSingle)

-- UTIL

-- Test function
ctUtil.testFunction()

-- Check if a Kontakt instruments is connected and print instruments information
ctUtil.instrumentConnected()

-- Check for a valid path and print the result
ctUtil.pathCheck(path)

-- Function for nicely printing the table results 
ctUtil.print_r(arr)

-- Round a number to the nearest integer
ctUtil.round(n)

-- Scan a directory and load all files into a table, optionally recursive 
ctUtil.samplesFolder(path,recursive)

-- Split a string into two with a defined separator
ctUtil.stringSplit(inputString,sep)

-- Returns a table size
ctUtil.tableSize(t)

-- ZONES

-- Test function
ctZones.testFunction()

-- Confine a zone so that root key, low key and high key are all the same
ctZones.zoneConfine(zone,value)

-- Check and print the total zone count of a group or the entire instrument
ctZones.zoneCount(group)

-- Print detailed information about a zone, all the zones in a group or all the zones in the instrument
ctZones.zoneInfo(group,zone)

-- Move all zones or a specific zone from one group to another
ctZones.zoneMove(fromGroup,toGroup,zoneNumber)

-- Set all zone parameters
ctZones.zoneParams(group,zone,rootKey,highKey,lowKey,highVel,lowVel,volume,tune,pan)

-- Set the root note of zones with optional arguments
ctZones.zoneRoot(startRoot,startZone,untilZone,startGroup,untilGroup,increment,confine)

--Find and count the number of all zones that have the same rootKey within a group or all groups
ctZones.zonesWithSameKey(rootKey,group)
```