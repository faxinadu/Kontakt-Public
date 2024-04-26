local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local input_file = Kontakt.script_path .. "/jakl_wavetable.txt"

local file_string = kFile.read_file_to_string(input_file)

local file = io.open(input_file, 'r')

local match_string = ",$CONTROL_PAR_LABEL,"

local output_text = ""
local output_file = Kontakt.script_path .. Filesystem.preferred("/label_setters.txt")

local file_content = {}
for line in file:lines() do
    if string.find(line,match_string) then
        print(line)
        output_text = output_text .. line .. "\n"
    end
end

kFile.write_file(output_file,output_text)

print(output_text)
