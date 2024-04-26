import os
import fileinput
import re

thisdir = os.getcwd()
filepath = thisdir + "/porpyhra_shots.txt"

regex = r"%cb_id\[([1-9]|[1-9][0-9]|[1-9][0-9][0-9])\]"

def replace_in_file(file_path, search_text):
    i = 0
    twice = 0
    with fileinput.input(file_path, inplace=True) as file:
        for line in file:
            if re.search(search_text,line):
                new_line = re.sub(search_text,"%cb_id[" + str(i) + "]", line)
                print(new_line, end='')
                twice += 1
                if twice % 2 == 0:
                    i += 1
            else:
                 print(line, end='')

def main():				

	replace_in_file(filepath,regex)

if __name__ == "__main__":
    main()

    