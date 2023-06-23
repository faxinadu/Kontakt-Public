local root_path = Filesystem.parent_path(Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path)))
package.path = root_path .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local download_folder = "/Users/yaron.eshkar/Downloads/"

local file_list = {
    "Bass.zip",
    "Synth.zip",
    "SFX.zip"
}

local url_list = {
    "https://drive.google.com/uc?export=download&id=1dFRCx340j5AfoiiUwPVcL7ImnTthyeRV",
    "https://drive.google.com/uc?export=download&id=1bdDIwut1KQj8BpF4VGplOObj7UiFm9js",
    "https://drive.google.com/uc?export=download&id=1ag5FpWfCGxL7vVCVCTrIUPQamzBMi9H1"
}

local parameters_table = {}
for line in io.lines(download_folder .. "params.nka") do
      table.insert(parameters_table,line)
end

print("Sample set: " .. parameters_table[2])
print("Source mode: " .. parameters_table[3])
print("Root key: " .. parameters_table[4])
print("Low key: " .. parameters_table[5])
print("High key: " .. parameters_table[6])

local url = url_list[tonumber(parameters_table[2])]
local file_location = download_folder .. file_list[tonumber(parameters_table[2])]

print("Sampleset URL: " .. url)

kUtil.open_url(url)

local clock = os.clock
local function sleep(n) -- seconds
    local t0 = clock()
    while clock() - t0 <= n do end
end
sleep(5)
while not Filesystem.exists(file_location) do
    print("Waiting for Download to finish...")
    sleep(2)
end

print("Download finished!")
print("Opening file: " .. file_location)
os.execute("open " .. file_location)

sleep(5)

local path = string.gsub(file_location,Filesystem.extension(file_location),"/")

paths_table = kUtil.paths_to_table(path)

local instrument = Kontakt.add_instrument()
Kontakt.set_instrument_name(instrument,Filesystem.stem(file_location))

for k,v in pairs(paths_table) do
    local zone = Kontakt.add_zone(instrument,0,v)
    Kontakt.set_zone_root_key(instrument,zone,tonumber(parameters_table[4]))
    Kontakt.set_zone_low_key(instrument,zone,tonumber(parameters_table[5]))
    Kontakt.set_zone_high_key(instrument,zone,tonumber(parameters_table[6]))
end

