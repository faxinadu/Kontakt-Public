--[[ 
Filesystem Returns Test
Author: Native Instruments
Written by: Yaron Eshkar
Modified: May 04, 2022
--]]

local path = filesystem.preferred("/Users/yaron.eshkar/Faxi/Repositories/CT Lua/Kontakt-Public/Creator Tools Lua Framework/Creator Tools Lua Framework/NKI/Tests/Same Sample Name/Same Sample Name Samples/d/Melodic Loop  2.wav")

print("filesystem.native(path) " .. filesystem.native(path))
print("filesystem.rootName(path) " .. filesystem.rootName(path)) 
print("filesystem.rootDirectory(path) " .. filesystem.rootDirectory(path)) 
print("filesystem.rootPath(path) " .. filesystem.rootPath(path)) 
print("filesystem.relativePath(path) " .. filesystem.relativePath(path)) 
print("filesystem.parentPath(path) " .. filesystem.parentPath(path)) 
print("filesystem.filename(path) " .. filesystem.filename(path)) 
print("filesystem.stem(path) " .. filesystem.stem(path)) 
print("filesystem.extension(path) " .. filesystem.extension(path)) 
print("filesystem.preferred(path) " .. filesystem.preferred(path)) 