local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local x = os.clock()
local s = 0
for i=1,100000000 do s = s + i end
print(string.format("elapsed time: %.2f\n", os.clock() - x))