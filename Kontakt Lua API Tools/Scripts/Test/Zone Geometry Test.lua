local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kKsp = require("Modules.KKsp")
local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.user_samples_path
local ksp_path = kUser.framework_ksp_path .. "envelope_and_filter_shell.ksp"

local verbose_mode = true

print("--------------------------------------------------")
print("KONTAKT INSTRUMENT CREATOR DEMO")
print("--------------------------------------------------")
print(kUtil.kontakt_banner())
print("Searching for all sample files in: " .. path)
print("Working... this make take some time")
print("--------------------------------------------------")

local paths_table = kUtil.paths_to_table(path)

print("Found: " .. #paths_table .. " sample files")
print("--------------------------------------------------")



Kontakt.reset_multi(0)
local instrument = Kontakt.add_instrument()

local random_path = paths_table[math.random(#paths_table)]
local group = Kontakt.add_group(instrument)
local zone = Kontakt.add_zone(instrument,group,random_path)
Kontakt.set_zone_geometry(instrument,zone,{
    low_key_fade = 64,
    high_key_fade = 64,
    low_velocity_fade = 63,
    high_velocity_fade = 64,
})

random_path = paths_table[math.random(#paths_table)]
group = Kontakt.add_group(instrument)
zone = Kontakt.add_zone(instrument,group,random_path)
Kontakt.set_zone_geometry(instrument, zone, {
    low_key = 0,
    high_key = 0,
    low_key_fade = 1,
    high_key_fade = 0,
  })

random_path = paths_table[math.random(#paths_table)]
group = Kontakt.add_group(instrument)
zone = Kontakt.add_zone(instrument,group,random_path)
Kontakt.set_zone_geometry(instrument, zone, {
    low_key = 0,
    high_key = 0,
    low_key_fade = 0,
    high_key_fade = 1,
  })

random_path = paths_table[math.random(#paths_table)]
group = Kontakt.add_group(instrument)
zone = Kontakt.add_zone(instrument,group,random_path) 
Kontakt.set_zone_geometry(instrument, zone, {
    low_velocity = 126,
    high_velocity = 127,
    low_velocity_fade = 0,
    high_velocity_fade = 2,
  })
