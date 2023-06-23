local content_path = Filesystem.preferred(Kontakt.script_path .. "/Users/Shared/Schema - Dark Library/Instruments/Schema Dark.nki")
print (content_path)

print(Kontakt.ni_content_path)

content_path = Filesystem.preferred(Kontakt.ni_content_path .. "/Straylight Library/Instruments/Straylight.nki")

Kontakt.load_instrument(content_path)