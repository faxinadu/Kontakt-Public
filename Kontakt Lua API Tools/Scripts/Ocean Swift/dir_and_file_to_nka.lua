
--[[
Directories and Files to NKA files
Author: Ocean Swift
Written by: Yaron Eshkar
Modified: April 6, 2024
--]]

local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")

local path = Filesystem.preferred(Kontakt.script_path .. "/convert")

local dash_sep = "-------------------------------------------------"
print(dash_sep)
print(dash_sep)
print(dash_sep)
print(dash_sep)
print(dash_sep)

local dir_table = {}
local dir_path_table = {}
for _,p in Filesystem.recursive_directory(path) do
    if Filesystem.is_directory(p) then
        table.insert(dir_path_table,p)
        table.insert(dir_table,Filesystem.stem(p))
    end
end

table.sort(dir_path_table)
local ksp_constants = ""
local x = 1
for i, v in pairs(dir_path_table) do
    local filename_text = "!sampleset_" .. x .. "\n"
    local filename_file = Kontakt.script_path .. Filesystem.preferred("/" .. "sampleset_" .. x .. ".nka")
    local file_table = {}
    for _,f in Filesystem.recursive_directory(v) do
        if Filesystem.extension(f) == ".wav" then
            table.insert(file_table,Filesystem.stem(f))
        end
    end
    table.sort(file_table)
    for i, v in pairs(file_table) do
        filename_text = filename_text .. v .. "\n"
    end
    kFile.write_file(filename_file,filename_text)   
    ksp_constants = ksp_constants .. "declare const $num_samples_set_" .. x .. " := " .. #file_table .. "\n"
    print("Sampleset " .. x .. " count: " .. #file_table)
    x = x + 1
end

table.sort(dir_table)
local dir_text = "!sampleset_names" .. "\n"
for i, v in pairs(dir_table) do
    dir_text = dir_text .. v .. "\n"
end
print("Sampleset count: " .. #dir_table)
local dir_file = Kontakt.script_path .. Filesystem.preferred("/" .. "sample_type_names.nka")
kFile.write_file(dir_file,dir_text)   

local ksp_file = Kontakt.script_path .. Filesystem.preferred("/" .. "ksp_constants.txt")
kFile.write_file(ksp_file,ksp_constants)   

