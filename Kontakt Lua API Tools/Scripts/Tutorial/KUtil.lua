----------------------------------------------------------------------------------------------------
-- Kontakt Lua Utility File 
----------------------------------------------------------------------------------------------------
-- This file contains functions to be used in other Kontakt Lua scripts.
-- Include this line in any script where the code will be used:
-- local kUtil = require("KUtil")
-- Make sure to use the correct filepath in case the script is located in a different folder.

local KUtil = {}

function KUtil.set_instrument_script_source_string_from_file(instrument,slot,path)
    local f = assert(io.open(path,"r"))
    local content = f:read("*all")
    f:close()
    print("Applying ksp script: " .. Filesystem.stem(path))
    print("--------------------------------------------------")
    Kontakt.set_instrument_script_source(instrument,slot,content)
end

function KUtil.set_multi_script_source_string_from_file(slot,path)
    local f = assert(io.open(path,"r"))
    local content = f:read("*all")
    f:close()
    print("Applying ksp script: " .. Filesystem.stem(path))
    print("--------------------------------------------------")
    Kontakt.set_multi_script_source(slot,content)
end


-- Fill a table with files or folders recursively from a directory.
-- @tparam string path to start scanning for files.
-- @tparam string file extension to check for:
-- DIR returns directories, FILE returns all files, AUDIO returns audio files, KONTAKT returns Kontakt files.
-- @treturn table returns a table with paths to all entries found.
function KUtil.paths_to_table(path,extension,verbose_mode)
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

-- Return the object.
return KUtil
