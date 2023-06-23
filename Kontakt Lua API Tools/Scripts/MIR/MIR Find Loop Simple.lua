local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.framework_samples_path

print("Searching for all sample files in: " .. path)
print("Working... this make take some time")
print("--------------------------------------------------")

local paths_table = kUtil.paths_to_table(path)

print("Found: " .. #paths_table .. " sample files")
print("--------------------------------------------------")

local random_path = paths_table[math.random(#paths_table)]

print("Random File: " .. random_path)
local start_loop, end_loop = MIR.find_loop(random_path)
print("Start: " .. start_loop)
print("End: " .. end_loop)
