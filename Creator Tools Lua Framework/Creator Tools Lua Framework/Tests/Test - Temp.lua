--[[ 
Audio Stats Temp
Author: Native Instruments
Written by: Yaron Eshkar
Modified: June 4, 2021
--]]

-- Imports

local test_sox = [["/opt/homebrew/bin/sox"]]
local test_string_1 = [["/opt/homebrew/bin/sox" "/Users/yaron.eshkar/Faxi/ct-lua-framework/Kontakt-Public/Creator Tools Lua Framework/Creator Tools Lua Framework/Samples/1.wav" -n stats]]
local test_string_2 = [["/opt/homebrew/bin/sox" --info "/Users/yaron.eshkar/Faxi/ct-lua-framework/Kontakt-Public/Creator Tools Lua Framework/Creator Tools Lua Framework/Samples/1.wav"]]

f = assert (io.popen (test_string_1))
	
for line in f:lines() do
    print(line)
end

f:close()