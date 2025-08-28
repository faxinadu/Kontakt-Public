----------------------------------------------------------------------------------------------------
-- Kontakt LUA File Utilities File 
----------------------------------------------------------------------------------------------------
-- This file includes useful functions for usage in Kontakt Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local kFile = require("KFile")

local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = root_path .. "/?.lua;" .. package.path

local kUtil = require("Modules.KUtil")

local KFile = {}

--- Check duplicate file names in path.
-- Checks a path and subfolders and returns a table listing paths of duplicate file names.
-- @tparam string path the directory path to start checking from.
-- @tparam string file_extention the file extention to look for.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn table returns a table with the paths of all duplicate file names.
function KFile.check_duplicate_file_names(path,file_extention,verbose_mode)

	local sample_paths_table = ctUtil.paths_to_table(path,file_extention)

    local file_names_table = {}
    local temp_duplicate_table = {}

    for index, file in next,sample_paths_table do
        file_names_table[index] = Filesystem.filename(file)
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
function KFile.copy_file(source,destination)
	local execute_string
	if KFile.get_os() then
		s1 = "/Y"
		execute_string = string.format([[xcopy "%s" "%s" %s]],source,destination,s1)
	else
		execute_string = string.format([[cp "%s" "%s"]],source,destination)
	end
	KFile.run_shell_command(execute_string,false)
    return true
end

--- Moves a file to a new location.
-- Creates the destination directory if it does not exist.
-- @tparam string source The full path of the file to move.
-- @tparam string destination The full destination path (directory or file).
-- @treturn bool
function KFile.move_file(source, destination)
    -- 1. Get the destination directory from the full destination path.
    -- This matches everything up to the last file separator (\ or /).
    local dest_dir = destination:match("(.*[/\\])")

    -- 2. If a directory path was found, create it.
    if dest_dir then
        local create_dir_cmd
        if KFile.get_os() then -- Windows
            -- On Windows, 'if not exist' prevents an error if the directory already exists.
            -- The trailing \\ is needed for 'exist' to correctly identify a directory.
            create_dir_cmd = string.format('if not exist "%s\\" mkdir "%s"', dest_dir, dest_dir)
        else -- Linux/macOS
            -- 'mkdir -p' creates parent directories as needed and doesn't error if it exists.
            create_dir_cmd = string.format('mkdir -p "%s"', dest_dir)
        end
        KFile.run_shell_command(create_dir_cmd, false)
    end

    -- 3. Construct the appropriate move command for the OS.
    local move_cmd
    if KFile.get_os() then -- Windows
        -- Using 'move'. The /Y suppresses prompting to overwrite an existing file.
        move_cmd = string.format('move /Y "%s" "%s"', source, destination)
    else -- Linux/macOS
        move_cmd = string.format('mv "%s" "%s"', source, destination)
    end

    -- 4. Execute the command and return true.
    KFile.run_shell_command(move_cmd, false)
    return true
end

--- Create a directory.
-- Creates a directory with the specified path name.
-- @tparam string directory the directory path to create.
-- @tparam bool verbose_mode when true prints information to console.
-- @treturn bool
function KFile.create_directory(directory,verbose_mode)
	if verbose_mode == nil then verbose_mode = true end
	local execute_string
	if not Filesystem.is_directory(directory) then
	    execute_string = string.format([[mkdir "%s"]],directory)
		KFile.run_shell_command(execute_string,false)
		if verbose_mode then print("Directory "..directory.." created") end
        return true
	else
		if verbose_mode then print("Directory "..directory.." exists") end
        return false
	end
end

--- Delete a file.
-- Deletes the specified file.
-- @tparam string file the file to delete.
-- @treturn bool
function KFile.delete_file(file)
	local execute_string
	if KFile.get_os() then
		s1 = "/f"
		execute_string = string.format([[del %s "%s"]],s1,file)
	else
		execute_string = string.format([[rm "%s"]],file)
	end
	KFile.run_shell_command(execute_string,false)
    return true
end

--- Get the Operating System type.
-- Determine if the script is running on Windows or Mac.
-- @treturn bool true if windows, otherwise false.
function KFile.get_os()
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
function KFile.run_shell_command(command,verbose_mode)
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
function KFile.capture_shell_command(command,raw)
  local f = assert(io.popen(command, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

--- Runs a shell command and prints the result to console.
function KFile.print_shell_command(command)
    f = assert (io.popen (command))
    for line in f:lines() do
        print(line)
    end
    f:close()
    return true
end

--- Run a shell command on a file, overwriting the original file.
-- Executes a shell command on a file, overwriting the original file with the result. A temporary file location must be specified for the processing.
-- @tparam string command the shell command to execute.
-- @tparam string file the original file.
-- @tparam string temp_file a temporary file path for the intermediate operation.
-- @treturn bool
function KFile.run_file_process(command,file,temp_file,delete_temp)
    if delete_temp == nil then delete_temp = true end
	KFile.run_shell_command(command,false)
	KFile.copy_file(temp_file,file)
	if delete_temp then KFile.delete_file(temp_file) end
    return true
end

--- Reads a file and returns the contents as a string.
-- Reads a file in the specified mode and returns the contents as a string.
-- @tparam string file the file to read.
-- @tparam string mode the read mode.
-- @treturn string returns a string with the file contents.
function KFile.read_file_to_string(file,mode)
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
function KFile.replace_line_in_file(input_file,replace_line,replace_content)
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


function KFile.write_file(input_file,file_content)
    local file = io.open(input_file, 'w')
    file:write(file_content)
    io.close(file)
    return true
end

-- return the KFile object.
return KFile
