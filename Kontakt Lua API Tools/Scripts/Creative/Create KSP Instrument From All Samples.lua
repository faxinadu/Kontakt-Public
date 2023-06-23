local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.user_samples_path
local ksp_path = kUser.framework_ksp_path .. "source_select_shell.ksp"

print(kUtil.kontakt_banner())
print("Create Instrument")
print("--------------------------------------------------")
print("Samples path: " .. path)
print("Searching for all sample files... this make take some time")
print("--------------------------------------------------")

local paths_table = kUtil.paths_to_table(path)

print("Found: " .. #paths_table .. " sample files")
print("--------------------------------------------------")
if #paths_table > Kontakt.max_num_groups then 
    print("Maximum number of groups in " .. Kontakt.version .. " is " .. Kontakt.max_num_groups)
    print("Only the first " .. Kontakt.max_num_groups - 1 .. " samples will be used")
end

local instrument_name = kUser.user_name .. " Sample Selector " .. math.random(1000000)

print("--------------------------------------------------")
print("Creating instrument: " .. instrument_name .. " this may take some time...")
print("--------------------------------------------------")

Kontakt.reset_multi(0)
local instrument = Kontakt.add_instrument()
Kontakt.set_instrument_name(instrument,instrument_name)

for k,v in pairs(paths_table) do
    if Kontakt.get_num_groups(instrument) < Kontakt.max_num_groups then 
        -- print("Loading sample: " .. v)
        local group = Kontakt.add_group(instrument)
        local zone = Kontakt.add_zone(instrument,group,v)
        Kontakt.set_group_name(instrument,group,Filesystem.stem(v))
    end
end

Kontakt.remove_group(instrument,0)

local ksp_string = kFile.read_file_to_string(ksp_path)

print("Instrument created with " .. Kontakt.get_num_groups(instrument) .. " groups")
print("--------------------------------------------------")
print("Applying ksp script: " .. Filesystem.stem(ksp_path))
print("--------------------------------------------------")

Kontakt.set_script_source(instrument,0,ksp_string)



