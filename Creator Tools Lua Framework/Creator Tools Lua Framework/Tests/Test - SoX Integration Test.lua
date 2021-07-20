--[[ 
SoX Integration Test
Author: Native Instruments
Written by: Yaron Eshkar
Modified: Jun 13, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

local ctUtil = require("Modules.CtUtil")
local ctFile = require("Modules.CtFile")
local ctSox = require("Modules.CtSox")

-- User Variables

-- Path to the samples
local current_path = root_path .. filesystem.preferred("/Samples/")

-- Verbose Mode
local verbose_mode = true

-- Tests to run
local run_tests = true
local run_spectrum = false
local run_effects_tests = false
local run_convert_tests = false
local run_sr_tests = true

-- Script
local sample_paths_table = ctUtil.paths_to_table(current_path,".wav")
table.sort(sample_paths_table)

if verbose_mode then print("SoX Version: " .. ctSox.sox_version()) end

local process_names = {
    "norm",
    "highpass",
    "lowpass",
    "reverse",
    "flanger",
    "phaser",
    "reverb",
    "treble",
    "bass",
    "trim",
    "tremolo",
    "gain",
    "bandreject",
    "bandpass",
    "overdrive",
    "pitch",
    "speed",
    "vol",
    "stretch",
    "fade",
    "bend",
    "contrast",
    "downsample",
    "upsample",
    "repeat",
    "sinc",
    "sinc",
    "sinc",
    "sinc",
    "delay"
}

local process_params = {
    "-3.0", -- norm
    "1500", -- highpass
    "400", -- lowpass
    nil, -- reverse
    "0.6 0.87 3.0 0.9 0.5 -s", -- flanger
    "0.6 0.66 3.0 0.6 2.0 -t", -- phaser
    "1.0 600.0 180.0 200.0 220.0 240.0", -- reverb
    "+7", -- treble
    "+3", -- bass
    "2", -- trim
    "10", -- tremolo
    "-12", -- gain
    "1600 20", -- bandreject
    "1600 20", -- bandpass
    "20.0 20.0", -- overdrive
    "-12", -- pitch 
    "1.5", -- speed
    "3dB", -- vol
    "2.0", -- stretch
    "5 -0 7", -- fade 
    "0.35 180.0 0.25", -- bend
    "75.0", -- contrast
    "4.0", -- downsample
    "4.0", -- upsample
    "3", -- repeat
    "3k", -- sinc
    "-4k", -- sinc
    "3k-4k", -- sinc
    "4k-3k", -- sinc
    "1.5", -- delay
}

local process_param_count = {
    1, -- norm
    1, -- highpass
    1, -- lowpass
    0, -- reverse
    6, -- flanger
    6, -- phaser
    6, -- reverb
    1, -- treble
    1, -- bass
    1, -- trim
    1, -- tremolo
    1, -- gain
    2, -- bandreject
    2, -- bandpass
    2, -- overdrive
    1, -- pitch
    1, -- speeed
    1, -- vol
    1, -- stretch
    3, -- fade
    3, -- bend
    1, -- contrast
    1, -- downsample
    1, -- upsample
    1, -- repeat
    1, -- sinc
    1, -- sinc
    1, -- sinc
    1, -- sinc
    1 -- delay
}

local process_formats = {
    "mp3",
    "ogg",
    "wav"
}

local process_sample_rates = {
    "48000",
    "44100",
    "22050"
}

for index, file in pairs(sample_paths_table) do
    if verbose_mode then
        print("Peak of: " .. mir.detectPeak(file) .. "dB detected")
        print("Loudness of: " .. mir.detectLoudness(file) .. "dB detected")
        print("RMS of: " .. mir.detectRMS(file) .. "dB detected")
        ctUtil.debug_print_r(ctSox.sox_signal(file))
    end

    --fails
   -- ctSox.sox_process(file,nil,"vibro",2,"30 1",true)
   -- works
   -- ctSox.sox_process(file,nil,"pitch",1,"-12",true)

    if run_tests then
        ctFile.create_directory(root_path .. "/Test Results")
        local directory_path = root_path .. "/Test Results/" .. os.date("%m-%d-%Y_%H-%M-%S") .. "_" .. filesystem.stem(file)
        ctFile.create_directory(directory_path)
        if run_spectrum then 
            local spectrum = ctSox.sox_spectrum(file,true,nil,verbose_mode)
            local output_file = directory_path .. "/" .. filesystem.stem(file) .. "_test_SPECTRUM" .. ".txt"
            ctFile.write_file(output_file,spectrum)
        end
        if run_effects_tests then
            for i = 1,#process_names, 1 do
                local output_file = directory_path .. "/" .. filesystem.stem(file) .. "_test_" .. process_names[i] .. ".wav"
                -- local output_file = filesystem.replaceExtension(file,"") .. "_test_" ..process_names[i] .. ".wav"
                ctSox.sox_process(file,output_file,process_names[i],process_param_count[i],process_params[i],verbose_mode)
            end
        end
        if run_convert_tests then
            for i = 1,#process_formats, 1 do
                local output_file = directory_path .. "/" .. filesystem.stem(file) .. "_format_test." .. process_formats[i]
                -- local output_file = filesystem.replaceExtension(file,"") .. "_fromat_test." .. process_formats[i]
                ctSox.sox_convert_encoder(file,output_file,process_formats[i],verbose_mode)
            end
        end
        if run_sr_tests then
            for i = 1,#process_sample_rates, 1 do
                local output_file = directory_path .. "/" .. filesystem.stem(file) .. "_sr_test_" .. process_sample_rates[i] .. ".wav"
                ctSox.sox_convert_samplerate(file,output_file,"wav",process_sample_rates[i],verbose_mode)
            end
        end
    end
end

--"/opt/homebrew/bin/sox" -r 44100 -n "/Users/yaron.eshkar/Faxi/ct-lua-framework/Kontakt-Public/Creator Tools Lua Framework/Creator Tools Lua Framework/Generated/Plucks/pluck_70.wav" synth 4 pluck %13

    -- works
    --ctSox.sox_process(file,nil,"norm",1,normalize_db,true)
    --ctSox.sox_process(file,nil,"highpass",1,filter_value,true)
    --ctSox.sox_process(file,nil,"lowpass",1,filter_value,true)
    --ctSox.sox_process(file,nil,"reverse",0,nil,true)
    --ctSox.sox_process(file,nil,"flanger",6,"0.6 0.87 3.0 0.9 0.5 -s",true)
    --ctSox.sox_process(file,nil,"phaser",6,"0.6 0.66 3.0 0.6 2.0 -t",true)
    --ctSox.sox_process(file,nil,"reverb",6,"1.0 600.0 180.0 200.0 220.0 240.0",true)
    --ctSox.sox_process(file,nil,"treble",1,"+7",true)
    --ctSox.sox_process(file,nil,"bass",1,"+3",true)
    --ctSox.sox_process(file,nil,"trim",1,"2",true)
    --ctSox.sox_process(file,nil,"tremolo",1,"10",true)
    --ctSox.sox_process(file,nil,"gain",1,-12,true)
    --ctSox.sox_process(file,nil,"bandreject",2,"1600 20",true)
    --ctSox.sox_process(file,nil,"bandpass",2,"1600 20",true)
    --ctSox.sox_process(file,nil,"overdrive",2,"20.0 20.0",true)
    --ctSox.sox_process(file,nil,"pitch",1,"-12",true)
    --ctSox.sox_process(file,nil,"speed",1,"1.5",true)
    --ctSox.sox_process(file,nil,"vol",1,"3dB",true)
    --ctSox.sox_process(file,nil,"stretch",1,"2.0",true)
    --ctSox.sox_process(file,nil,"fade",3,"5 -0 7",true)
    --ctSox.sox_process(file,nil,"bend",3,"0.35 180.0 0.25",true)
    --ctSox.sox_process(file,nil,"contrast",1,"75.0",true)
    --ctSox.sox_process(file,nil,"downsample",1,"4.0",true)
    --ctSox.sox_process(file,nil,"upsample",1,"4",true) 
    --ctSox.sox_process(file,nil,"repeat",1,"3",true)
    --ctSox.sox_process(file,nil,"sinc",1,"3k",true)
    --ctSox.sox_process(file,nil,"sinc",1,"-4k",true)
    --ctSox.sox_process(file,nil,"sinc",1,"3k-4k",true)   
    --ctSox.sox_process(file,nil,"sinc",1,"4k-3k",true)   
    --ctSox.sox_process(file,nil,"delay",1,"1.5",true) 
    --ctSox.sox_convert(file,nil,"mp3",true)
    --ctSox.sox_convert(file,nil,"ogg",true)
    --ctSox.sox_convert(file,nil,"wav",true)

        -- doesn't work
    --ctSox.sox_process(file,nil,"silence",1,"1",true)
    --ctSox.sox_process(file,nil,"vibro",2,"30 1",true)
    --ctSox.sox_process(file,nil,"echo",4,"0.8 0.9 1000.0 0.3",true)
    --ctSox.sox_process(file,nil,"echos",4,"0.8 0.9 1000.0 0.3",true))
    --ctSox.sox_process(file,nil,"echo",4,"1.0 0.5 5.0 0.5",true)
   --ctSox.sox_process(file,nil,"echos",4,"0.8 0.9 1000.0 0.3",true)
    --ctSox.sox_process(file,nil,"chorus",17,"0.5 0.9 50.0 0.4 0.25 2.0 -t 60.0 0.32 0.4 2.3 -t 40.0 0.3 0.3 1.3 -s",true)
    --ctSox.sox_process(file,nil,"chorus",7,"0.7 0.9 55.0 0.4 0.25 2.0 -t",true)
    --ctSox.sox_process(file,nil,"tremolo",2,"10 40",true)
    --ctSox.sox_process(file,nil,"pan",1,"-1.0",true)
    --ctSox.sox_process(file,nil,"lowp",1,"1600.0",true)
    --ctSox.sox_process(file,nil,"split",0,nil,true)
    --ctSox.sox_process(file,nil,"compand",5,"0.1,0.2 −inf,−50.1,−inf,−50.0,−50.0 0 −90.0 0.1",true)
    -- ctSox.sox_process(file,nil,"silence",0,nil,true)

    --ctSox.sox_synth(file,nil,"synth",6,"4 pluck %13",true)

    --ctSox.sox_process(file,nil,"compand",5,"0.3,1 -90,-90,-70,-70,-60,-20,0,0 -5 0 0.2",true)

   -- ctSox.sox_process(file,nil,"rate",1,"22050",true)
   --ctSox.sox_process(file,nil,"vibro",2,"20.0 0.5",true)