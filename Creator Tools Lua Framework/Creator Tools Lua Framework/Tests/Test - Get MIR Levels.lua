--[[ 
Get MIR Levels
Author: Native Instruments
Written by: Yaron Eshkar
Modified: August 11, 2021
--]]

function get_mir_levels(group,type)
    local g = instrument.groups[group]
    local result_table = {}
    local result_average = 0
    for n,z in pairs(g.zones) do
        if type == "peak" then table.insert(result_table,mir.detectPeak(z.file)) end
        if type == "RMS" then table.insert(result_table,mir.detectRMS(z.file)) end
        if type == "loudness" then table.insert(result_table,mir.detectLoudness(z.file)) end
        if type == "pitch" then table.insert(result_table,mir.detectPitch(z.file)) end
    end
    for i=1,#result_table do
        result_average = result_average + result_table[i]
    end
    result_average = result_average / #result_table
    return result_table, result_average
end

function print_r(arr)
    local str = ""
    local indent_str
    i = 1
    for index,value in pairs(arr) do
		indent_str = i.."\t"
        str = str..indent_str..index..": "..value.."\n"
        i = i+1
    end
    print(str)
end

local mir_levels, mir_average = get_mir_levels(0,"peak")

print_r(mir_levels)

print(mir_average)