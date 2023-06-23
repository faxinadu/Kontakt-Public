local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.player_content_path
local versions_table = {}

print("Searching for all NKI and NKM files in: " .. path)
print("Working... this make take some time")
print("--------------------------------------------------")

local i = 1
for _,p in Filesystem.recursive_directory(path) do
    if Filesystem.extension(p) == ".nkm" or Filesystem.extension(p) == ".nki" then 
        local info = Kontakt.get_file_info(p)
        versions_table[i] = info["version"]
        i = i+1
    end
end

table.sort(versions_table)
print("Found: " .. #versions_table .. " NKI and NKM files")
print("Lowest file version is: " .. versions_table[1])
print("Highest file version is: " .. versions_table[#versions_table] .. " (This is the minimum version needed to run all the files in this folder)")
print("--------------------------------------------------")
