----------------------------------------------------------------------------------------------------
-- Kontakt LUA User File 
----------------------------------------------------------------------------------------------------
-- This file includes useful functions for usage in Kontakt Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local kUser = require("KUser")
--

local KUser = {
	terminal_colored_output = false,
	player_content_path = Filesystem.preferred("/Users/Shared/"),
	user_content_path = Filesystem.preferred("/Users/yaron.eshkar/Faxi/Yaron QA Docs/Kontakt Instruments/"),
	user_samples_path = Filesystem.preferred("/Users/yaron.eshkar/Faxi/API Samples/"),
	framework_samples_path = "/Users/yaron.eshkar/Faxi/Repositories/Kontakt Lua API Framework/Samples",
	framework_ksp_path = Filesystem.preferred(Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path)) .. "/KSP/"),
	framework_nki_path = Filesystem.preferred(Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path)) .. "/NKI/"),
	user_name = os.getenv("USER") or "Kontakt User",
	default_nki_name = os.getenv("USER") or "Kontakt User",
	default_nkm_name = os.getenv("USER") or "Kontakt User",
	sox_path = "sox",
	signet_path = "'" .. "/Users/yaron.eshkar/Faxi/Repositories/Kontakt Lua API Framework/Tools/signet/signet" .. "'",
	flac_path = "flac"
}

-- return the object.
return KUser