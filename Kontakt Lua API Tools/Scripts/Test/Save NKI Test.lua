local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output

local path = kUser.user_samples_path
local ksp_path = kUser.framework_ksp_path .. "envelope_and_filter_shell.ksp"

local verbose_mode = true

if not Filesystem.exists(Filesystem.join(Kontakt.script_path,"api_samples_wav")) then Filesystem.create_directory(Filesystem.join(Kontakt.script_path,"api_samples_wav")) end
if not Filesystem.exists(Filesystem.join(Kontakt.script_path,"api_samples_ncw")) then Filesystem.create_directory(Filesystem.join(Kontakt.script_path,"api_samples_ncw")) end

Kontakt.save_instrument(0,Filesystem.join(Kontakt.script_path,"my_api_with_patch.nki"))
Kontakt.save_instrument(0,Filesystem.join(Kontakt.script_path,"my_api_with_samples.nki"),
    {
        mode = 'samples',
        absolute_paths = false,
        compress_samples = false,
        samples_sub_dir = Filesystem.join(Kontakt.script_path,"api_samples_wav"),
    }
)
Kontakt.save_instrument(0,Filesystem.join(Kontakt.script_path,"my_api_with_samples_ncw.nki"),
    {
        mode = 'samples',
        absolute_paths = false,
        compress_samples = true,
        samples_sub_dir = Filesystem.join(Kontakt.script_path,"api_samples_ncw"),
    }
)
Kontakt.save_instrument(0,Filesystem.join(Kontakt.script_path,"my_api_with_samples_monolith.nki"),
    {
        mode = 'monolith',
        compress_samples = false
    }
)
Kontakt.save_instrument(0,Filesystem.join(Kontakt.script_path,"my_api_with_samples_monolith_ncw.nki"),
    {
        mode = 'monolith',
        compress_samples = true
    }
)