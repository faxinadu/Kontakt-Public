----------------------------------------------------------------------------------------------------
-- Tutorial 04: Filesystem API
----------------------------------------------------------------------------------------------------
--[[ 
The Lua binding is based on the C++ library boost filesystem. 
In contrary to the original C++ design, the Lua binding does not define an abstraction for path. 
Instead, path always refers to a Lua string.
For a complete list of functions, refer to the manual.

The Fileystem object is the entry point for these bindings.
--]]

-- The Filesystem API is defined in the global table Filesystem i.e. all constants and functions need to be prefixed with that name.
-- In Lua the tostring function needs to be used to attach a boolean to a string.
print("Do I exist? " .. tostring(Filesystem.exists(Kontakt.script_path)))

-- The Filesystem.preferred function is important, it makes sure paths are consistent between Mac and Windows.
-- Using Filesystem.preferred to set a relative path containing the example files. 
local path = Filesystem.preferred(Kontakt.script_path .. "/assets")

-- Using a variable to store a separator that gets reused to structure the print out information.
local dash_sep = "-------------------------------------------------"

-- The library provides functions to loop over directories. 
-- There are functions to loop over the content of a directory, as well as looping over all sub-directories.
for _,p in Filesystem.recursive_directory(path) do
    -- Print the raw path.
    print("File with path: " .. p)
    -- Print additional Filesystem information for WAV files.
    if Filesystem.extension(p) == ".wav" then
        -- Here are examples for the Filesystem library and the associated data these functions return. 
        print("Filesystem.extension(path) " .. Filesystem.extension(p))
        print("Filesystem.root_name(path) " .. Filesystem.root_name(p)) 
        print("Filesystem.root_directory(path) " .. Filesystem.root_directory(p)) 
        print("Filesystem.root_path(path) " .. Filesystem.root_path(p)) 
        print("Filesystem.relative_path(path) " .. Filesystem.relative_path(p)) 
        print("Filesystem.parent_path(path) " .. Filesystem.parent_path(p)) 
        print("Filesystem.filename(path) " .. Filesystem.filename(p)) 
        print("Filesystem.stem(path) " .. Filesystem.stem(p)) 
        -- It is possible to use a shorthand.
        local fs = Filesystem
        print("Filesystem.preferred(path) " .. fs.preferred(p)) 
        print(dash_sep)
    end
end

-- There are many additional functions to create, modify and delete files and directories. 
-- Use these with caution and at your own risk. Refer to the manual for the full list of functions.