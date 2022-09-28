--[[ 
Duplicate File Find Exchange Map
Author: Native Instruments
Written by: Yaron Eshkar
Modified: May 04, 2022
--]]

-- USER VARIABLES

local duplicate_suffix = "_dup"
local increment_start = 1
local verbose_mode = true

local rename_and_remap = true

-- Script

local dash_sep_print = "--------------"

local found_files = {}

for _,g in pairs(instrument.groups) do
    for n,z in pairs(g.zones) do
        table.insert(found_files, z.file)
    end
end

local function check_duplicate_file_names(sample_paths_table,verbose_mode)
    local file_names_table = {}
    local temp_duplicate_table = {}

    local function table_collect_duplicates(file_table,paths_table,element)
        local element_count = 0
        local first_match
        local duplicate_table = {}
        for index, file in next,file_table do
            if (rawequal(file, element)) then
                if element_count == 0 then 
                    first_match = paths_table[index]
                elseif element_count>0 then
                    if element_count == 1 then
                        table.insert(duplicate_table,first_match)    
                    end
                    table.insert(duplicate_table,paths_table[index])
                end
                element_count = element_count + 1
            end
        end
        return duplicate_table
    end

    local function table_remove_duplicates(tbl, element)
        local stripped_table = {}
        local element_count = 0
        for _, v in ipairs(tbl) do
            if (rawequal(v, element)) then
                element_count = element_count + 1
                if element_count == 1 then
                    table.insert(stripped_table,v)
                end
            else
                table.insert(stripped_table,v)        
            end
        end
        return stripped_table
    end

    for index, file in next,sample_paths_table do
        file_names_table[index] = filesystem.filename(file)
    end

    for index, file in next,sample_paths_table do
       local  duplicate_check = {}
        duplicate_check = table_collect_duplicates(file_names_table,sample_paths_table,file_names_table[index])
        if #duplicate_check > 0 then
            for i=1,#duplicate_check do            
                table.insert(temp_duplicate_table,duplicate_check[i])
            end
        end
    end

    for index, file in next,sample_paths_table do
        local temp_table = {}
        temp_table = table_remove_duplicates(temp_duplicate_table,sample_paths_table[index])
        temp_duplicate_table = {}
        for i=1,#temp_table do
            temp_duplicate_table[i] = temp_table[i]
        end
    end

    if verbose_mode then
        if #temp_duplicate_table>0 then
            print("Duplicate check failed! Duplicate file names found:")
            for i=1,#temp_duplicate_table do
                print(dash_sep_print)
                print(temp_duplicate_table[i])
            end
        else
            print("No duplicates found!")
        end
    end

	return temp_duplicate_table
end

-----------------------------------------------------------------------------

print(dash_sep_print)
print("Running duplicate file names check...")
print(dash_sep_print)
print(dash_sep_print)
print(dash_sep_print)

local duplicate_table = {}
duplicate_table = check_duplicate_file_names(found_files,verbose_mode)

if #duplicate_table>0 then 
    if rename_and_remap then 
        print(dash_sep_print)
        print(dash_sep_print)
        print(dash_sep_print)
        print("Renaming and remapping duplicates")
        print(dash_sep_print)
        print(dash_sep_print)
        print(dash_sep_print)
        for _,g in pairs(instrument.groups) do
            for n,z in pairs(g.zones) do
                for k,v in pairs(duplicate_table) do
                    if z.file == v then
                        print(dash_sep_print)
                        print ("OLD IS " .. z.file)
                        local file_extention = filesystem.extension(z.file) 
                        local file_path = filesystem.parentPath(z.file) 
                        local file_name = filesystem.stem(z.file) 
                        local new_name = file_path .. "/" .. file_name .. duplicate_suffix .. increment_start .. file_extention
                        os.rename(filesystem.preferred(z.file),filesystem.preferred(new_name))
                        z.file = filesystem.preferred(new_name)
                        increment_start = increment_start+1
                        if verbose_mode then 
                            print("Changed found duplicate file name in group " .. _ .. " zone " .. n .. " to " .. new_name)
                        end
                    end
                end
            end
        end
    end
end