local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

print("Terminal colored output:" , kUser.terminal_colored_output)
print("User is: " .. kUser.user_name)
print("Player content is located in: " .. kUser.player_content_path)
print("User content is located in: " .. kUser.user_content_path)
print("User samples are located in: " .. kUser.user_samples_path)
print("Default NKI name is: " .. kUser.default_nki_name)
print("Default NKM name is: " .. kUser.default_nkm_name)
print("Framework samples are located in: " .. kUser.framework_samples_path)
print("Framework KSP path is: " .. kUser.signet_path)
print("SoX path is: " .. kUser.sox_path)
print("Signet path is: " .. kUser.signet_path)
