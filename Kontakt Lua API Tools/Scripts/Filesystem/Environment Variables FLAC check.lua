local root_path = Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path))
package.path = root_path .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output


local total_lines

print("try flac in environment path")

f = assert (io.popen ("flac"))

total_lines = 0

for line in f:lines() do
  total_lines = total_lines + 1
end
  
f:close()

if total_lines == 0 then print ("flac in path not found, lines: " .. total_lines) else print ("flac path found, lines: " ..  total_lines) end

print("try flac with absolute path")

total_lines = 0

f = assert (io.popen ("/opt/homebrew/bin/flac"))
  
for line in f:lines() do
  total_lines = total_lines +1
end
  
f:close()

if total_lines == 0 then print ("flac in path not found, lines: " .. total_lines) else print ("flac path found, lines: " ..  total_lines) end