
local clock = os.clock
function sleep(n)-- seconds
    local t0 = clock()
    while clock() - t0 <= n do end
end

for a = 1,3 do
    print("\n")
    print(mylist[a])
    print("\nPlease wait for 3 seconds\n")
    sleep(3)
end