----------------------------------------------------------------------------------------------------
-- Tutorial 11: Encode and Decode NCW
----------------------------------------------------------------------------------------------------
--[[ 
Encoding and decoding Kontakt NCW files.
--]]

-- Lua files can be imported to reuse functions, constants, tables and more.
-- The KUtil.lua file contains a number of functions, that will be used in this example.
local kUtil = require("KUtil")

-- Filepath to the samples.
local path = Filesystem.preferred(Kontakt.script_path .. "/assets/")

-- First prepare a base folder to save the content.
local save_base_path = Filesystem.preferred(Kontakt.script_path .. "/Generated/")
-- Error handling, if the base folder does not exist then it will be created.
if not Filesystem.exists(save_base_path) then Filesystem.create_directory(save_base_path) end
-- Prepare a sub folder to save the NCW files.
local save_path = Filesystem.preferred(save_base_path .. "NCW/")
-- Error handling, if the base folder does not exist then it will be created.
if not Filesystem.exists(save_path) then Filesystem.create_directory(save_path) end

-- The function to search and store file paths in a table is also contained in the KUtil.lua file.
-- Using imports enables the resusability of code.
local paths_table = kUtil.paths_to_table(path,".wav")

-- Iterate through the table, encoding an NCW file for each found wav file.
for k,v in pairs(paths_table) do
    Kontakt.ncw_encode(v,Filesystem.preferred(save_path .. Filesystem.stem(v) .. ".ncw"))
end

-- It is possible to decode back from NCW to wav.

-- Create a new table, this time with the NCW files.
local paths_table = kUtil.paths_to_table(save_path,".ncw")

-- Prepare a sub folder to save the wav files.
local save_path = Filesystem.preferred(save_base_path .. "WAV/")
-- Error handling, if the base folder does not exist then it will be created.
if not Filesystem.exists(save_path) then Filesystem.create_directory(save_path) end

-- Iterate through the table, encoding an NCW file for each found wav file.
for k,v in pairs(paths_table) do
    Kontakt.ncw_decode(v,Filesystem.preferred(save_path .. Filesystem.stem(v) .. ".wav"))
end



