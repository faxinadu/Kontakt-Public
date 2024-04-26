local root_path = Filesystem.parent_path(Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path)))
package.path = root_path .. "/?.lua;" .. package.path

local kOkwt = require("Modules.KOkwt")
local kUtil = require("Modules.KUtil")
local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local current_path = kUser.framework_samples_path_win .. Filesystem.preferred("/convert/")
print (current_path)
local old_frame_size = "256"
local new_frame_size = "2048"
local sample_paths_table = {}

sample_paths_table = kUtil.paths_to_table(current_path,".WAV")
table.sort(sample_paths_table)

for index,file in pairs(sample_paths_table) do
    local output_file = current_path .. Filesystem.stem(file) .. " " .. new_frame_size .. ".wav"
    kOkwt.convert_frame_size(file,output_file,old_frame_size,new_frame_size)
end