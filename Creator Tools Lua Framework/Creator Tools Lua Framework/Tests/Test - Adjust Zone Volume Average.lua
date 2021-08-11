--[[ 
Adjust Zone Volume Average
Author: Native Instruments
Written by: Yaron Eshkar
Modified: August 11, 2021
--]]

function get_peak_levels(group)
    local result_table = {}
    local result_average = 0
    for n,z in pairs(instrument.groups[group].zones) do
        table.insert(result_table,mir.detectPeak(z.file))
    end
    for i=1,#result_table do
        result_average = result_average + result_table[i]
    end
    result_average = result_average / #result_table
    return result_table, result_average
end

function set_zone_volume(group,reference_peak)
    for n,z in pairs(instrument.groups[group].zones) do
        local peak = mir.detectPeak(z.file)
        local difference = reference_peak - peak
        z.volume = difference
    end
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

local mir_levels, mir_average = get_peak_levels(0)

print_r(mir_levels)
print("Average peak: ".. mir_average)

set_zone_volume(0,mir_average)