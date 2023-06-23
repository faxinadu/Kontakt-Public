local root_path = Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path))
package.path = root_path .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local path = Filesystem.preferred(kUser.framework_samples_path .. "1.wav")

print("Kontakt Version: " .. Kontakt.version)
print("--------------------------------------------------------------------")
print("--------------------------------------------------------------------")
print("Filesystem.extension(path) " .. Filesystem.extension(path))
print("Filesystem.root_name(path) " .. Filesystem.root_name(path)) 
print("Filesystem.root_directory(path) " .. Filesystem.root_directory(path)) 
print("Filesystem.root_path(path) " .. Filesystem.root_path(path)) 
print("Filesystem.relative_path(path) " .. Filesystem.relative_path(path)) 
print("Filesystem.parent_path(path) " .. Filesystem.parent_path(path)) 
print("Filesystem.filename(path) " .. Filesystem.filename(path)) 
print("Filesystem.stem(path) " .. Filesystem.stem(path)) 
print("Filesystem.extension(path) " .. Filesystem.extension(path)) 
print("Filesystem.preferred(path) " .. Filesystem.preferred(path)) 
print("--------------------------------------------------------------------")
print("--------------------------------------------------------------------")
