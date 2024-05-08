#!/usr/bin/env python3

import os

import numpy as np
from osc_gen import visualize
from osc_gen import wavetable
from osc_gen import wavfile
from osc_gen import zosc
from osc_gen import sig
from osc_gen import dsp

STORE_FILES = True
SHOW_PLOTS = True

def make_osc_path():

    home = '.'
    osc_path = 'example_files'
    if not os.path.exists(osc_path):
        os.mkdir(osc_path)

    return os.path.join(home, osc_path)


def render(zwt_1, name):

    if STORE_FILES:
        osc_path = make_osc_path()
        fname = name + '.wav'
        wavfile.write_wavetable(zwt_1, os.path.join(osc_path, fname))
    if SHOW_PLOTS:
        visualize.plot_wavetable(zwt_1, title=name)


def main():

    # create a signal generator
    sig_gen = sig.SigGen()

    # create a wave table to store the waves
    zwt_1 = wavetable.WaveTable(100, wave_len=2048)
    zwt_2 = wavetable.WaveTable(100, wave_len=2048)

    zwt_1.waves = sig.morph((sig_gen.sqr_saw(0.25),
                           sig_gen.sqr(),
                           sig_gen.tri(),
                           sig_gen.saw(),
                           sig_gen.sqr_saw(0.75)), 100)
    
    zwt_2.waves = sig.morph((sig_gen.tri(),
                        sig_gen.saw(),
                        sig_gen.sharkfin(0.04),
                        sig_gen.saw(),
                        sig_gen.tri()), 100)
    
    wt_m = zwt_1.morph_with(zwt_2)

    zwt_1 = wt_m
    
    render(zwt_1, 'harvey_waves_4')

if __name__ == "__main__":
    main()