----------------------------------------------------------------------------------------------------
-- Kontakt LUA KSP File 
----------------------------------------------------------------------------------------------------
-- This file includes useful functions for usage in Kontakt Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local kKsp = require("KKsp")
--

local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = root_path .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUtil = require("Modules.KUtil")

local KKsp = {}

function KKsp.set_script_source_string_from_file(instrument,slot,path,verbose_mode)
    if verbose_mode == nil then verbose_mode = true end
    if verbose_mode then
        print("Applying ksp script: " .. Filesystem.stem(path))
        print("--------------------------------------------------")
    end
    local ksp_string = kFile.read_file_to_string(path)
    Kontakt.set_script_source(instrument,slot,ksp_string)
end

return KKsp