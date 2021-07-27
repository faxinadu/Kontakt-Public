--[[ 
Find Best Loop Test
Author: Native Instruments
Written by: Yaron Eshkar
Modified: April 23, 2021
--]]

-- Imports

local root_path = filesystem.parentPath(scriptPath)
package.path = root_path .. "/?.lua;" .. package.path

dofile(root_path .. filesystem.preferred("/Modules/CtWav.lua"))
local ctAudio = require("Modules.CtAudio")
local ctFile = require("Modules.CtFile")
local ctInstrument = require("Modules.CtInstrument")
local ctUtil = require("Modules.CtUtil")

-----------------------USER VARIABLES--------------------------------

-- Path to the samples
local path = root_path .. filesystem.preferred("/Samples/")

local verbose_mode = true

local ksp_script_path = root_path .. filesystem.preferred("/KSP/ksp_script.ksp")

local loop_cross_fade = 0

-----------------------SCRIPT----------------------------------------

local sample_paths_table = {}

sample_paths_table = ctUtil.paths_to_table(path,".wav")
table.sort(sample_paths_table)

assert(#sample_paths_table>0, "No samples found in "..path)

if verbose_mode then 
	print("--------------------LUA Loop Points--------------------") 
	print("Analyzing "..#sample_paths_table.." files...")
	local min_time = #sample_paths_table * 1.0
	local max_time = #sample_paths_table * 1.5
	print("Working... this may take between "..min_time.." and "..max_time.." seconds")
end

local ct_loop_map = {}

instrument.groups:reset()

for index, file in pairs(sample_paths_table) do

	local g = Group()
	instrument.groups:add(g)

	local temp_table = {}
	local loop_start,loop_end = mir.findLoop(file)
	local loop_length = loop_end-loop_start
	table.insert(temp_table,filesystem.filename(file))
	table.insert(temp_table,loop_start)
	table.insert(temp_table,loop_end)
	table.insert(temp_table,loop_length)
	table.insert(ct_loop_map,temp_table)

	local z 

	z = Zone()
	g.zones:add(z)
	z.rootKey = 48
	z.keyRange.high = 72
	z.keyRange.low = 24
    z.loops[0].mode = 1
    z.loops[0].start = loop_start
    z.loops[0].length = loop_length
    z.file = file

end

-- Fix wrong group indexing annoyance.
instrument.groups:remove(0)

for i=1,#ct_loop_map do
	ctUtil.dash_sep_print(verbose_mode)
	print("CT loop points: "..ct_loop_map[i][1].." Loop start: "..ct_loop_map[i][2].." Loop end: "..ct_loop_map[i][3].." Loop length: "..ct_loop_map[i][4])
end

ctUtil.dash_sep_print(verbose_mode)
print("Appling KSP script: "..ksp_script_path)
ctFile.replace_line_in_file(ksp_script_path,14,'    @instrumentFramework := "Test Instrument"')
ctFile.replace_line_in_file(ksp_script_path,15,'    @instrumentTitle := "Find Best Loop Compare"')
ctFile.replace_line_in_file(ksp_script_path,31,'    declare const $frameworkType := 3')
local ksp_script_string = ctFile.read_file_to_string(ksp_script_path,"r")
ctInstrument.apply_script(ksp_script_string)