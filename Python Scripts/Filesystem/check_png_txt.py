import os

def check_png_txt_files():
    # Get the current directory
    current_directory = os.getcwd()
    
    # List all files in the current directory
    files_in_directory = os.listdir(current_directory)
    
    # Filter out .png files
    png_files = [file for file in files_in_directory if file.endswith('.png')]
    
    # Check for corresponding .txt files
    for png_file in png_files:
        txt_file = png_file.replace('.png', '.txt')
        if txt_file not in files_in_directory:
            print(f"Missing corresponding .txt file for: {png_file}")

if __name__ == "__main__":
    check_png_txt_files()
