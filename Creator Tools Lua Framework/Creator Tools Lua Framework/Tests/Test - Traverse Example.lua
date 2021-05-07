--[[ 
Traverse Example
Author: Native Instruments
Written by: Yaron Eshkar
Modified: May 7, 2021
--]]

function printKey (key, object)
    print("KEY = " .. key .. "; OBJECT TYPE =" .. object.type.name)
 end
 data.traverse(instrument, printKey)