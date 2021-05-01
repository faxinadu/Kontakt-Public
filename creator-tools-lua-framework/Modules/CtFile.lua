----------------------------------------------------------------------------------------------------
-- Creator Tools LUA File Utilities File 
----------------------------------------------------------------------------------------------------
-- Author: Native Instruments
-- Written by: Yaron Eshkar
-- Modified: April 23, 2021
--
-- This file includes useful functions for usage in Creator Tools Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local ctFile = require("CtFile")
-- Then you can simply call any function like:
-- ctFile.test_function()
-- 
-- It is also possible of course to copy entire specific functions from this list directly into your script. 
-- In that case remove the CtFile part from the function name, and then simply call it normally like:
-- test_function()
--

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")

local CtFile = {}

--- Test Function.
-- Takes no arguments, prints to console when called.
function CtFile.test_function()
	-- Show that the class import and test function executes by printing a line.
	print("Test function called")
end

--- Check duplicate file names in path.
-- Checks a path and subfolders and returns a table listing paths of duplicate file names.
-- @tparam string path the directory path to start checking from.
-- @tparam string file_extention the file extention to look for.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn table returns a table with the paths of all duplicate file names.
function CtFile.check_duplicate_file_names(path,file_extention,verbose_mode)

	local sample_paths_table = ctUtil.paths_to_table(path,file_extention)

    local file_names_table = {}
    local temp_duplicate_table = {}

    for index, file in next,sample_paths_table do
        file_names_table[index] = filesystem.filename(file)
    end

    for index, file in next,sample_paths_table do
       local  duplicate_check = {}
        duplicate_check = ctUtil.table_collect_duplicates(file_names_table,sample_paths_table,file_names_table[index])
        if #duplicate_check > 0 then
            for i=1,#duplicate_check do            
                table.insert(temp_duplicate_table,duplicate_check[i])
            end
        end
    end

    for index, file in next,sample_paths_table do
        local temp_table = {}
        temp_table = ctUtil.table_remove_duplicates(temp_duplicate_table,sample_paths_table[index])
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

--- Copy a file.
-- Copies a file from source to destination path.
-- @tparam string source the source file to copy.
-- @tparam string destination the destination path to copy to.
-- @treturn bool 
function CtFile.copy_file(source,destination)
	local execute_string
	if CtFile.get_os() then
		s1 = "/Y"
		execute_string = string.format([[xcopy "%s" "%s" %s]],source,destination,s1)
	else
		execute_string = string.format([[cp "%s" "%s"]],source,destination)
	end
	CtFile.run_shell_command(execute_string,false)
    return true
end

--- Create a directory.
-- Creates a directory with the specified path name.
-- @tparam string directory the directory path to create.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool
function CtFile.create_directory(directory,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	local execute_string
	if not filesystem.isDirectory(directory) then
	    execute_string = string.format([[mkdir "%s"]],directory)
		CtFile.run_shell_command(execute_string,false)
		if verbose_mode then print("Directory "..directory.." created") end
	else
		if verbose_mode then print("Directory "..directory.." exists") end
	end
    return true
end

--- Delete a file.
-- Deletes the specified file.
-- @tparam string file the file to delete.
-- @treturn bool
function CtFile.delete_file(file)
	local execute_string
	if CtFile.get_os() then
		s1 = "/f"
		execute_string = string.format([[del %s "%s"]],s1,file)
	else
		execute_string = string.format([[rm "%s"]],file)
	end
	CtFile.run_shell_command(execute_string,false)
    return true
end

--- Get the Operating System type.
-- Determine if the script is running on Windows or Mac.
-- @treturn bool true if windows, otherwise false.
function CtFile.get_os()
	local path_sep = package.config:sub(1,1)
	local is_win
	if path_sep == "\\" then
		is_win = true
	else
		is_win = false
	end
	return is_win
end

--- Run an OS shell command.
-- Executes a command on the operating system console.
-- @tparam string command the shell command to execute.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool
function CtFile.run_shell_command(command,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	if verbose_mode then print("Executing shell command: "..command) end
	os.execute(command)
    return true
end

--- Run shell command and return a string.
-- Executes a command on the operating system console, optionally returing anything printed by the command to the console as a string.
-- @tparam string command the shell command to execute.
-- @tparam bool raw when true the function will return the result formated.
-- @treturn string returns the console print result.
function CtFile.capture_shell_command(command, raw)
  local f = assert(io.popen(command, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

--- Run a shell command on a file, overwriting the original file.
-- Executes a shell command on a file, overwriting the original file with the result. A temporary file location must be specified for the processing.
-- @tparam string command the shell command to execute.
-- @tparam string file the original file.
-- @tparam string temp_file a temporary file path for the intermediate operation.
-- @treturn bool
function CtFile.run_file_process(command,file,temp_file)
	CtFile.run_shell_command(command,false)
	CtFile.copy_file(temp_file,file)
	CtFile.delete_file(temp_file)
    return true
end

--- Reads a file and returns the contents as a string.
-- Reads a file in the specified mode and returns the contents as a string.
-- @tparam string file the file to read.
-- @tparam string mode the read mode.
-- @treturn string returns a string with the file contents.
function CtFile.read_file_to_string(file,mode)
    local f = assert(io.open(file, mode))
    local content = f:read("*all")
    f:close()
    return content
end

--- Replace a line in a file.
-- Overwrites a given line in a file with the specfied string.
-- @tparam string input_file the file to read and wtie to.
-- @tparam int replace_line the line in the file to be replaced.
-- @tparam string replace_content the content that should replace the line.
-- @treturn bool
function CtFile.replace_line_in_file(input_file,replace_line,replace_content)
    local file = io.open(input_file, 'r')
    local file_content = {}
    for line in file:lines() do
        table.insert (file_content, line)
    end
    io.close(file)

    file_content[replace_line] = replace_content

    file = io.open(input_file, 'w')
    for index, value in ipairs(file_content) do
        file:write(value..'\n')
    end
    io.close(file)
    return true
end

-- return the CtFile object.
return CtFile