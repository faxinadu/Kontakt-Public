
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

local dash_sep = "-------------------------------------------------"

local input_file = Filesystem.preferred(Kontakt.script_path .. "/ksp/source.txt")
local output_file = Filesystem.preferred(Kontakt.script_path .. "/ksp/output.txt")

local find_string = "cb_id%["

local file 

print(dash_sep)
print(dash_sep)
print(dash_sep)
print(dash_sep)
print(dash_sep)

file = io.open(input_file, 'r')
local file_content = {}

local x = 0
local twice = 0
for line in file:lines() do
    local s
    if string.find(line,find_string) then
        local replace_string = "cb_id[" .. x .. "]"
        s = string.gsub(line,find_string,replace_string)
        print(s)
        twice = twice +1
        if twice % 2 == 0 then x = x + 1 end
    else
        --s = line
    end
--table.insert(file_content,s)
end

io.close(file)

--[[

file = io.open(output_file, 'w')
for index, value in ipairs(file_content) do
   file:write(value..'\n')
end
io.close(file)

--]]