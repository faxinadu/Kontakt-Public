-- Reset the multi to a clean state, same as if launching Kontakt.
Kontakt.reset_multi()

-- How about adding a bank.
Kontakt.add_instrument_bank()

-- Add instrument
local instrument = Kontakt.add_instrument()

local path = Filesystem.join(Kontakt.ni_content_path,
                             'Kontakt Factory Library/Instruments/Vintage')

local paths_table = {}
-- Then we loop and store the found paths.
for _,p in Filesystem.recursive_directory(path) do
    if Filesystem.extension(p) == ".nki" then
            table.insert(paths_table,p)
    end
end

Kontakt.load_instrument(paths_table[math.random(1,#paths_table)],1)
Kontakt.load_instrument(paths_table[math.random(1,#paths_table)],256)

local instrument_2 = Kontakt.add_instrument()

Kontakt.load_instrument(paths_table[math.random(1,#paths_table)],2)

local instrument_3 = Kontakt.add_instrument()