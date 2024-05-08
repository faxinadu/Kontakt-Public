import sys
import os

thisdir = os.getcwd()
pattern = ".wav"
newName = "OS Er1 Perc"

def main():				

	fileList = [x for x in os.listdir(thisdir) if x.endswith(pattern)]	
	
	i = 0
	for selections in fileList:
		if selections != '':
			os.rename(thisdir + "\\" + selections, thisdir + "\\" + newName + " " + str(i) + pattern)
			i +=1	

if __name__ == "__main__":
    main()
       
