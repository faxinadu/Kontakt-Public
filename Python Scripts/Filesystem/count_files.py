import os

def count_nksn_files(directory):
    nksn_count = 0
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.wav'):
                nksn_count += 1
    return nksn_count

if __name__ == "__main__":
    current_directory = os.getcwd()
    nksn_files_count = count_nksn_files(current_directory)
    print(f"Number of .wav files: {nksn_files_count}")