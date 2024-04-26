import sys
import os

import fileinput

import re

text = "cb_id["

thisdir = os.getcwd()
oldtext = "cb_id[xxx]"
filepath = thisdir + "/porpyhra_shots.txt"

def replace_in_file(file_path, search_text):
    i = 0
    twice = 0
    with fileinput.input(file_path, inplace=False) as file:
        for line in file:
            if oldtext in line:
                new_line = line.replace(search_text, "cb_id[" + str(i) + "]")
                print(new_line, end='')
                twice += 1
                if twice % 2 == 0:
                    i += 1

def main():				

	replace_in_file(filepath,oldtext)

if __name__ == "__main__":
    main()