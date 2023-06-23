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
local zone = Kontakt.add_zone(instrument, 0, random_path)

print("Creating instrument from sample: " .. Filesystem.stem(random_path))

kKsp.set_script_source_string_from_file(instrument,0,ksp_path,verbose_mode)
local instrument_name = Filesystem.stem(random_path)
Kontakt.set_instrument_name(instrument,instrument_name)

if not Filesystem.exists(Filesystem.join(Kontakt.script_path,instrument_name .. "_samples_wav")) then Filesystem.create_directory(Filesystem.join(Kontakt.script_path,instrument_name .. "_samples_wav")) end
if not Filesystem.exists(Filesystem.join(Kontakt.script_path,instrument_name .. "_samples_ncw")) then Filesystem.create_directory(Filesystem.join(Kontakt.script_path,instrument_name .. "_samples_ncw")) end

print("Saving instrument with various settings...")

Kontakt.save_instrument(0,Filesystem.join(Kontakt.script_path,instrument_name .. "_patch.nki"))
Kontakt.save_instrument(0,Filesystem.join(Kontakt.script_path,instrument_name .. "_samples.nki"),
    {
        mode = 'samples',
        absolute_paths = false,
        compress_samples = false,
        samples_sub_dir = Filesystem.join(Kontakt.script_path,instrument_name .. "_samples_wav"),
    }
)
Kontakt.save_instrument(0,Filesystem.join(Kontakt.script_path,instrument_name .. "_samples_ncw.nki"),
    {
        mode = 'samples',
        absolute_paths = false,
        compress_samples = true,
        samples_sub_dir = Filesystem.join(Kontakt.script_path,instrument_name .. "_samples_ncw"),
    }
)
Kontakt.save_instrument(0,Filesystem.join(Kontakt.script_path,instrument_name .. "_monolith.nki"),
    {
        mode = 'monolith',
        compress_samples = false
    }
)
Kontakt.save_instrument(0,Filesystem.join(Kontakt.script_path,instrument_name .. "_monolith_ncw.nki"),
    {
        mode = 'monolith',
        compress_samples = true
    }
)

print("Saving snapshots...")

if not Filesystem.exists("/Users/yaron.eshkar/Documents/Native Instruments/User Content/Kontakt/" .. instrument_name .. "_monolith_ncw") then Filesystem.create_directory("/Users/yaron.eshkar/Documents/Native Instruments/User Content/Kontakt/" .. instrument_name .. "_monolith_ncw") end
for i=1,30,1 do
    Kontakt.save_snapshot(0,"/Users/yaron.eshkar/Documents/Native Instruments/User Content/Kontakt/" .. instrument_name .. "_monolith_ncw" .. "/Snapshot " .. i .. ".nksn")    
end
Kontakt.load_snapshot(0,"/Users/yaron.eshkar/Documents/Native Instruments/User Content/Kontakt/" .. instrument_name .. "_monolith_ncw" .. "/Snapshot 1.nksn")
