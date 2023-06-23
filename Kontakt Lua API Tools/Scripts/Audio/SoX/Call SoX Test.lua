local root_path = Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path))
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local sox_path = kUser.sox_path

f = assert(io.popen(sox_path))
for line in f:lines() do
  print(line)
end  
f:close()
