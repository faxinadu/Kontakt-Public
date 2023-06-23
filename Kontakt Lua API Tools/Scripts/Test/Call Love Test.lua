local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local love_path = "open -n -a love '/Users/yaron.eshkar/Faxi/Repositories/Kontakt Lua API Framework/Tools/love'"
os.execute(love_path)

local clock = os.clock
local function sleep(n) -- seconds
    local t0 = clock()
    while clock() - t0 <= n do end
end

local mapping_file = "/Users/yaron.eshkar/Library/Application Support/LOVE/love/mapping_file.txt"

local checker = true
while checker do
    if Filesystem.exists(mapping_file) then checker = false end
    print("Waiting for GUI application to finish...")
    sleep(1)
end

print("GUI Application finished!")

local file_string = kFile.read_file_to_string(mapping_file)

print(file_string)

Filesystem.remove(mapping_file)