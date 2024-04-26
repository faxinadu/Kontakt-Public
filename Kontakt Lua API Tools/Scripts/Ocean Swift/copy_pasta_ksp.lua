--[[
Copy Pasta KSP
Author: Ocean Swift
Written by: Yaron Eshkar
Modified: April 6, 2024
--]]

local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")

local output_text = ""
local output_file = Kontakt.script_path .. Filesystem.preferred("/ksp_code.txt")

for i=1,54 do 
   local current_text = 'on ui_control($main_engine_cells_cell_1_body_core_sampler_select_types_menus_' .. i .. ')' .. '\n'
   current_text = current_text .. '$touched := 0' .. '\n'
   current_text = current_text .. '!cell_path[$touched] := @samples_folder & !sample_type_names[' .. i-1 .. '] & "/" & !sampleset_' .. i .. '[get_control_par(%sampleset_' .. i .. '_menus[$touched],$CONTROL_PAR_VALUE)] & ".wav"' .. '\n'
   current_text = current_text .. 'call set_sample_drop' .. '\n'
   current_text = current_text ..  'end on' .. '\n' .. '\n'
   output_text = output_text .. current_text
end

print(output_text)

kFile.write_file(output_file,output_text)

--[[
on ui_control($main_engine_cells_cell_1_body_core_sampler_select_types_menus_9)
   $touched := 0
   !cell_path[$touched] := @samples_folder & !sample_type_names[8] & "/" & !sampleset_9[get_control_par(%sampleset_9_menus[$touched],$CONTROL_PAR_VALUE)] & ".wav"
   call set_sample_drop   
end on
--]]
