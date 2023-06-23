----------------------------------------------------------------------------------------------------
-- Tutorial 13: Create Link Pack Resource Container NKR
----------------------------------------------------------------------------------------------------
--[[ 

--]]

-- Reset Kontakt rack.
Kontakt.reset_multi()

-- We would like to save our instrument. We prepare a folder where we will save it.
local save_base_path = Filesystem.preferred(Kontakt.script_path .. "/Generated")
-- Some error handling, if this folder does not exist then create it.
if not Filesystem.exists(save_base_path) then Filesystem.create_directory(save_base_path) end
-- A subflder for this tutorial.
save_base_path = Filesystem.preferred(save_base_path .. "/resource_container_test")
-- Some error handling, if this folder does not exist then create it.
if not Filesystem.exists(save_base_path) then Filesystem.create_directory(save_base_path) end

-- Add a new instrument.
local instrument = Kontakt.add_instrument()
-- Save the instrument in with the path.
Kontakt.save_instrument(instrument,Filesystem.preferred(save_base_path .. "/instrument.nki"))

-- Create the resource container nkr file and bind the nki to it.
-- If the folder structure does not exist it is created, otherwise it is kept.
-- If files have been changed, the nkr is repacked.
Kontakt.create_resource_container(instrument,Filesystem.preferred(save_base_path .. "/instrument.nkr"))
