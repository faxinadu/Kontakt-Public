local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.player_content_path

Kontakt.reset_multi(0)

local instrument = Kontakt.load_instrument(kUser.player_content_path .. "Straylight Library/Instruments/straylight.nki")

Kontakt.save_snapshot(0,"/Users/yaron.eshkar/Documents/Native Instruments/User Content/Straylight/straylight/snapshot A.nksn")
Kontakt.save_snapshot(0,"/Users/yaron.eshkar/Documents/Native Instruments/User Content/Straylight/straylight/snapshot B.nksn")
Kontakt.load_snapshot(0,"/Users/yaron.eshkar/Documents/Native Instruments/User Content/Straylight/straylight/snapshot A.nksn")
