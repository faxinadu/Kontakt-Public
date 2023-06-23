local root_path = Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path))
package.path = root_path .. "/?.lua;" .. package.path

local kAudio = require("Modules.KAudio")
local kUtil = require("Modules.KUtil")
local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local current_path = kUser.framework_samples_path

local png_table = {}

png_table = kUtil.paths_to_table(current_path,".png")
table.sort(png_table)

for k,v in pairs(png_table) do
    local width, height = kUtil.get_image_width_height(v)
    print("file: "..v)
    print("width: "..width)
    print("height: "..height)
end

