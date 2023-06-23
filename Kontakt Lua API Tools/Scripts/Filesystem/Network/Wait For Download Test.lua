local root_path = Filesystem.parent_path(Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path)))
package.path = root_path .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local url = "https://faxinadu.net/star/faxi_nadu_-_take_cover_medea_remix_320.mp3" 
local file_location = "/Users/yaron.eshkar/Downloads/faxi_nadu_-_take_cover_medea_remix_320.mp3"

kUtil.open_url(url)

local clock = os.clock
local function sleep(n) -- seconds
    local t0 = clock()
    while clock() - t0 <= n do end
end
sleep(5)
while not Filesystem.exists(file_location) do
    print("Waiting for Download to finish...")
    sleep(2)
end

print("Download finished!")
print("URL: " .. url)
print("Opening file: " .. file_location)
os.execute("open " .. file_location)




