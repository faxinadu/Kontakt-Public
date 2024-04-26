--[[
Copy Pasta KSP 2 
Author: Ocean Swift
Written by: Yaron Eshkar
Modified: April 7, 2024
--]]

local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")

local output_text = ""
local output_file = Kontakt.script_path .. Filesystem.preferred("/ksp_code.txt")

for i=1,58 do 
   local current_text = 'case ' .. i-1 .. '\n'
   current_text = current_text .. 'if( ( ($preset_tick = -1) and (get_control_par(%sampleset_' .. i .. '_menus[$touched],$CONTROL_PAR_VALUE) # 0) ) or ( ($preset_tick = 1) and (get_control_par(%sampleset_' .. i .. '_menus[$touched],$CONTROL_PAR_VALUE) # %num_samples_set_all[get_control_par(%sampler_types[$touched],$CONTROL_PAR_VALUE)] - 1 ) ) )' .. '\n'
   current_text = current_text .. 'set_control_par(%sampleset_' .. i .. '_menus[$touched],$CONTROL_PAR_VALUE,get_control_par(%sampleset_' .. i .. '_menus[$touched],$CONTROL_PAR_VALUE) + $preset_tick)' .. '\n'
   current_text = current_text .. '!cell_path[$touched] := @samples_folder & !sampleset_names[' .. i-1 .. '] & "/" & !sampleset_' .. i .. '[get_control_par(%sampleset_' .. i .. '_menus[$touched],$CONTROL_PAR_VALUE)] & ".wav"' .. '\n'
   current_text = current_text .. 'end if' .. '\n'
   output_text = output_text .. current_text
end

print(output_text)

kFile.write_file(output_file,output_text)

--[[
      case 0
         if( ( ($preset_tick = -1) and (get_control_par(%sampleset_1_menus[$touched],$CONTROL_PAR_VALUE) # 0) ) or ( ($preset_tick = 1) and (get_control_par(%sampleset_1_menus[$touched],$CONTROL_PAR_VALUE) # %num_samples_set_all[$touched] - 1 ) ) )
         set_control_par(%sampleset_1_menus[$touched],$CONTROL_PAR_VALUE,get_control_par(%sampleset_1_menus[$touched],$CONTROL_PAR_VALUE) + $preset_tick)
         !cell_path[$touched] := @samples_folder & !sampleset_names[0] & "/" & !sampleset_1[get_control_par(%sampleset_1_menus[$touched],$CONTROL_PAR_VALUE)] & ".wav"
         end if
--]]
