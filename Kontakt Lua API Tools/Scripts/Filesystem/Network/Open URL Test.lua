local root_path = Filesystem.parent_path(Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path)))
package.path = root_path .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local url = "https://drive.google.com/uc?export=download&id=1z6dauKdSsO_dZdD0NXTVUw4SQn98vnUO" 

kUtil.open_url(url)
