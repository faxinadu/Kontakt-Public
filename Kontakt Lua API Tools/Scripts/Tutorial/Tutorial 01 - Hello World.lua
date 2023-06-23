----------------------------------------------------------------------------------------------------
-- Tutorial 01: Hello World
----------------------------------------------------------------------------------------------------
--[[ 
Welcome to the Kontakt Lua API.     
--]]

-- Print to the terminal.
print("Hello World <3")

-- The Kontakt object is the main entry point into the application.
-- Kontakt can return a number of constants, here are some examples.
print("Kontakt Version: " .. Kontakt.version)
print("Runnig Lua script file: " .. Kontakt.script_file)
print("Running Lua script path: " .. Kontakt.script_path)
print("Max number of instruments: " .. Kontakt.max_num_instruments)
print("KSP Script slots per instrument: " .. Kontakt.max_num_scripts)
print("Max number of groups per instrument: " .. Kontakt.max_num_groups)
print("Max number of zones per instrument: " .. Kontakt.max_num_zones)
print("Player content path: " .. Kontakt.ni_content_path)
print("Non player content base path: " .. Kontakt.non_player_content_base_path)
print("Snapshot base path: " .. Kontakt.snapshot_path)
print("Factory base path: " .. Kontakt.factory_path)
print("Desktop path: " .. Kontakt.desktop_path)
print("Documents path: " .. Kontakt.documents_path)
print("Is Mac OS",Kontakt.macos)
print("Is Windows",Kontakt.windows)

-- It is possible to use a shorthand.
local k = Kontakt
print("Max number of loops per zone: " .. k.max_num_sample_loops)

-- Anything can be printed to the terminal. How about a Kontakt ASCII logo.
-- The logo is defined as a string variable.
local kontakt_banner = [[
		
,,,,,,,,,,,,,;:codxxxxdoc:;,,,,,,,,,,,,,
,,,,,,,,,;coxOKXNWWWWWWNXKOxoc;,,,,,,,,,
,,,,,,,cd0XWMMMWNXXXXXNNWMMMWXOd:,,,,,,,
,,,,,ckXWMWNKkdlc::::::codOKWMMWXx:,,,,,
,,,;dXWMWXxl;,,,,,,,,,,,,,,:okXMMWKo;,,,
,,:kNMMNx:,,,,,,,,,,,;:ldo;,,,cONMMNx;,,
,:kWMMKo;,,,,,,;coxkO0XWXd;,,,,;dNMMNd;,
,dNMMXo,,,,,,lOKNWMMMMWNx;,,;:lokXMMMKl,
:OMMWk;,,,,,c0MMMWKOkxdolodk0XNMMMMMMWx;
cKMMNd,,,,,:OWMMWOccoxOKNWMMMMMMWNWMMMO:
cKMMWd,,,,:kWMMW0cc0WWMMMMWNX0kdllOWMMO:
:OWMWOccox0NMMMKl:OWWWX0Oxoc:,,,,cKMMWx;
,oXMMWNNWMMMMMXo;cddol:;,,,,,,,,;kWMMKl,
,;xNMMMMMWNKOxl;,,,,,,,,,,,,,,,:xNMMNd;,
,,:xNMMMXxc;,,,,,,,,,,,,,,,,,;l0WMMXd;,,
,,,;dKWMWXkl;,,,,,,,,,,,,,;cd0NMMW0l;,,,
,,,,,:xXWMMWKOxolccccclodk0XWMMWKd:,,,,,
,,,,,,,:dOXWMMMWWNNNNNNWMMMMWKko:,,,,,,,
,,,,,,,,,;:oxO0KXNNNNNNXK0kdl:,,,,,,,,,,
,,,,,,,,,,,,,,;:cloooolc:;,,,,,,,,,,,,,,
]]

-- Print it.
print(kontakt_banner)

-- The terminal output can be colored.
-- NOTE: Does not work with Sublime editor as of this writing!
Kontakt.colored_output = true
print("I should be colored")
Kontakt.colored_output = false
print("I should be uncolored")