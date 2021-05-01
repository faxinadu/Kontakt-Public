----------------------------------------------------------------------------------------------------
-- Check Duplicate File Names
----------------------------------------------------------------------------------------------------
-- Author: Native Instruments
-- Written by: Yaron Eshkar
-- Modified: April 23, 2021
-----------------------------------------------------------------------------
-- Set the directory path with the samples. 
-- If using samples that are not part of the directory structure where the script is located use a full path e.g.:
-- mac: local path = filesystem.preferred("/Users/john.doe/Projects/Project/Samples/")
-- win: local path = filesystem.preferred("D:/Projects/Project/Samples/")
-- If they are in the directory structure set as:
-- local path = root_path..filesystem.preferred("/samples/")

local root_path = filesystem.parentPath(scriptPath)

local path = root_path..filesystem.preferred("/samples/")

-- Set the file extention to check for
local file_extention = ".wav"

-- Set to true to print results
local verbose_mode = true

-----------------------------------------------------------------------------

local function paths_to_table(path,extension,verbose_mode)
    local sample_paths = {}
    local i = 1
    if verbose_mode then print("----------Searching Path----------") end
    for _,p in filesystem.directoryRecursive(path) do
        -- We only want the sample files to be added to our table and not the directories, we can do this by checking 
        -- if the item is a file or not.
        if filesystem.isRegularFile(p) then
            -- Then we add only audio files to our table.
            if filesystem.extension(p) == extension then
                -- print the sample path.
                if verbose_mode then print("Sample path found: "..p) end
                sample_paths[i] = p
                i = i+1
            end
        end
    end
    return sample_paths
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
                print(temp_duplicate_table[i])
            end
        end
    end

	return temp_duplicate_table
end

-----------------------------------------------------------------------------

local sample_paths_table = paths_to_table(path,file_extention)
check_duplicate_file_names(sample_paths_table,verbose_mode)
