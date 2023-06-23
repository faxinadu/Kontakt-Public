----------------------------------------------------------------------------------------------------
-- Kontakt LUA Map File 
----------------------------------------------------------------------------------------------------
-- This file includes useful functions for usage in Kontakt Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local kMap = require("KMap")
--

local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = root_path .. "/?.lua;" .. package.path

local kUtil = require("Modules.KUtil")

local KMap = {}

function KMap.mapped_zones(instrument,group,paths_table,root_key)
    if root_key == nil then root_key = 0 end
    for k,v in pairs(paths_table) do
        if root_key < 127 then
            local zone = Kontakt.add_zone(instrument,group,v)
            KMap.zone_confine(instrument,zone,root_key)
            root_key = root_key + 1
        end
    end
end

function KMap.zone_confine(instrument,zone,note)
        Kontakt.set_zone_low_key(instrument,zone,note)
        Kontakt.set_zone_high_key(instrument,zone,note)
        Kontakt.set_zone_root_key(instrument,zone,note)
end

return KMap