local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.player_content_path

print("Searching for all NKI files in: " .. path)
print("Working... this make take some time")
print("--------------------------------------------------")

local paths_table = kUtil.paths_to_table(path,".nki")

print("Found: " .. #paths_table .. " NKI files")
print("--------------------------------------------------")
Kontakt.reset_multi(0)
local random_path = paths_table[math.random(#paths_table)]
local info = Kontakt.get_file_info(random_path)
print("Loading random NKI " .. info["file"] .. " from the library " .. info["library"] .. " , saved with " .. info["version"])
Kontakt.load_instrument(random_path)


