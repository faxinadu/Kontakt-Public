----------------------------------------------------------------------------------------------------
-- Kontakt LUA Signet Utilities File 
----------------------------------------------------------------------------------------------------
-- This file includes useful functions for usage in Kontakt Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local kSignet = require("KSignet")

local root_path = Filesystem.parent_path(Kontakt.script_path)
package.path = root_path .. "/?.lua;" .. package.path

local kFile = require("Modules.KFile")
local kUtil = require("Modules.KUtil")
local kUser = require("Modules.KUser")

local signet_path = kUser.signet_path

local KSignet = {}

--- Tunes the file to the nearest detected musical pitch.
-- @tparam string file the source file to tune. 
function KSignet.auto_tune(file)
    local signet_command = "auto-tune"
    local execute_string = string.format([[%s "%s" %s]],signet_path,file,signet_command)
    os.execute(execute_string)
end

--- Converts the bit-depth.
-- @tparam string file the source file to change.
-- @tparam string target bit depth. 
function KSignet.convert_bd(file,bd)
    local signet_command = "convert bit-depth"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,bd)
    os.execute(execute_string)
end

--- Converts the file from Wav to Flac or the other way around.
-- @tparam string file the source file to change.
-- @tparam string target format. 
function KSignet.convert_format(file,format)
    local signet_command = "convert file-format"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,format)
    os.execute(execute_string)
end

--- Converts the sample-rate.
-- @tparam string file the source file to change.
-- @tparam string target sample-rate. 
function KSignet.convert_sr(file,sr)
    local signet_command = "convert sample-rate"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,sr)
    os.execute(execute_string)
end

--- Prints out the detected pitch of the file.
-- @tparam string file the source file to detect. 
function KSignet.detect_pitch(file)
    local signet_command = "detect-pitch"
    local execute_string = string.format([[%s "%s" %s]],signet_path,file,signet_command)
    os.execute(execute_string)
end

--- Fades in.
-- @tparam string file the source file to change.
-- @tparam string fade time. 
function KSignet.fade_in(file,fade)
    local signet_command = "fade in"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,fade)
    os.execute(execute_string)
end

--- Fade out.
-- @tparam string file the source file to change.. 
-- @tparam string fade time. 
function KSignet.fade_out(file,fade)
    local signet_command = "fade out"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,fade)
    os.execute(execute_string)
end

--- Automatically corrects regions of drifting pitch in the file.
-- @tparam string file the source file to tune. 
function KSignet.fix_pitch_drift(file)
    local signet_command = "fix-pitch-drift"
    local execute_string = string.format([[%s "%s" %s]],signet_path,file,signet_command)
    os.execute(execute_string)
end

--- Changes the volume of the file.
-- @tparam string file the source file to change.. 
-- @tparam string dB setting to gain. 
function KSignet.gain(file,gain)
    local signet_command = "gain"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,gain)
    os.execute(execute_string)
end

--- Removes frequencies below the given cutoff.
-- @tparam string file the source file to normalize. 
-- @tparam string the cutoff point where frequencies below this should be removed.
function KSignet.highpass(file,cutoff)
    local signet_command = "highpass"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,cutoff)
    os.execute(execute_string)
end

--- Removes frequencies above the given cutoff.
-- @tparam string file the source file to normalize. 
-- @tparam string the cutoff point where frequencies above this should be removed.
function KSignet.lowpass(file,cutoff)
    local signet_command = "lowpass"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,cutoff)
    os.execute(execute_string)
end

--- Normalize peaks of an audio file to set dB.
-- @tparam string file the source file to normalize. 
-- @tparam string dB setting to normalize to. 
function KSignet.normalize(file,norm_value)
    local signet_command = "norm"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,norm_value)
    os.execute(execute_string)
end

--- Changes the pan of stereo files. Does not work on non-stereo files.
-- @tparam string file the source file to pan. 
-- @tparam string the pan amount. This is a number from 0 to 100 followed by either L or R.
function KSignet.pan(file,pan)
    local signet_command = "pan"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,pan)
    os.execute(execute_string)
end

--- Prints information about the audio file, such as the embedded metadata, sample-rate and RMS.
-- @tparam string file the source file read.
function KSignet.print_info(file)
    local signet_command = "print-info"
    local execute_string = string.format([[%s "%s" %s]],signet_path,file,signet_command)
    os.execute(execute_string)
end

--- Removes silence from the start or end of the file. Silence is considered anything under -90dB. 
-- @tparam string file the source file to remove silence. 
-- @tparam string Specify whether the removal should be at the start(0), the end(1) or both(2).
function KSignet.remove_silence(file,start_or_end)
    local signet_command = "remove-silence"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,start_or_end)
    os.execute(execute_string)
end

--- Turns the file into a seamless loop.
-- @tparam string file the source file to process. 
-- @tparam string the size of the crossfade region as a percent of the whole file. 
function KSignet.seamless_loop(file,crossfade_percent)
    local signet_command = "seamless-loop"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,crossfade_percent)
    os.execute(execute_string)
end

--- Removes the end of the file. 
-- @tparam string file the source file to trim. 
-- @tparam string trim value. 
function KSignet.trim_end(file,trim)
    local signet_command = "trim end"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,trim)
    os.execute(execute_string)
end

--- Removes the start of the file. 
-- @tparam string file the source file to trim. 
-- @tparam string trim value. 
function KSignet.trim_start(file,trim)
    local signet_command = "trim start"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,trim)
    os.execute(execute_string)
end

--- Changes the tune of the file by stretching or shrinking them. Uses a high-quality resampling algorithm. 
-- Tuning up will result in audio that is shorter in duration, and tuning down will result in longer audio.
-- @tparam string file the source file to normalize. 
-- @tparam string cents to tune by. 
function KSignet.tune(file,cents)
    local signet_command = "tune"
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,cents)
    os.execute(execute_string)
end

--- Changes the tune of the file by stretching or shrinking them. Uses a high-quality resampling algorithm. 
-- Tuning up will result in audio that is shorter in duration, and tuning down will result in longer audio.
-- @tparam string file the source file to normalize. 
-- @tparam string cents to tune by. 
function KSignet.zcross_offset(file,search_size,append)
    if append == nil then append = true end
    local signet_command
    if append then signet_command = "zcross-offset --append" else signet_command = "zcross-offset" end
    local execute_string = string.format([[%s "%s" %s %s]],signet_path,file,signet_command,search_size)
    os.execute(execute_string)
end

-- return the KSignet object.
return KSignet