local root_path = Filesystem.parent_path(Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path)))
package.path = root_path .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUser = require("Modules.KUser")
local kUtil = require("Modules.KUtil")

Kontakt.colored_output = kUser.terminal_colored_output

local url = "https://faxinadu.net/star/xenomorph_-_the_silimaki_murder_toolkit_-_faxi_nadu_remix.mp3" 

kUtil.open_url(url)
