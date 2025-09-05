local fs = Filesystem
local kt = Kontakt

local inst = kt.script_executed_from_instrument
local version = tonumber(string.sub(kt.version, 1, 1))

if inst ~= nil then
    local inst_options = kt.get_instrument_options(inst * 128)
    local snap_path = ''

    -- 'factory_snapshot_path' actually returns USER snapshot path by mistake, which is good in our case
    -- but this is fixed in Kontakt 8, so we need to do it like this
    if version < 8  then
        snap_path = inst_options['factory_snapshot_path']
    else
        snap_path = inst_options['user_snapshot_path']
    end

    print(snap_path)

    local snaps = {}

    if fs.exists(snap_path) then
        for _, p in fs.recursive_directory(snap_path) do
            if fs.extension(p) == '.nksn' then
                print(p)
                table.insert(snaps, p)
            end
        end
    end

    for i, p in ipairs(snaps) do
        print('Resaving snapshot ' .. fs.stem(p) .. '...')

        kt.load_snapshot(0, p)
        kt.save_snapshot(0, p)
    end
else
    print('Instrument not recognized! Please drop this script onto an instrument loaded in Kontakt\'s rack.')
end