----------------------------------------------------------------------------------------------------
-- Kontakt LUA Utilities File 
----------------------------------------------------------------------------------------------------
-- This file includes useful functions for usage in Kontakt Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local kUtil = require("KUtil")

local KUtil = {}

local unpack = table.unpack or unpack -- Lua 5.1 or 5.2 table unpacker

--- Add any amount of numbers.
-- @tparam any number of comma seperated number arguments.
-- @treturn the sum of all arguments.
function KUtil.add_numbers(...)
    local s = 0
    for i = 1, select("#", ...) do s = s + select(i, ...) end
    return s
end

--- Sort a table alpha numerically.
-- @tparam table o original table.
-- @treturn table o sorted table.
function KUtil.alpha_numeric_sort(o)
    local function padnum(d)
        local dec, n = string.match(d, "(%.?)0*(.+)")
        return #dec > 0 and ("%.12f"):format(d) or
                   ("%s%03d%s"):format(dec, #n, n)
    end
    table.sort(o, function(a, b)
        return tostring(a):gsub("%.?%d+", padnum) .. ("%3d"):format(#b) <
                   tostring(b):gsub("%.?%d+", padnum) .. ("%3d"):format(#a)
    end)
    return o
end

--- Check if a terminal command path exists.
-- The path to the terminal command to be run.
-- @tparam bool returns true if the command can be run in terminal.
function KUtil.command_exists(command_path)
    f = assert(io.popen(command_path))
    local counter = 0
    for line in f:lines() do counter = counter + 1 end
    f:close()
    if counter > 0 then
        return true
    else
        return false
    end
end

--- Compare absolute of two numbers and return the greater number.
-- @tparam number first the first number to compare.
-- @tparam number second the second number to compare.
-- @treturn number the greater of the two numbers.
function KUtil.compare_two_numbers(first, second)
    if math.abs(first) > math.abs(second) then
        return math.abs(first)
    else
        return math.abs(second)
    end
end

--- Dash line separator printed to the console.
-- Set an optional verbose_mode boolean variable to control printing.
-- @tparam bool verbose_mode only prints when set to true.
function KUtil.dash_sep_print(verbose_mode)
    local dash_sep =
        "------------------------------------------------------------"
    if verbose_mode == nil then verbose_mode = true end
    if verbose_mode then print(dash_sep) end
end

--- Controlled print, only prints if set to verbose.
-- Set an optional global verbose_mode boolean variable to control printing. 
-- @tparam string debug_message the message to print.
-- @tparam bool verbose_mode only prints if set to true.
function KUtil.debug_print(debug_message, verbose_mode)
    if verbose_mode == nil then verbose_mode = true end
    if verbose_mode then print(debug_message) end
end

--- Get the width and height of an image file.
-- @tparam string file path to image file.
-- @treturn int image width in pixels.
-- @treturn int image height in pixels.
function KUtil.get_image_width_height(file)
    local fileinfo = type(file)
    if type(file) == "string" then
        file = assert(io.open(file, "rb"))
    else
        fileinfo = file:seek("cur")
    end
    local function refresh()
        if type(fileinfo) == "number" then
            file:seek("set", fileinfo)
        else
            file:close()
        end
    end
    local width, height = 0, 0
    file:seek("set", 1)
    -- Detect if PNG
    if file:read(3) == "PNG" then
        --[[
			The strategy is
			1. Seek to position 0x10
			2. Get value in big-endian order
		]]
        file:seek("set", 16)
        local widthstr, heightstr = file:read(4), file:read(4)
        if type(fileinfo) == "number" then
            file:seek("set", fileinfo)
        else
            file:close()
        end
        width =
            widthstr:sub(1, 1):byte() * 16777216 + widthstr:sub(2, 2):byte() *
                65536 + widthstr:sub(3, 3):byte() * 256 +
                widthstr:sub(4, 4):byte()
        height = heightstr:sub(1, 1):byte() * 16777216 +
                     heightstr:sub(2, 2):byte() * 65536 +
                     heightstr:sub(3, 3):byte() * 256 +
                     heightstr:sub(4, 4):byte()
        return width, height
    end
    file:seek("set")
    -- Detect if BMP
    if file:read(2) == "BM" then
        --[[ 
			The strategy is:
			1. Seek to position 0x12
			2. Get value in little-endian order
		]]
        file:seek("set", 18)
        local widthstr, heightstr = file:read(4), file:read(4)
        refresh()
        width =
            widthstr:sub(4, 4):byte() * 16777216 + widthstr:sub(3, 3):byte() *
                65536 + widthstr:sub(2, 2):byte() * 256 +
                widthstr:sub(1, 1):byte()
        height = heightstr:sub(4, 4):byte() * 16777216 +
                     heightstr:sub(3, 3):byte() * 65536 +
                     heightstr:sub(2, 2):byte() * 256 +
                     heightstr:sub(1, 1):byte()
        return width, height
    end
    -- Detect if JPG/JPEG
    file:seek("set")
    if file:read(2) == "\255\216" then
        --[[
			The strategy is
			1. Find necessary markers
			2. Store biggest value in variable
			3. Return biggest value
		]]
        local lastb, curb = 0, 0
        local xylist = {}
        local sstr = file:read(1)
        while sstr ~= nil do
            lastb = curb
            curb = sstr:byte()
            if (curb == 194 or curb == 192) and lastb == 255 then
                file:seek("cur", 3)
                local sizestr = file:read(4)
                local h = sizestr:sub(1, 1):byte() * 256 +
                              sizestr:sub(2, 2):byte()
                local w = sizestr:sub(3, 3):byte() * 256 +
                              sizestr:sub(4, 4):byte()
                if w > width and h > height then
                    width = w
                    height = h
                end
            end
            sstr = file:read(1)
        end
        if width > 0 and height > 0 then
            refresh()
            return width, height
        end
    end
    file:seek("set")
    -- Detect if GIF
    if file:read(4) == "GIF8" then
        --[[
			The strategy is
			1. Seek to 0x06 position
			2. Extract value in little-endian order
		]]
        file:seek("set", 6)
        width, height = file:read(1):byte() + file:read(1):byte() * 256,
                        file:read(1):byte() + file:read(1):byte() * 256
        refresh()
        return width, height
    end
    -- More image support
    file:seek("set")
    -- Detect if Photoshop Document
    if file:read(4) == "8BPS" then
        --[[
			The strategy is
			1. Seek to position 0x0E
			2. Get value in big-endian order
		]]
        file:seek("set", 14)
        local heightstr, widthstr = file:read(4), file:read(4)
        refresh()
        width =
            widthstr:sub(1, 1):byte() * 16777216 + widthstr:sub(2, 2):byte() *
                65536 + widthstr:sub(3, 3):byte() * 256 +
                widthstr:sub(4, 4):byte()
        height = heightstr:sub(1, 1):byte() * 16777216 +
                     heightstr:sub(2, 2):byte() * 65536 +
                     heightstr:sub(3, 3):byte() * 256 +
                     heightstr:sub(4, 4):byte()
        return width, height
    end
    file:seek("end", -18)
    -- Detect if Truevision TGA file
    if file:read(10) == "TRUEVISION" then
        --[[
			The strategy is
			1. Seek to position 0x0C
			2. Get image width and height in little-endian order
		]]
        file:seek("set", 12)
        width = file:read(1):byte() + file:read(1):byte() * 256
        height = file:read(1):byte() + file:read(1):byte() * 256
        refresh()
        return width, height
    end
    file:seek("set")
    -- Detect if JPEG XR/Tagged Image File (Format)
    if file:read(2) == "II" then
        -- It would slow, tell me how to get it faster
        --[[
			The strategy is
			1. Read all file contents
			2. Find "Btomlong" and "Rghtlong" string
			3. Extract values in big-endian order(strangely, II stands for Intel byte ordering(little-endian) but it's in big-endian)
		]]
        temp = file:read("*a")
        btomlong = {temp:find("Btomlong")}
        rghtlong = {temp:find("Rghtlong")}
        if #btomlong == 2 and #rghtlong == 2 then
            heightstr = temp:sub(btomlong[2] + 1, btomlong[2] + 5)
            widthstr = temp:sub(rghtlong[2] + 1, rghtlong[2] + 5)
            refresh()
            width = widthstr:sub(1, 1):byte() * 16777216 +
                        widthstr:sub(2, 2):byte() * 65536 +
                        widthstr:sub(3, 3):byte() * 256 +
                        widthstr:sub(4, 4):byte()
            height = heightstr:sub(1, 1):byte() * 16777216 +
                         heightstr:sub(2, 2):byte() * 65536 +
                         heightstr:sub(3, 3):byte() * 256 +
                         heightstr:sub(4, 4):byte()
            return width, height
        end
    end
    -- Video support
    file:seek("set", 4)
    -- Detect if MP4
    if file:read(7) == "ftypmp4" then
        --[[
			The strategy is
			1. Seek to 0xFB
			2. Get value in big-endian order
		]]
        file:seek("set", 0xFB)
        local widthstr, heightstr = file:read(4), file:read(4)
        refresh()
        width =
            widthstr:sub(1, 1):byte() * 16777216 + widthstr:sub(2, 2):byte() *
                65536 + widthstr:sub(3, 3):byte() * 256 +
                widthstr:sub(4, 4):byte()
        height = heightstr:sub(1, 1):byte() * 16777216 +
                     heightstr:sub(2, 2):byte() * 65536 +
                     heightstr:sub(3, 3):byte() * 256 +
                     heightstr:sub(4, 4):byte()
        return width, height
    end
    file:seek("set", 8)
    -- Detect if AVI
    if file:read(3) == "AVI" then
        file:seek("set", 0x40)
        width = file:read(1):byte() + file:read(1):byte() * 256 +
                    file:read(1):byte() * 65536 + file:read(1):byte() * 16777216
        height = file:read(1):byte() + file:read(1):byte() * 256 +
                     file:read(1):byte() * 65536 + file:read(1):byte() *
                     16777216
        refresh()
        return width, height
    end
    refresh()
    return nil
end

--- Check if a file has a valid audio file extension.
-- @tparam string file the path to the file.
-- @treturn bool returns true if the file has a valid audio extention.
function KUtil.is_audio_file(file)
    local extension_list = {
        ".wav", ".aif", ".aiff", ".rex", ".rx2", ".snd", ".ncw"
    }
    local check_file = false
    if Filesystem.is_regular_file(file) then
        for k, v in pairs(extension_list) do
            if Filesystem.extension(file) == v then check_file = true end
        end
    end
    return check_file
end

--- Check if a number is in a range.
-- @tparam number val the number to check.
-- @tparam number min the minimum range.
-- @tparam number max the maximum range.
-- @treturn bool returns true if the value is in the specified range.
function KUtil.is_in_range(val, min, max) return val >= min and val <= max end

--- Parses a number into bytes.
-- @tparam number n the number to convert.
-- @tparam number length the bit length.
-- @treturn string bytes
function KUtil.ntob(n, len)
    local n, bytes = math.max(math.floor(n), 0), {}
    for i = 1, len do
        bytes[i] = n % 256
        n = math.floor(n / 256)
    end
    return string.char(unpack(bytes))
end

function KUtil.open_url(url)
    local path_sep = package.config:sub(1,1)
	if path_sep == "\\" then
        os.execute('start "" "' .. url .. '"')
    else
        os.execute('open "" "' .. url .. '"')
    end
end

--- Fill a with files or directories from a directory recursively
-- @tparam string path the path to start looking in.
-- @tparam string file extention to look for, DIR returns directories, FILE returns all files, AUDIO returns audio files, KONTAKT returns Kontakt files.
-- @treturn table returns a table with paths to all entries found.
function KUtil.paths_to_table(path, extension, verbose_mode)
    if extension == nil then extension = ".wav" end
    local found_paths = {}
    local i = 1
    if verbose_mode then print("----------Searching Path----------") end
    for _, p in Filesystem.recursive_directory(path) do
        if extension == "DIR" then
            if not Filesystem.is_regular_file(p) then
                if verbose_mode then print("Directory path found: " .. p) end
                found_paths[i] = p
                i = i + 1
            end
        else 
            if Filesystem.is_regular_file(p) then
                if Filesystem.extension(p) == extension or extension == "FILE" or (extension == "KONTAKT" and (Filesystem.extension(p) == ".nki" or Filesystem.extension(p) == ".nkm" or Filesystem.extension(p) == ".nkb")) or (extension == "AUDIO" and (Filesystem.extension(p) == ".wav" or Filesystem.extension(p) == ".aif" or Filesystem.extension(p) == ".aiff")) then
                    if verbose_mode then
                        print("File " .. extension .. " path found: " .. p)
                    end
                    found_paths[i] = p
                    i = i + 1
                end
            end
        end
    end
    return found_paths
end

--- Controlled print function for nicely printing the table results.
-- Set an optional global verbose_mode boolean variable to control printing. 
-- @tparam table arr the table to print.
-- @tparam bool verbose_mode only prints if set to true, default is true.
function KUtil.print_r(arr, verbose_mode)
    if verbose_mode == nil then verbose_mode = true end
    if verbose_mode then
        local str = ""
        local indent_str
        i = 1
        for index, value in pairs(arr) do
            indent_str = i .. "\t"
            str = str .. indent_str .. index .. ": " .. value .. "\n"
            i = i + 1
        end
        print(str)
    end
end

--- Generate a random float between the minimum and maximum range.
-- @tparam number min the minimum range.
-- @tparam number max the maximum range.
-- @treturn float returns a random float within the specified range.
function KUtil.random_float(min, max) return min + math.random() * (max - min) end

--- Round a float number option 1
-- @tparam float float_num the float numbet to round.
-- @treturn int returns rounded integer.
function KUtil.round(float_num)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

--- Round a float number option 2
-- @tparam float float_num the float number to round.
-- @treturn int returns rounded integer.
function KUtil.round_num(float_num) return math.floor(float_num + 0.5) end

--- Scale a value from an old range to a new range.
-- @tparam old_val number the value to be scaled.
-- @tparam old_min number the old minimum range of the value.
-- @tparam old_max number the old maximum range of the value.
-- @tparam new_min number the new minimum range of the value.
-- @tparam new_max number the new maximum range of the value.
-- @treturn returns the value within the new range.
function KUtil.scale_value(old_val, old_min, old_max, new_min, new_max)
    local new_val = (((old_val - old_min) * (new_max - new_min)) / (old_max - old_min)) + new_min
    return new_val
end

--- Split a string and return the result after the seperator.
-- @tparam string input_string the string to check.
-- @tparam string sep the seperator to look for.
-- @treturn string returns the sub-strung after the seperator.
function KUtil.string_split(input_string, sep)
    for s in string.gmatch(input_string, "[^" .. sep .. "]+") do return s end
end

--- Check if a string starts with a sub-string.
-- @tparam string input_string the string to check.
-- @tparam string start_with the sub-string to check.
-- @treturn bool returns true if the string starts with the sub-string.
function KUtil.string_starts(input_string, start_with)
    return string.sub(input_string, 1, string.len(start_with)) == start_with
end

--- Collect duplicate entires in a table.
-- @tparam table file_table the table of files with just the file names to check.
-- @tparam table paths_table the table of files with the full paths to the files to check.
-- @tparam var element the duplicate element to check for.
-- @treturn table returns a table with a list of the duplicate paths.
function KUtil.table_collect_duplicates(file_table, paths_table, element)
    local element_count = 0
    local first_match
    local duplicate_table = {}
    for index, file in next, file_table do
        if (rawequal(file, element)) then
            if element_count == 0 then
                first_match = paths_table[index]
            elseif element_count > 0 then
                if element_count == 1 then
                    table.insert(duplicate_table, first_match)
                end
                table.insert(duplicate_table, paths_table[index])
            end
            element_count = element_count + 1
        end
    end
    return duplicate_table
end

--- Remove duplicate entries from a table.
-- @tparam table tbl table to check.
-- @tparam var element the element to look for.
-- @treturn table returns a table containing only the first occurance of the element.
function KUtil.table_remove_duplicates(tbl, element)
    local stripped_table = {}
    local element_count = 0
    for _, v in ipairs(tbl) do
        if (rawequal(v, element)) then
            element_count = element_count + 1
            if element_count == 1 then
                table.insert(stripped_table, v)
            end
        else
            table.insert(stripped_table, v)
        end
    end
    return stripped_table
end

--- Check how many entries are in a table.
-- @tparam table t table to check.
-- @treturn int returns the number of entries.
function KUtil.table_size(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

--- Check if a  value exists in a table.
-- @tparam table t the table to check.
-- @tparam var v the value to check for.
-- @treturn bool returns true if the value exists in the table.
function KUtil.table_value_check(t, v)
    for index, value in ipairs(t) do if value == v then return true end end
end

--- Return where a value was first found in a table.
-- @tparam table t the table to check.
-- @tparam var v the value to check for.
-- @treturn int returns the index in the table where the value was first found.
function KUtil.table_value_index(t, v)
    for index, value in ipairs(t) do if value == v then return index end end
end

--- Return true if a number is 1 or a string is "true", otherwise false.
-- @tparam v number or string to check.
-- @treturn bool  
function KUtil.tobool(v)
    return v and
               ((type(v) == "number") and (v == 1) or
                   ((type(v) == "string") and (v == "true")))
end

--- Parse each file and make a tokens list.
-- @tparam string paths_table the table of paths to iterate over.
-- @tparam string token_separator the string separating each token.
-- @treturn table returns a table with the tokens found in the file name.
function KUtil.tokens_to_table(paths_table, token_separator)
    local tokens_table = {}
    for index, file in pairs(paths_table) do
        -- Initialize a table for the tokens of each sample
        local temp_tokens = {}
        -- Get the clean file name (without path and extension) to parse.
        local file_name = Filesystem.filename(file):gsub(
                              Filesystem.extension(file), "")
        if verbose_mode then
            print(dash_sep)
            print("File to parse: " .. file_name)
        end
        -- Prepare a table with the tokens from each sample. 
        for token in file_name:gmatch(token_separator) do
            table.insert(temp_tokens, token)
        end
        -- Print the token list of each sample.
        if verbose_mode then
            print("Tokens found: ")
            KUtil.print_r(temp_tokens)
        end
        -- Insert each sample's token list into the main tokens list.
        table.insert(tokens_table, temp_tokens)
    end
    return tokens_table
end

--- Return a Kontakt banner.
-- @treturn table returns a banner string.
function KUtil.kontakt_banner()
    local kontakt_banner = [[
		
,,,,,,,,,,,,,;:codxxxxdoc:;,,,,,,,,,,,,,
,,,,,,,,,;coxOKXNWWWWWWNXKOxoc;,,,,,,,,,
,,,,,,,cd0XWMMMWNXXXXXNNWMMMWXOd:,,,,,,,
,,,,,ckXWMWNKkdlc::::::codOKWMMWXx:,,,,,
,,,;dXWMWXxl;,,,,,,,,,,,,,,:okXMMWKo;,,,
,,:kNMMNx:,,,,,,,,,,,;:ldo;,,,cONMMNx;,,
,:kWMMKo;,,,,,,;coxkO0XWXd;,,,,;dNMMNd;,
,dNMMXo,,,,,,lOKNWMMMMWNx;,,;:lokXMMMKl,
:OMMWk;,,,,,c0MMMWKOkxdolodk0XNMMMMMMWx;
cKMMNd,,,,,:OWMMWOccoxOKNWMMMMMMWNWMMMO:
cKMMWd,,,,:kWMMW0cc0WWMMMMWNX0kdllOWMMO:
:OWMWOccox0NMMMKl:OWWWX0Oxoc:,,,,cKMMWx;
,oXMMWNNWMMMMMXo;cddol:;,,,,,,,,;kWMMKl,
,;xNMMMMMWNKOxl;,,,,,,,,,,,,,,,:xNMMNd;,
,,:xNMMMXxc;,,,,,,,,,,,,,,,,,;l0WMMXd;,,
,,,;dKWMWXkl;,,,,,,,,,,,,,;cd0NMMW0l;,,,
,,,,,:xXWMMWKOxolccccclodk0XWMMWKd:,,,,,
,,,,,,,:dOXWMMMWWNNNNNNWMMMMWKko:,,,,,,,
,,,,,,,,,;:oxO0KXNNNNNNXK0kdl:,,,,,,,,,,
,,,,,,,,,,,,,,;:cloooolc:;,,,,,,,,,,,,,,
]]

    return kontakt_banner
end

-- return the object.
return KUtil
