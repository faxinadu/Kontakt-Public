----------------------------------------------------------------------------------------------------
-- Creator Tools LUA SoX Utilities File 
----------------------------------------------------------------------------------------------------
-- Author: Native Instruments
-- Written by: Yaron Eshkar
-- Modified: June 11, 2021
--
-- This file includes useful functions for usage in Creator Tools Lua scripts.
-- Simply include this line in any script (if running a script from another location that users this file,
-- make sure to point to the correct path):
-- local ctSox = require("CtSox")
-- Then you can simply call any function like:
-- ctSox.test_function()
--
-- It is also possible of course to copy entire specific functions from this list directly into your script. 
-- In that case remove the CtAudio part from the function name, and then simply call it normally like:
-- test_function()
--

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

dofile(root_path .. filesystem.preferred("/Modules/CtWav.lua"))
local ctFile = require("Modules.CtFile")
local ctMir = require("Modules.CtMir")
local ctUtil = require("Modules.CtUtil")

local libsox = require("libsox")
local sox = libsox:new()

local CtSox = {}

--- Test Function.
-- Takes no arguments, prints to console when called.
function CtSox.test_function()
	-- Show that the class import and test function executes by printing a line.
	print("Test function called")
end

function CtSox.sox_process(input_file,output_file,process,num_params,params,verbose_mode)
    if verbose_mode == nil then verbose_mode = true end
    if verbose_mode then print("----------SoX Audio Process----------") end

    if output_file == nil then output_file = scriptPath..filesystem.preferred("/temp.wav") end

    local input = sox:open_read(input_file)
    local output = sox:open_write(output_file,input,"wav")
    
    local chain = sox:create_effects_chain(input,output)
    local effect

    effect = sox:create_effect(sox:find_effect("input"))
    sox:effect_options(effect,1,input)
    sox:add_effect(chain,effect,input,input)
 
    effect = sox:create_effect(sox:find_effect(process))
    sox:effect_options(effect,num_params,params)
    sox:add_effect(chain,effect,input,input)

    effect = sox:create_effect(sox:find_effect("output"))
    sox:effect_options(effect,1,output)
    sox:add_effect(chain,effect,input,input)

    sox:flow_effects(chain)

    sox:delete_effects_chain(chain)
    sox:close(input)
    sox:close(output)

    if verbose_mode then print("Performed " .. "\"" .. process .. " "  .. "\"" .. " on " .. input_file) end
end

function CtSox.sox_levels(file)
    local input = sox:open_read(file)
    return sox:get_levels(input,32768)
end

function CtSox.sox_encoding(file)
    local input = sox:open_read(file)
    return sox:encoding(input)
end

function CtSox.sox_signal(file)
    local input = sox:open_read(file)
    return sox:signal(input)
end

function CtSox.sox_version()
    return sox:version()
end

function CtSox.sox_convert_encoder(input_file,output_file,encoder,verbose_mode)
    if verbose_mode == nil then verbose_mode = true end
    if verbose_mode then print("----------SoX Audio Process----------") end

    if output_file == nil then output_file = filesystem.replaceExtension(input_file,encoder) end

    local input = sox:open_read(input_file)
    local output = sox:open_write(output_file,input,encoder)
    local chain = sox:create_effects_chain(input,output)
    local effect

    effect = sox:create_effect(sox:find_effect("input"))
    sox:effect_options(effect,1,input)
    sox:add_effect(chain,effect,input,input)

    effect = sox:create_effect(sox:find_effect("output"))
    sox:effect_options(effect,1,output)
    sox:add_effect(chain,effect,input,input)

    sox:flow_effects(chain)

    sox:delete_effects_chain(chain)
    sox:close(input)
    sox:close(output)

    if verbose_mode then print("Performed covert to " .. "\"" .. encoder .. " "  .. "\"" .. " on " .. input_file) end
end

