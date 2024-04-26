
--[[
Iterate Copy Paste Find Replace
Author: Faxi Nadu / Ocean Swift
Written by: Yaron Eshkar
Modified: April 14, 2024
--]]

local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")

local path = Filesystem.preferred(Kontakt.script_path .. "/convert")

local dash_sep = "-------------------------------------------------"

local input_file = Filesystem.preferred(Kontakt.script_path .. "/ksp/source.txt")
local output_file = Filesystem.preferred(Kontakt.script_path .. "/ksp/output.txt")

local find_string_1 = "cell_1"
local find_string_2 = "$touched := 0"

local start_iteration = 2
local num_iterations = 15

local file 

file = io.open(input_file, 'r')
local file_content = {}
local s
for i=start_iteration,num_iterations do 
    local replace_string_1 = "cell_" .. i
    local replace_string_2 = "$touched := " .. i-1
    for line in file:lines() do
        if string.find(line,find_string_1) then
            s = string.gsub(line,find_string_1,replace_string_1)
        else
            s = line
        end
    table.insert(file_content,s)
    end
end
io.close(file)

file = io.open(output_file, 'w')
for index, value in ipairs(file_content) do
   file:write(value..'\n')
end
io.close(file)