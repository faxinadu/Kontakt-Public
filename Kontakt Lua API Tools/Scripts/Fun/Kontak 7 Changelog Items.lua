
file_path = Filesystem.preferred(Kontakt.script_path .. "/changelog_alltime.txt")

local function read_file_to_string(file)
    local f = assert(io.open(file,r))
    local content = f:read("*all")
    f:close()
    return content
end

local file_string = read_file_to_string(file_path)

local added_count = 0
local improved_count = 0
local fixed_count = 0
local changed_count = 0
local removed_count = 0

local added_ksp_count = 0
local improved_ksp_count = 0
local fixed_ksp_count = 0

local i = 0

while true do
  i = string.find(file_string, "ADDED", i+1)
  if i == nil then break end
  added_count = added_count + 1
end

i = 0
while true do
  i = string.find(file_string, "IMPROVED", i+1)
  if i == nil then break end
  improved_count = improved_count + 1
end

i = 0
while true do
  i = string.find(file_string, "FIXED", i+1)
  if i == nil then break end
  fixed_count = fixed_count + 1
end

i = 0
while true do
  i = string.find(file_string, "CHANGED", i+1)
  if i == nil then break end
  changed_count = changed_count + 1
end


i = 0
while true do
  i = string.find(file_string, "REMOVED", i+1)
  if i == nil then break end
  removed_count = removed_count + 1
end

local total_count = added_count + improved_count + fixed_count + changed_count + removed_count

print("-----------------------------------------------------------------------")
print("-----------------------------------------------------------------------")
print("Kontakt changelog items between last Kontakt 6 and latest Kontakt 7")
print("-----------------------------------------------------------------------")
print("ADDED: " .. added_count)
print("IMPROVED: " .. improved_count)
print("FIXED: " .. fixed_count)
print("CHANGED: " .. changed_count)
print("REMOVED: " .. removed_count)
print("Total Items: " .. total_count)
print("-----------------------------------------------------------------------")
print("-----------------------------------------------------------------------")