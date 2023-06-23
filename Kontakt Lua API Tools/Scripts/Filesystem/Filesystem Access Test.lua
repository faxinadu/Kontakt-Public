local root_path = Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path))
package.path = root_path .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local path_sep = package.config:sub(1,1)
local terminal_command

if path_sep == "\\" then
    terminal_command = "dir"
else
    terminal_command = "ls"
end

f = assert (io.popen(terminal_command))

for line in f:lines() do
  print(line)
end
  
f:close()