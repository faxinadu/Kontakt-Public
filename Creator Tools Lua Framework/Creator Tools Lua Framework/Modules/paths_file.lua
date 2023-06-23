-- On Mac, it is much less hassle if pointing directly to the full path.
-- On Windows, it is simple to add the paths to the system environment variables.

-- When running the "instrument script.lua" script, the paths set there take precedence over the paths set in this file."

--------------------------------------------
-- User environment variables - EDIT THESE
local sox_path_win = filesystem.preferred("\"".. "sox" .. "\"")
local flac_path_win = filesystem.preferred("\"".. "flac" .. "\"")

local sox_path_mac = filesystem.preferred("\"".. "/Users/yaron.eshkar/Faxi/Repositories/Kontakt Lua API Framework/Tools/sox-14.4.2/sox" .. "\"")
local flac_path_mac = filesystem.preferred("\"".. "/opt/homebrew/bin/flac" .. "\"")
--------------------------------------------

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctFile= require("Modules.CtFile")

if ctFile.get_os() then
    sox_path = sox_path_win
    flac_path = flac_path_win
else
    sox_path = sox_path_mac
    flac_path = flac_path_mac
end

