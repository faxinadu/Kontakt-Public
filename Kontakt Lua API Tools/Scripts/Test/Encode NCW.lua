
local wav_path = Filesystem.preferred(Kontakt.script_path .. "/assets/1.wav")
local ncw_path = Filesystem.preferred(Kontakt.script_path .. "/assets/1.ncw")

print(wav_path)
Kontakt.encode_ncw(wav_path,ncw_path)



