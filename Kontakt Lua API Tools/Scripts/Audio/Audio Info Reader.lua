local root_path = Filesystem.parent_path(Filesystem.parent_path(Kontakt.script_path))
package.path = root_path .. "/?.lua;" .. package.path

local kAudio = require("Modules.KAudio")
local kUtil = require("Modules.KUtil")
local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local current_path = kUser.framework_samples_path

local sample_paths_table = {}

sample_paths_table = kUtil.paths_to_table(current_path,".wav")
table.sort(sample_paths_table)

for k,v in pairs(sample_paths_table) do
	kAudio.read_audio_file(v)
end
