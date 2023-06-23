local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = Filesystem.parent_path(root_path) .. "/?.lua;" .. package.path

local kUser = require("Modules.KUser")

Kontakt.colored_output = kUser.terminal_colored_output


Kontakt.save_group(0,0,Filesystem.join(Kontakt.script_path,"my_api_with_patch.nkg"))
Kontakt.save_group(0,0,Filesystem.join(Kontakt.script_path,"my_api_with_samples_wav.nkg"),{
    mode = 'samples',
    absolute_paths = false,
    compress_samples = false,
    samples_sub_dir = Filesystem.join(Kontakt.script_path,'samples_wav'),
  }
)

Kontakt.save_group(0,0,Filesystem.join(Kontakt.script_path,"my_api_with_samples_ncw.nkg"),{
    mode = 'samples',
    compress_samples = true,
    samples_sub_dir = Filesystem.join(Kontakt.script_path,'samples_ncw'),
  }
)

Kontakt.save_group(0,0,Filesystem.join(Kontakt.script_path,"my_api_with_monolith_wav.nkg"),{
    mode = 'monolith',
  }
)

Kontakt.save_group(0,0,Filesystem.join(Kontakt.script_path,"my_api_with_monolith_ncw.nkg"),{
    mode = 'monolith',
    compress_samples = true,
  }
)

Kontakt.reset_multi(0)
local instrument = Kontakt.add_instrument()
Kontakt.add_group(0)
Kontakt.add_group(0)
Kontakt.add_group(0)
Kontakt.add_group(0)

Kontakt.load_group(instrument,0,Filesystem.join(Kontakt.script_path,"my_api_with_patch.nkg"), {replace_zones = false})
Kontakt.load_group(instrument,1,Filesystem.join(Kontakt.script_path,"my_api_with_samples_wav.nkg"), {replace_zones = false})
Kontakt.load_group(instrument,2,Filesystem.join(Kontakt.script_path,"my_api_with_samples_ncw.nkg"), {replace_zones = false})
Kontakt.load_group(instrument,3,Filesystem.join(Kontakt.script_path,"my_api_with_monolith_wav.nkg"), {replace_zones = false})
Kontakt.load_group(instrument,4,Filesystem.join(Kontakt.script_path,"my_api_with_monolith_ncw.nkg"), {replace_zones = false})