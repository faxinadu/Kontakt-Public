Kontakt.reset_multi()

Kontakt.add_instrument_bank()

local path = Filesystem.join(Kontakt.ni_content_path,
                             'Kontakt Factory Library/Instruments/Vintage')
local slot = 0
for _, file in Filesystem.recursive_directory(path) do
  if Filesystem.extension(file) == '.nki' then
    Kontakt.load_instrument(file, slot)
    slot = slot + 1
    if slot == Kontakt.get_free_instrument_index() then
      Kontakt.add_instrument_bank()
    end
  end
end