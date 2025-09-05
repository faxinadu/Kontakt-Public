import os

def count_nka_files():
    # Get the current directory
    current_directory = os.getcwd()
    nka_file_count = 0

    # Walk through the directory and its subdirectories
    for root, dirs, files in os.walk(current_directory):
        for file in files:
            if file.endswith('.nka'):
                nka_file_count += 1

    print(f"Total number of .nka files: {nka_file_count}")

if __name__ == "__main__":
    count_nka_files()
