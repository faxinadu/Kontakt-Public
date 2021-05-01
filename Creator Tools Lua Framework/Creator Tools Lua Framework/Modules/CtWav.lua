----------------------------------------------------------------------------------------------------
-- Creator Tools LUA Wav
----------------------------------------------------------------------------------------------------
--
-- Library for simple audio reading, writing and analysing.
----
-- Copyright © 2014, Christoph "Youka" Spanknebel
----
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- Modified by Yaron Eshar and Mario Kurselj @ Native Instruments
----
-- Added the functions listed after the modify date, added ability to read all chunks, added parsing of smpl chunk, added ability to read more wave formats.
----
-- Modified: April 23, 2021
--
-- Reads or writes audio file in WAVE format with PCM integer samples.
-- 
-- Function 'create_context' requires 2 arguments: a filename and a mode, which can be "r" (read) or "w" (write).
-- A call returns one table with methods depending on the used mode.
-- On reading, following methods are callable:
--
-- - get_filename()
--
-- - get_mode()
--
-- - get_file_size()
--
-- - get_channels_number()
--
-- - get_sample_rate()
--
-- - get_byte_rate()
--
-- - get_block_align()
--
-- - get_bits_per_sample()
--
-- - get_samples_per_channel()
--
-- - get_sample_from_ms(ms)
--
-- - get_ms_from_sample(sample)
--
-- - get_min_max_amplitude()
--
-- - get_position()
--
-- - set_position(pos)
--
-- - get_samples_interlaced(n)
--
-- - get_samples(n)
-- 
-- September 30, 2020:
--
-- - get_min_amplitude()
--
-- - get_max_amplitude()
--
-- - get_chunk_list()
--
-- - get_chunk_size(chunk)
--
-- - get_chunk_position(chunk)
--
-- - get_manufacturer()
--
-- - get_product()
--
-- - get_sample_period()
--
-- - get_midi_root_note()
--
-- - get_midi_pitch_fraction()
--
-- - get_smpte_format()
--
-- - get_smpte_offset()
--
-- - get_loop_count()
--
-- - get_sampler_data_size()
--
-- - get_loop_cue()
--
-- - get_loop_type()
--
-- - get_loop_start()
--
-- - get_loop_end()
--
-- - get_loop_fraction()
--
-- - get_loop_times()
--
-- - get_loop_position(param)
--
-- On writing, following methods are callable:
--
-- - get_filename()
--
-- - get_mode()
--
-- - init(channels_number, sample_rate, bits_per_sample)
--
-- - write_samples_interlaced(samples)
--
-- - finish()
-- 
-- September 30, 2020
--
-- - write_smpl_chunk(sample_rate,midi_root,num_loops,loop_type,loop_start,loop_end)
-- 
--
-- (WAVE format: https://ccrma.stanford.edu/courses/422/projects/WaveFormat/)
--
--

wav = {
	create_context = function(filename, mode)
		-- Check function parameters
		if type(filename) ~= "string" or not (mode == "r" or mode == "w") then
			error("Invalid function parameters! Expected filename and mode \"r\" or \"w\".", 2)
		end

		-- Audio file handle
		local file = io.open(filename, mode == "r" and "rb" or "wb")
		if not file then
			error(string.format("Could not open file %q!", filename), 2)
		end

		-- Byte-string(unsigend integer,little endian)<->Lua-number converters
		local function bton(s)
			local bytes = {s:byte(1,#s)}
			local n, bytes_n = 0, #bytes
			for i = 0, bytes_n-1 do
				n = n + bytes[1+i] * 2^(i*8)
			end
			return n
		end

		local unpack = table.unpack or unpack	-- Lua 5.1 or 5.2 table unpacker

		local function ntob(n, len)
			local n, bytes = math.max(math.floor(n), 0), {}
			for i=1, len do
				bytes[i] = n % 256
				n = math.floor(n / 256)
			end
			return string.char(unpack(bytes))
		end

		-- Check for integer
		local function isint(n)
			return type(n) == "number" and n == math.floor(n)
		end

		-- Initialize read process
		if mode == "r" then
			-- Audio meta information
			local header_size, format_bytes, file_size, channels_number, sample_rate, byte_rate, block_align, bits_per_sample, samples_per_channel

			-- Audio samples file area
			local data_begin, data_end, data_audio_size

			-- Audio samples smpl chunk
			local manufacturer, product, smp_period, midi_root, midi_pitch, smpte_format, smpte_offset, num_loops, sampler_data,loop_cue,loop_type,loop_start,loop_end,loop_fraction,loop_times

			local loop_count_position = 0
			local loop_cue_position
			local loop_type_position
			local loop_start_position
			local loop_fraction_position
			local loop_times_position 
			local loop_end_position

			-- Chunk checks

			local chunk_id_list = {}

			local chunk_size_header = 0
			local chunk_size_fmt = 0
			local chunk_size_fact = 0
			local chunk_size_wavl = 0
			local chunk_size_slnt = 0
			local chunk_size_cue = 0
			local chunk_size_plst = 0
			local chunk_size_list = 0
			local chunk_size_labl = 0
			local chunk_size_ltxt = 0
			local chunk_size_note = 0
			local chunk_size_inst = 0
			local chunk_size_data = 0
			local chunk_size_smpl = 0
			local chunk_size_extra = 0

			local chunk_position_fmt
			local chunk_position_fact
			local chunk_position_wavl
			local chunk_position_slnt
			local chunk_position_cue
			local chunk_position_plst
			local chunk_position_list
			local chunk_position_labl
			local chunk_position_ltxt
			local chunk_position_note
			local chunk_position_inst
			local chunk_position_data
			local chunk_position_smpl
			local chunk_position_extra

			-- Read file type
			if file:read(4) ~= "RIFF" then
				error("Not a RIFF file!", 2)
			end

			file_size = file:read(4)
			assert(file_size,"File header incomplete!")
			file_size = math.floor(bton(file_size) + 8)

			if file:read(4) ~= "WAVE" then
				error("Not a WAVE file!", 2)
			end

			-- Read file chunks
			local chunk_id, chunk_size

			while true do
				-- Read chunk header
				chunk_id, chunk_size = file:read(4), file:read(4)

				if not chunk_size then
					break
				end

				chunk_size = bton(chunk_size)

				table.insert(chunk_id_list,chunk_id)

				-- Identify chunk type
				if chunk_id == "fmt " then

					chunk_size_fmt = chunk_size
					chunk_position_fmt = file:seek()-8

					-- Read format information
					local bytes = file:read(2)

					format_bytes = math.floor(bton(bytes))
					
					bytes = file:read(2)
					assert(bytes, "Channel info not found!")
					channels_number = math.floor(bton(bytes))

					bytes = file:read(4)
					assert(bytes, "Sample rate info not found!")
					sample_rate = math.floor(bton(bytes))

					bytes = file:read(4)
					assert(bytes, "Average bytes per second info not found!")
					byte_rate = math.floor(bton(bytes))

					bytes = file:read(2)
					assert(bytes, "Block align info not found!")
					block_align = math.floor(bton(bytes))

					bytes = file:read(2)
					assert(bytes, "Bits per sample info not found!")
					bits_per_sample = math.floor(bton(bytes))

					if bits_per_sample ~= 8 and bits_per_sample ~= 16 and bits_per_sample ~= 24 and bits_per_sample ~= 32 then
						error("Bits per sample must be 8, 16, 24 or 32!", 2)
					end

					file:seek("cur", chunk_size-16)
				elseif chunk_id == "data" then

					chunk_size_data = chunk_size
					chunk_position_data = file:seek()-8

					assert(block_align, "Format information chunk must be defined before sample data!")

					samples_per_channel = math.floor(chunk_size / block_align)

					data_begin = file:seek()
					data_end = data_begin + chunk_size
					data_audio_size = data_end - data_begin

					local data_byte_check = chunk_size_data % 2

					if channels_number == 1 and data_byte_check ~= 0 then
						file:seek("cur", chunk_size + 1)
					else
						file:seek("cur", chunk_size)
					end

				elseif chunk_id == "smpl" then
				
					chunk_size_smpl = chunk_size
					chunk_position_smpl = file:seek()-8

					-- Read sample chunk information
					local bytes = file:read(4)

					assert(bytes, "Manufacturer info not found!")
					manufacturer = math.floor(bton(bytes))

					bytes = file:read(4)
					assert(bytes, "Product info not found!")
					product = math.floor(bton(bytes))

					bytes = file:read(4)
					assert(bytes, "Sample period info not found!")
					sample_period = math.floor(bton(bytes))

					bytes = file:read(4)
					assert(bytes, "MIDI root note info not found!")
					midi_root = math.floor(bton(bytes))

					bytes = file:read(4)
					assert(bytes, "MIDI pitch fraction info not found!")
					midi_pitch = bton(bytes)

					bytes = file:read(4)
					assert(bytes, "SMPTE format info not found!")
					smpte_format = math.floor(bton(bytes))

					bytes = file:read(4)
					assert(bytes, "SMPTE offset info not found!")
					smpte_offset = math.floor(bton(bytes))

					loop_count_position = file:seek()

					bytes = file:read(4)
					assert(bytes, "Loop count info not found!")
					num_loops = math.floor(bton(bytes))

					bytes = file:read(4)
					assert(bytes, "Sampler loop data info not found!")
					sampler_data = math.floor(bton(bytes))

					if num_loops > 0 then
						for i = 1,num_loops,1 do
							loop_cue = {}
							loop_type = {}
							loop_start = {}
							loop_end = {}
							loop_fraction = {}
							loop_times = {}

							loop_cue_position = {}
							loop_type_position = {}
							loop_start_position = {}
							loop_end_position = {}
							loop_fraction_position = {}
							loop_times_position = {}
							
							table.insert(loop_cue_position, file:seek())

							bytes = file:read(4)
							assert(bytes, "Loop Cue not found!")
							table.insert(loop_cue, math.floor(bton(bytes)))
							table.insert(loop_type_position,file:seek())

							bytes = file:read(4)
							assert(bytes, "Loop Type not found!")
							table.insert(loop_type, math.floor(bton(bytes)))
							table.insert(loop_start_position, file:seek())

							bytes = file:read(4)
							assert(bytes, "Loop Start not found!")
							table.insert(loop_start, math.floor(bton(bytes)))
							table.insert(loop_end_position, file:seek())

							bytes = file:read(4)
							assert(bytes, "Loop End not found!")
							table.insert(loop_end, math.floor(bton(bytes)))
							table.insert(loop_fraction_position,file:seek())

							bytes = file:read(4)
							assert(bytes, "Loop Fraction not found!")
							table.insert(loop_fraction, math.floor(bton(bytes)))
							table.insert(loop_times_position,file:seek())

							bytes = file:read(4)
							assert(bytes, "Loop Times not found!")
							table.insert(loop_times, math.floor(bton(bytes)))
						end
					end

					-- break -- we will not be reading any other chunks after this one
				elseif chunk_id == "fact" then
					chunk_size_fact = chunk_size
					chunk_position_fact = file:seek()-8
					file:seek("cur", chunk_size)
				elseif chunk_id == "wavl" then
					chunk_size_wavl = chunk_size
					chunk_position_wavl = file:seek()-8
					file:seek("cur", chunk_size)
				elseif chunk_id == "slnt" then
					chunk_size_slnt = chunk_size
					chunk_position_slnt = file:seek()-8
					file:seek("cur", chunk_size)
				elseif chunk_id == "cue " then
					chunk_size_cue = chunk_size
					chunk_position_cue = file:seek()-8
					file:seek("cur", chunk_size)
				elseif chunk_id == "plst" then
					chunk_size_plst = chunk_size
					chunk_position_plst = file:seek()-8
					file:seek("cur", chunk_size)
				elseif chunk_id == "list" then
					chunk_size_list = chunk_size
					chunk_position_list = file:seek()-8
					file:seek("cur", chunk_size)
				elseif chunk_id == "labl" then
					chunk_size_labl = chunk_size
					chunk_position_labl = file:seek()-8
					file:seek("cur", chunk_size)
				elseif chunk_id == "ltxt" then
					chunk_size_ltxt = chunk_size
					chunk_position_ltxt = file:seek()-8
					file:seek("cur", chunk_size)
				elseif chunk_id == "note" then
					chunk_size_note = chunk_size
					chunk_position_note = file:seek()-8
					file:seek("cur", chunk_size)
				elseif chunk_id == "inst" then
					chunk_size_inst = chunk_size
					chunk_position_inst = file:seek()-8
					file:seek("cur", chunk_size)
				else
					-- Skip chunk
					chunk_size_extra = chunk_size_extra + chunk_size
					file:seek("cur", chunk_size)
					-- break -- we will nott be reading any other chunks after this one
				end
			end

			-- Enough information available?
			assert(bits_per_sample, "No format information found!")

			-- Return audio handler
			local obj
			obj = {
				get_filename = function()
					return filename
				end,
				get_mode = function()
					return mode
				end,
				get_wave_format = function()
					local format_type
					if format_bytes == 1 then 
						format_type = "PCM"
					elseif format_bytes == 3 then 
						format_type = "IEE Float"
					elseif format_bytes == 65534 then
						format_type = "Extensible"
					else
						format_type = "Unknown"
					end
					return format_type
				end,
				get_file_size = function()
					return file_size
				end,
				get_chunk_list = function()
					return chunk_id_list
				end,
				get_chunk_size = function(chunk)
					if chunk =="header" then
						chunk_size_header = file_size - chunk_size_fact - chunk_size_wavl - chunk_size_slnt - chunk_size_cue - chunk_size_plst - chunk_size_list - chunk_size_labl - chunk_size_ltxt - chunk_size_note - chunk_size_inst - chunk_size_data - chunk_size_fmt - chunk_size_smpl- chunk_size_extra
						return chunk_size_header
					elseif chunk == "cue" then
						return  chunk_size_cue
					elseif chunk == "wavl" then
						return  chunk_size_wavl
					elseif chunk == "slnt" then
						return  chunk_size_slnt
					elseif chunk == "plst" then
						return  chunk_size_plst
					elseif chunk == "list" then
						return  chunk_size_list
					elseif chunk == "labl" then
						return  chunk_size_labl
					elseif chunk == "ltxt" then
						return  chunk_size_ltxt
					elseif chunk == "note" then
						return  chunk_size_note
					elseif chunk == "inst" then
						return  chunk_size_inst
					elseif chunk == "fact" then
						return  chunk_size_fact
					elseif chunk == "fmt" then
						return  chunk_size_fmt
					elseif chunk == "data" then
						return  chunk_size_data
					elseif chunk == "smpl" then
						return  chunk_size_smpl
					elseif chunk == "extra" then
						return  chunk_size_extra
					end
				end,
				get_chunk_position = function(chunk)				
					if chunk == "cue" then
						return  chunk_position_cue
					elseif chunk == "wavl" then
						return  chunk_position_wavl
					elseif chunk == "slnt" then
						return  chunk_position_slnt
					elseif chunk == "plst" then
						return  chunk_position_plst
					elseif chunk == "list" then
						return  chunk_position_list
					elseif chunk == "labl" then
						return  chunk_position_labl
					elseif chunk == "ltxt" then
						return  chunk_position_ltxt
					elseif chunk == "note" then
						return  chunk_position_note
					elseif chunk == "inst" then
						return  chunk_position_inst
					elseif chunk == "fact" then
						return  chunk_position_fact
					elseif chunk == "fmt" then
						return  chunk_position_fmt
					elseif chunk == "data" then
						return  chunk_position_data
					elseif chunk == "smpl" then
						return  chunk_position_smpl
					elseif chunk == "extra" then
						return  chunk_position_extra
					end
				end,
				get_channels_number = function()
					return channels_number
				end,
				get_sample_rate = function()
					return sample_rate
				end,
				get_byte_rate = function()
					return byte_rate
				end,
				get_block_align = function()
					return block_align
				end,
				get_bits_per_sample = function()
					return bits_per_sample
				end,
				get_samples_per_channel = function()
					return samples_per_channel
				end,
				get_data_audio_size = function()
					return data_audio_size
				end,
				get_manufacturer = function()
					return manufacturer
				end,
				get_product = function()
					return product
				end,
				get_sample_period = function()
					return sample_period
				end,
				get_midi_root_note = function()
					return midi_root
				end,
				get_midi_pitch_fraction = function()
					return midi_pitch
				end,
				get_smpte_format = function()
					return smpte_format
				end,
				get_smpte_offset = function()
					return smpte_offset
				end,
				get_loop_count_position = function()
					return loop_count_position
				end,
				get_loop_count = function()
					return num_loops
				end,
				get_sampler_data_size = function()
					return sampler_data
				end,
				get_loop_position = function(param)
					if param == "cue" then return loop_cue_position end
					if param == "type" then return loop_type_position end
					if param == "start" then return loop_start_position end
					if param == "end" then return loop_end_position end
					if param == "fraction" then return loop_fraction_position end
					if param == "times" then return loop_times_position end
				end,
				get_loop_cue = function()
					return loop_cue
				end,
				get_loop_type = function()
					return loop_type
				end,
				get_loop_start = function()
					return loop_start
				end,
				get_loop_end = function()
					return loop_end
				end,
				get_loop_fraction = function()
					return loop_fraction
				end,
				get_loop_times = function()
					return loop_times
				end,
				get_sample_from_ms = function(ms)
					if not isint(ms) or ms < 0 then
						error("Positive integer expected!", 2)
					end
					return math.floor(ms * 0.001 * sample_rate)
				end,
				get_ms_from_sample = function(sample)
					if not isint(sample) or sample < 0 then
						error("Positive integer expected!", 2)
					end
					return sample / sample_rate * 1000
				end,
				get_min_max_amplitude = function()
					local half_level = 2^bits_per_sample / 2
					return -half_level, half_level - 1
				end,
				get_min_amplitude = function()
					local half_level = 2^bits_per_sample / 2
					return -half_level
				end,
				get_max_amplitude = function()
					local half_level = 2^bits_per_sample / 2
					return half_level - 1
				end,
				get_position = function()
					if not data_begin then
						error("No samples available!", 2)
					end
					return (file:seek() - data_begin) / block_align
				end,
				set_position = function(pos)
					if not isint(pos) or pos < 0 then
						error("Positive integer expected!", 2)
					elseif not data_begin then
						error("No samples available!", 2)
					elseif data_begin + pos * block_align > data_end then
						error("Tried to set position behind data end!", 2)
					end
					file:seek("set", data_begin + pos * block_align)
				end,
				get_samples_interlaced = function(n)
					if not isint(n) or n <= 0 then
						error("Positive integer greater than zero expected!", 2)
					elseif not data_begin then
						error("No samples available!", 2)
					elseif file:seek() + n * block_align > data_end then
						error("Tried to read over data end!", 2)
					end
					local bytes, sample, output = file:read(n * block_align), nil, {n = 0}
					local bytes_n = #bytes
					if bits_per_sample == 8 then
						for i=1, bytes_n, 1 do
							sample = bton(bytes:sub(i,i))
							output.n = output.n + 1
							output[output.n] = sample > 127 and sample - 256 or sample
						end
					elseif bits_per_sample == 16 then
						for i=1, bytes_n, 2 do
							sample = bton(bytes:sub(i,i+1))
							output.n = output.n + 1
							output[output.n] = sample > 32767 and sample - 65536 or sample
						end
					elseif bits_per_sample == 24 then
						for i=1, bytes_n, 3 do
							sample = bton(bytes:sub(i,i+2))
							output.n = output.n + 1
							output[output.n] = sample > 8388607 and sample - 16777216 or sample
						end
					else	-- if bits_per_sample == 32 then
						for i=1, bytes_n, 4 do
							sample = bton(bytes:sub(i,i+3))
							output.n = output.n + 1
							output[output.n] = sample > 2147483647 and sample - 4294967296 or sample
						end
					end
					return output
				end,
				get_samples = function(n)
					local success, samples = pcall(obj.get_samples_interlaced, n)

					assert(success, samples)
	
					local output, channel_samples = {n = channels_number}
					for c=1, output.n do
						channel_samples = {n = samples.n / channels_number}
						for s=1, channel_samples.n do
							channel_samples[s] = math.floor(samples[c + (s-1) * channels_number])
						end
						output[c] = channel_samples
					end
					return output
				end
			}
			return obj
		-- Initialize write process
		else
			-- Audio meta information
			local channels_number_private, bytes_per_sample

			-- Return audio handler
			return {
				get_filename = function()
					return filename
				end,
				get_mode = function()
					return mode
				end,
				init = function(channels_number, sample_rate, bits_per_sample)
					-- Check function parameters
					if not isint(channels_number) or channels_number < 1 or
						not isint(sample_rate) or sample_rate < 2 or
						not (bits_per_sample == 8 or bits_per_sample == 16 or bits_per_sample == 24 or bits_per_sample == 32) then
						error("Valid channel count, sample rate and bits per sample expected!", 2)
					-- Already finished?
					elseif not file then
						error("Already finished!", 2)
					-- Already initialized?
					elseif file:seek() > 0 then
						error("Already initialized!", 2)
					end
					-- Write file type
					file:write("RIFF????WAVE")	-- file size to insert later
					-- Write format chunk
					file:write("fmt ",
								ntob(16, 4),
								ntob(1, 2),
								ntob(channels_number, 2),
								ntob(sample_rate, 4),
								ntob(sample_rate * channels_number * (bits_per_sample / 8), 4),
								ntob(channels_number * (bits_per_sample / 8), 2),
								ntob(bits_per_sample, 2))

					-- Write data chunk (so far)
					file:write("data????")	-- data size to insert later

					-- Set format memory
					channels_number_private, bytes_per_sample = channels_number, bits_per_sample / 8
				end,
				write_samples_interlaced = function(samples)
					-- Check function parameters
					if type(samples) ~= "table" then
						error("Samples table expected!", 2)
					end
					local samples_n = #samples
					if samples_n == 0 or samples_n % channels_number_private ~= 0 then
						error("Valid number of samples expected (multiple of channels)!", 2)
					-- Already finished?
					elseif not file then
						error("Already finished!", 2)
					-- Already initialized?
					elseif file:seek() == 0 then
						error("Initialize before writing samples!", 2)
					end
					-- All samples are numbers?
					for i=1, samples_n do
						if type(samples[i]) ~= "number" then
							error("Samples have to be numbers!", 2)
						end
					end
					-- Write samples to file
					local sample
					if bytes_per_sample == 1 then
						for i=1, samples_n do
							sample = samples[i]
							file:write(ntob(sample < 0 and sample + 256 or sample, 1))
						end
					elseif bytes_per_sample == 2 then
						for i=1, samples_n do
							sample = samples[i]
							file:write(ntob(sample < 0 and sample + 65536 or sample, 2))
						end
					elseif bytes_per_sample == 3 then
						for i=1, samples_n do
							sample = samples[i]
							file:write(ntob(sample < 0 and sample + 16777216 or sample, 3))
						end
					else	-- if bytes_per_sample == 4 then
						for i=1, samples_n do
							sample = samples[i]
							file:write(ntob(sample < 0 and sample + 4294967296 or sample, 4))
						end
					end

					-- Get data size
					local data_size = file:seek()
					-- Save data size
					file:seek("set", 40)
					file:write(ntob(data_size - 44, 4))
				end,
				write_smpl_chunk = function(manufacturer,product,srate,mroot,mpitch,smptef,smpteo,lnum,sdata,lcue,ltype,lstart,lend,lfraction,ltimes)
					file:seek("end")
					file:write("smpl",
						ntob(60,4), --chunk size
						ntob(manufacturer,4), --manufacturer
						ntob(product,4), --product
						ntob(string.sub(tostring(1/srate),0,6):gsub("%.",""),4), -- sample period
						ntob(mroot,4), -- midi root
						ntob(mpitch,4), -- midi pitch
						ntob(smptef,4), -- SMPTE format
						ntob(smpteo,4), -- SMPTE offset
						ntob(lnum,4), -- num loops
						ntob(sdata,4), -- sampler data
						ntob(lcue,4), -- loop cue
						ntob(ltype,4), -- loop type
						ntob(lstart,4), -- loop start
						ntob(lend,4), -- loop end
						ntob(lfraction,4), -- loop fraction
						ntob(ltimes,4)) -- loop times
				end,
				finish = function()
					-- Already finished?
					if not file then
						error("Already finished!", 2)
					-- Already initialized?
					elseif file:seek() == 0 then
						error("Initialize before finishing!", 2)
					end

					local file_size = file:seek()
					-- Save file size
					file:seek("set", 4)
					file:write(ntob(file_size - 8, 4))

					-- Finalize file for secure reading
					file:close()
					file = nil
				end
			}
		end
	end,
	--[[
		Analyses frequencies of audio samples.

		Function 'create_frequency_analyzer' requires 2 arguments: a table with audio samples and the relating sample rate.
		A call returns one table with following methods:
		- get_frequencies()
		- get_frequency_weight(freq)
		- get_frequency_range_weight(freq_min, freq_max)

		(FFT: http://www.relisoft.com/science/physics/fft.html)
	]]
	create_frequency_analyzer = function(samples, sample_rate)
		-- Check function parameters
		if type(samples) ~= "table" or
			type(sample_rate) ~= "number" or sample_rate ~= math.floor(sample_rate) or sample_rate < 2 then
			error("Table of samples and sample rate expected!", 2)
		end
		local samples_n = #samples
		if samples_n ~= math.ceil_pow2(samples_n) then
			error("Table size has to be a power of two!", 2)
		end
		for _, sample in ipairs(samples) do
			if type(sample) ~= "number" then
				error("Table must only contain numbers!", 2)
			elseif sample > 1 or sample < -1 then
				error("Numbers should be contained within the range [-1 ... 1]!", 2)
			end
		end
		-- Complex numbers
		local complex_t
		do
			local complex = {}
			local function tocomplex(a, b)
				if getmetatable(b) ~= complex then return a, {r = b, i = 0}
				elseif getmetatable(a) ~= complex then return {r = a, i = 0}, b
				else return a, b end
			end
			complex.__add = function(a, b)
				local c1, c2 = tocomplex(a, b)
				return setmetatable({r = c1.r + c2.r, i = c1.i + c2.i}, complex)
			end
			complex.__sub = function(a, b)
				local c1, c2 = tocomplex(a, b)
				return setmetatable({r = c1.r - c2.r, i = c1.i - c2.i}, complex)
			end
			complex.__mul = function(a, b)
				local c1, c2 = tocomplex(a, b)
				return setmetatable({r = c1.r * c2.r - c1.i * c2.i, i = c1.r * c2.i + c1.i * c2.r}, complex)
			end
			complex.__index = complex
			complex_t = function(r, i)
				return setmetatable({r = r, i = i}, complex)
			end
		end
		local function polar(theta)
			return complex_t(math.cos(theta), math.sin(theta))
		end
		local function magnitude(c)
			return math.sqrt(c.r^2 + c.i^2)
		end
		-- Fast Fourier Transform
		local function fft(x)
			-- Check recursion break
			local N = x.n
			if N > 1 then
				-- Divide
				local even, odd = {n = 0}, {n = 0}
				for i=1, N, 2 do
					even.n = even.n + 1
					even[even.n] = x[i]
				end
				for i=2, N, 2 do
					odd.n = odd.n + 1
					odd[odd.n] = x[i]
				end
				-- Conquer
				fft(even)
				fft(odd)
				--Combine
				local t
				for k = 1, N/2 do
					t = polar(-2 * math.pi * (k-1) / N) * odd[k]
					x[k] = even[k] + t
					x[k+N/2] = even[k] - t
				end
			end
		end
		-- Numbers to complex numbers
		local data = {n = samples_n}
		for i = 1, data.n do
			data[i] = complex_t(samples[i], 0)
		end
		-- Process FFT
		fft(data)
		-- Complex numbers to numbers
		for i = 1, data.n do
			data[i] = magnitude(data[i])
		end
		-- Calculate ordered frequencies
		local frequencies, frequency_sum, sample_rate_half = {n = data.n / 2}, 0, sample_rate / 2
		for i=1, frequencies.n do
			frequency_sum = frequency_sum + data[i]
		end
		if frequency_sum > 0 then
			for i=1, frequencies.n do
				frequencies[i] = {freq = (i-1) / (frequencies.n-1) * sample_rate_half, weight = data[i] / frequency_sum}
			end
		else
			frequencies[1] = {freq = 0, weight = 1}
			for i=2, frequencies.n do
				frequencies[i] = {freq = (i-1) / (frequencies.n-1) * sample_rate_half, weight = 0}
			end
		end
		-- Return frequencies getter
		return {
			get_frequencies = function()
				local out = {n = frequencies.n}
				for i=1, frequencies.n do
					out[i] = {freq = frequencies[i].freq, weight = frequencies[i].weight}
				end
				return out
			end,
			get_frequency_weight = function(freq)
				if type(freq) ~= "number" or freq < 0 or freq > sample_rate_half then
					error("Valid frequency expected!", 2)
				end
				for i, frequency in ipairs(frequencies) do
					if frequency.freq == freq then
						return frequency.weight
					elseif frequency.freq > freq then
						local frequency_last = frequencies[i-1]
						return (freq - frequency_last.freq) / (frequency.freq - frequency_last.freq) * (frequency.weight - frequency_last.weight) + frequency_last.weight
					end
				end
			end,
			get_frequency_range_weight = function(freq_min, freq_max)
				if type(freq_min) ~= "number" or freq_min < 0 or freq_min > sample_rate_half or
					type(freq_max) ~= "number" or freq_max < 0 or freq_max > sample_rate_half or
					freq_min > freq_max then
					error("Valid frequencies expected!", 2)
				end
				local weight_sum = 0
				for _, frequency in ipairs(frequencies) do
					if frequency.freq >= freq_min and frequency.freq <= freq_max then
						weight_sum = weight_sum + frequency.weight
					end
				end
				return weight_sum
			end
		}
	end
}

--[[
	Rounds up number to power of 2.
]]
function math.ceil_pow2(x)
	if type(x) ~= "number" then
		error("Number expected!", 2)
	end
	local p = 2
	while p < x do
		p = p * 2
	end
	return p
end

--[[
	Rounds down number to power of 2.
]]
function math.floor_pow2(x)
	if type(x) ~= "number" then
		error("Number expected!", 2)
	end
	local y = math.ceil_pow2(x)
	return x == y and x or y / 2
end

--[[
	Rounds number nearest to power of 2.
]]
function math.round_pow2(x)
	if type(x) ~= "number" then
		error("Number expected!", 2)
	end
	local min, max = math.floor_pow2(x), math.ceil_pow2(x)
	return (x - min) / (max-min) < 0.5 and min or max
end

--[[
	Converts samples into an ASS (Advanced Substation Alpha) subtitle shape code.
]]
function audio_to_ass(samples, wave_width, wave_height_scale, wave_thickness)
	-- Check function parameters
	if type(samples) ~= "table" or not samples[1] or
		type(wave_width) ~= "number" or wave_width <= 0 or
		type(wave_height_scale) ~= "number" or
		type(wave_thickness) ~= "number" or wave_thickness <= 0 then
		error("Table of samples, positive wave width, height scale and thickness expected!", 2)
	end
	for _, sample in ipairs(samples) do
		if type(sample) ~= "number" then
			error("Table must only contain numbers!", 2)
		end
	end
	-- Better fitting forms of known variables for most use
	local thick2, samples_n = wave_thickness / 2, #samples
	-- Build shape
	local shape = string.format("m 0 %d l", samples[1] * wave_height_scale - thick2)
	for i=2, samples_n do
		shape = string.format("%s %d %d", shape, (i-1) / (samples_n-1) * wave_width, samples[i] * wave_height_scale - thick2)
	end
	for i=samples_n, 1, -1 do
		shape = string.format("%s %d %d", shape, (i-1) / (samples_n-1) * wave_width, samples[i] * wave_height_scale + thick2)
	end
	return shape
end
