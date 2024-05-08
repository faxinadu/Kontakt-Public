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


def render(zwt, name):

    if STORE_FILES:
        osc_path = make_osc_path()
        fname = name + '.wav'
        wavfile.write_wavetable(zwt, os.path.join(osc_path, fname))
    if SHOW_PLOTS:
        visualize.plot_wavetable(zwt, title=name)


def main():

    # create a signal generator
    sig_gen = sig.SigGen()

    # create a wave table to store the waves
    zwt = wavetable.WaveTable(100, wave_len=2048)

    zwt.waves = sig.morph((sig_gen.pls(0.1),
                           sig_gen.sqr_saw(0.1),
                           sig_gen.pls(0.1),
                           sig_gen.sqr_saw(0.3),
                           sig_gen.pls(0.1),
                           sig_gen.sqr_saw(0.4),
                           sig_gen.pls(0.1)), 100)
    
    render(zwt, 'harvey_waves_18')

if __name__ == "__main__":
    main()