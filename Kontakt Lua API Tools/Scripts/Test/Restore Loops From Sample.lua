-- Add an instrument.
local instrument = Kontakt.add_instrument()

sample = Filesystem.preferred(Kontakt.script_path .. '/assets/1.wav')
zone = Kontakt.add_zone(instrument, 0, sample)

assert(Kontakt.get_sample_loop_mode(instrument, zone, 0) == 'until_end')

local orig_loop_start = Kontakt.get_sample_loop_start(instrument, zone, 0)
local orig_loop_length = Kontakt.get_sample_loop_length(instrument, zone, 0)

Kontakt.set_sample_loop_start(instrument, zone, 0, 25)
Kontakt.set_sample_loop_length(instrument, zone, 0, 50)

assert(Kontakt.get_sample_loop_start(instrument, zone, 0) == 25)
assert(Kontakt.get_sample_loop_length(instrument, zone, 0) == 50)

-- restore loops from sample
Kontakt.restore_loops_from_sample(instrument, zone)

assert(Kontakt.get_sample_loop_start(instrument, zone, 0) == orig_loop_start)
assert(Kontakt.get_sample_loop_length(instrument, zone, 0) == orig_loop_length)