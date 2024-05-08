import sys
import os

thisdir = os.getcwd()
pattern = ".txt"

def main():
	if len(sys.argv) > 1:
		if sys.argv[1] == '?':
			print("arg1 = pattern")
			return
		else:			
			pattern = sys.argv[1]
	else:
		pattern = ".txt"	
	for r, d, f in os.walk(thisdir):
	    for file in f:
	        if pattern in file:
	            print(os.path.join(r, file))

if __name__ == "__main__":
    main()