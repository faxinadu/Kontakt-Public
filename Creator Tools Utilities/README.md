# Creator-Tools-Utilities

These file includes useful functions for usage in Creator Tools Lua scripts.

This is an experimental work in progress and community input is more than welcome. Feel free to contribute code or ask for changes, fixes and new functions.

Simply include this line in any script (if running a script from another location that users this file,
make sure to point to the correct path):
local ctZones = require("CtZones")

Then you can simply call any function like:
ctZones.testFunction()

It is also possible of course to copy entire specific functions from this list directly into your script. 
In that case remove the ctZones part from the function name, and then simply call it normally like:
testFunction

