local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kAudio = require("Modules.KAudio")
local kFile = require("Modules.KFile")
local kKsp = require("Modules.KKsp")
local kMap = require("Modules.KMap")
local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.user_samples_path
local ksp_path = kUser.framework_ksp_path .. "envelope_and_filter_shell.ksp"

local num_groups = 4

local verbose_mode = true

Kontakt.reset_multi(0)
local instrument = Kontakt.add_instrument()
Kontakt.set_instrument_name(instrument,kUser.user_name .. " Random Mapped " .. math.random(0,1000000))

local paths_table = kUtil.paths_to_table(path)

if verbose_mode then
    print("Create Mapped Instrument")
    print("Searching for all sample files in: " .. path)
    print("Working... this make take some time")
    print("--------------------------------------------------")
end

local drums_table = {}
for k,v in pairs(paths_table) do
    if MIR.detect_sample_type(v) == "drum" and not (MIR.detect_drum_type(v) == "kick") then
        table.insert(drums_table,v)
    end
end

print("Found " .. kUtil.table_size(drums_table) .. " drums")

kMap.mapped_zones(instrument,0,drums_table,48)

local instruments_table = {}
for k,v in pairs(paths_table) do
    if (kAudio.has_loops(v)) then
        table.insert(instruments_table,v)
    end
end

print("Found " .. kUtil.table_size(instruments_table) .. " instruments")

for k,v in pairs(instruments_table) do
    group = Kontakt.add_group(instrument)
    local zone = Kontakt.add_zone(instrument,group,v)
end

kKsp.set_script_source_string_from_file(instrument,0,ksp_path,verbose_mode)
