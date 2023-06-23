local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

paths_table = kUtil.paths_to_table(kUser.user_samples_path,"DIR",true)
kUtil.print_r(paths_table)
paths_table = kUtil.paths_to_table(kUser.user_samples_path,".wav",true)
kUtil.print_r(paths_table)
paths_table = kUtil.paths_to_table(kUser.player_content_path,"KONTAKT",true)
kUtil.print_r(paths_table)
paths_table = kUtil.paths_to_table(kUser.user_samples_path,"AUDIO",true)
kUtil.print_r(paths_table)