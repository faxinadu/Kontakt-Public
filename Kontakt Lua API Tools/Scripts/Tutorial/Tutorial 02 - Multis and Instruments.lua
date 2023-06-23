----------------------------------------------------------------------------------------------------
-- Tutorial 02: Multis and Instruments
----------------------------------------------------------------------------------------------------
--[[ 
The API can interact with the different Kontakt layers e.g. application, multi, bank, instrument.
--]]

-- Reset the multi to it's initial state, analog to launching Kontakt.
Kontakt.reset_multi()

-- Returns from Kontakt can be placed into variables. Let's get the multi name.
local multi_name = Kontakt.get_multi_name()
-- Output the name to the terminal.
print("The multi is called: " .. multi_name)

-- Add a new empty instrument to the rack. 
-- The index of the instrument is returned into a variable.
local instrument = Kontakt.add_instrument()
-- A variable for the getter is optional. The return of the getter function can be printed.
-- The previuosly created variable instrument is used to specify the instrument for which Kontakt should return it's name. 
print("The selected instrument is called: " .. Kontakt.get_instrument_name(instrument))

-- Let's rename the multi and instrument with better names.
Kontakt.set_multi_name("My Multi")
Kontakt.set_instrument_name(instrument,"My NKI")

-- Remember the multi name variable from before? It needs to be updated before the current name can be printed. 
multi_name = Kontakt.get_multi_name()

-- Print the new names.
print("The multi is called: " .. multi_name)
print("The selected instrument is called: " .. Kontakt.get_instrument_name(instrument))

-- The instrument can be removed if it is no longer needed.
Kontakt.remove_instrument(instrument)

-- How about adding a bank?
Kontakt.add_instrument_bank()

