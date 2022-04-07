--[[ 
Loop Crossfade
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 7, 2022
--]]

if not instrument then
    print("The following error message informs you that the Creator Tools are not "..
          "focused on a Kontakt instrument. To solve this, load an instrument in "..
          "Kontakt and select it from the instrument dropdown menu on top.")
end

local loop_xfade = 50

for _,g in pairs(instrument.groups) do
    for n,z in pairs(g.zones) do
        z.loops[0].mode = 1
        z.loops[0].xfade = loop_xfade
    end
end
