----------------------------------------------------------------------------------------------------
-- Kontakt LUA Okwt Utilities File 
----------------------------------------------------------------------------------------------------
-- This file includes useful functions for usage in Kontakt Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local kSignet = require("KOkwt")

local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = root_path .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUtil = require("Modules.KUtil")
local kUser = require("Modules.KUser")

local okwt_path = kUser.okwt_path

local KOkwt = {}

--- Converts wavetable files from one frame size to another.
-- @tparam string input_file 
-- @tparam string output_file 
-- @tparam string old_frame_size 
-- @tparam string new_frame_size 
function KOkwt.convert_frame_size(input_file,output_file,old_frame_size,new_frame_size)
    local okwt_command_1 = "--infile"
    local okwt_command_2 = "--outfile"
    local okwt_command_3 = "--frame-size"
    local okwt_command_4 = "--new-frame-size"
    local execute_string = string.format([[%s %s "%s" %s "%s" %s %s %s %s]],okwt_path,okwt_command_1,input_file,okwt_command_2,output_file,okwt_command_3,old_frame_size,okwt_command_4,new_frame_size)
    os.execute(execute_string)
end

-- return the KOkwt object.
return KOkwt
