local root_path = Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path))
package.path = root_path .. "/?.lua;" .. package.path

local kAudio = require("Modules.KAudio")
local kUtil = require("Modules.KUtil")
local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local current_path = kUser.framework_samples_path

local expected_width = 500
local expected_height = 500

local png_table = {}

png_table = kUtil.paths_to_table(current_path,".png")
table.sort(png_table)

local error_count = 0

for k,v in pairs(png_table) do
    local width, height = kUtil.get_image_width_height(v)
    if width ~= expected_width then 
        print("file: " .. v .. " width: " .. width .. " ,expected: " .. expected_width) 
        error_count = error_count + 1
    end
    if height ~= expected_height then 
        print("file: " .. v .. " height: " .. width .. " ,expected: " .. expected_height) 
        error_count = error_count + 1
    end
end

print("Total errors found: " .. error_count)