local root_path = Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path))
package.path = root_path .. "/?.lua;" .. package.path

-- Include the KUtil.lua script file.
local kUtil = require("Modules.KUtil")

-- Path to the instrument.
local instrument = Filesystem.preferred("/Users/Shared/Myth Rhythm/Instruments/Myth Rhythm.nki")

-- Reset Kontakt rack.
Kontakt.reset_multi()

-- Path to the Kontakt snapshots. 
local path = Filesystem.preferred("/Users/Shared/Myth Rhythm/Snapshots/Myth Rhythm")

-- Fine all nksn files.
local paths_table = kUtil.paths_to_table(path,".nksn")

-- Print how many groups were found.
print("Found: " .. #paths_table .. " snapshot files")

-- Load the instrument.
Kontakt.load_instrument(instrument)

function sleep(n)
    os.execute("sleep " .. tonumber(n))
end

-- Load and save snapshots.
for k,v in pairs(paths_table) do
    sleep(3)
    print(v)
    Kontakt.load_snapshot(0,Filesystem.preferred(v))
    Kontakt.save_snapshot(0,Filesystem.preferred(v))
end

