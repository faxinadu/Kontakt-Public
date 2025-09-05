import os

def count_png_files():
    # Get the current directory
    current_directory = os.getcwd()
    png_file_count = 0

    # Walk through the directory and its subdirectories
    for root, dirs, files in os.walk(current_directory):
        for file in files:
            if file.endswith('.png'):
                png_file_count += 1

    print(f"Total number of .png files: {png_file_count}")

if __name__ == "__main__":
    count_png_files()