function CtSox.sox_convert_samplerate(input_file,output_file,encoder,sample_rate,verbose_mode)
    if verbose_mode == nil then verbose_mode = true end
    if verbose_mode then print("----------SoX Audio Process----------") end

    print(encoder)
    print(sample_rate)

    if sample_rate == nil then sample_rate = 44100 end
    if encoder == nil then encoder = "wav" end
    if output_file == nil then output_file = filesystem.replaceExtension(input_file,encoder) end

    local input = sox:open_read(input_file)
    local in_signal = sox:signal(input)
    
    local output = sox:open_write(output_file,{rate=sample_rate,channels=2,precision=16},encoder)
    
    local out_signal = sox:signal(output)
    
    local chain = sox:create_effects_chain(input, output)
    local effect

    local interm_signal = input  -- NB: deep copy
    
    effect = sox:create_effect(sox:find_effect("input"))
    sox:effect_options(effect,1,input)
    sox:add_effect(chain,effect,input, input)
    
    effect = sox:create_effect(sox:find_effect("rate"))
    sox:effect_options(effect,1,sample_rate)
    sox:add_effect(chain,effect,interm_signal,input)
    
    effect = sox:create_effect(sox:find_effect("output"))
    sox:effect_options(effect,1,output)
    sox:add_effect(chain,effect,input,input)
    
    sox:flow_effects(chain)
    
    sox:delete_effects_chain(chain)
    sox:close(input)
    sox:close(output)
end


function CtSox.sox_synth()
    if verbose_mode == nil then verbose_mode = true end
    if verbose_mode then print("----------SoX Audio Process----------") end

    if temp_file == nil then temp_file = scriptPath .. filesystem.preferred("/synth.wav") end

    local input = "n"
    local output = sox:open_write(temp_file,{rate=8000,channels=1,precision=32},"wav")
    
    local chain = sox:create_effects_chain(output,output)
    local effect

    effect = sox:create_effect(sox:find_effect("synth"))
    sox:effect_options(effect,2,"1 noise")
    sox:add_effect(chain,effect,input,input)

    effect = sox:create_effect(sox:find_effect("output"))
    sox:effect_options(effect,1,output)
    sox:add_effect(chain,effect,input,input)

    sox:flow_effects(chain)

    sox:delete_effects_chain(chain)
    sox:close(input)
    sox:close(output)
end

function CtSox.sox_spectrum(input_file,play_live,soundcard,verbose_mode)
    
    local block_period = 0.025 --default reading periods
    local start_secs   = 0.0   --second to start

    if play_live and soundcard == nil then soundcard = "coreaudio" end

    local spectrum_return = ""

    --Open audiofile
    local input = sox:open_read(input_file)
    if not input then error("Failed to open input handler") end
    local signal = sox:signal(input)

    --Open soundcard
    local output
    if play_live then
        output = sox:open_write('default',signal,soundcard)
        if not output then error("Failed to open output handler") end
    end
    -- By default, if the period is not passed, it is set to the total time of the audio.
    local period = math.modf(signal.length / math.max(signal.channels, 1) / math.max(signal.rate, 1))
    --Calculate the start position in number of samples:
    seek = (start_secs * signal.rate * signal.channels + 0.5)
    --Make sure that this is at a `wide sample' boundary:
    seek = seek - seek % signal.channels
    --Move the file pointer to the desired starting position
    sox:seek(input,seek)
    --Convert block size (in seconds) to a number of samples:
    block_size = (block_period * signal.rate * signal.channels + 0.5)
    --Make sure that this is at a `wide sample' boundary:
    block_size = (block_size - block_size % signal.channels)
    --Allocate a block of memory to store the block of audio samples:
    local buffer = sox:buffer(block_size)

    --whrite vumeter
    function line(n)
        local LINE = "==================================="
        return (LINE):gsub("=", "", math.modf(n))
    end

    --Main loop
    local stdout,blocks = nil , 0
    while ((blocks * block_period) <= period) do
        local sz = sox:read(input, buffer, block_size)
        if sz == 0 then break end
        local right,left = sox:get_levels(buffer,sz)
        
        if play_live then sox:write(output, buffer, sz) end

        --[[
        stdout = ("%8.3f%36s|%s\n"):format(
            (start_secs + blocks * block_period),
            line(left), line(right)
        )
        --]]

        stdout = ("%36s|%s\n"):format(
            line(left), line(right)
        )

        spectrum_return = spectrum_return .. stdout
        if verbose_mode then print(stdout) end
        blocks = blocks + 1
    end

    --exit
    sox:close(input)
    if play_live then sox:close(output) end
    return spectrum_return
end

-- return the CtSox object.
return CtSox