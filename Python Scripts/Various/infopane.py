# File path where the input text is located
file_path = "porphyra_hybrid.txt"

# Initialize an empty list to store filtered lines
filtered_lines = []

# Read input text from the file
try:
    with open(file_path, 'r') as file:
        # Read all lines from the file
        lines = file.readlines()
        
        # Filter lines that contain 'infoPaneText'
        filtered_lines = [line.strip() for line in lines if 'infoPaneText' in line]
    
    # Write filtered lines to a text file
    with open('filtered_lines.txt', 'w') as output_file:
        for line in filtered_lines:
            output_file.write(line + '\n')
    
    print(f"Filtered lines containing 'infoPaneText' have been saved to 'filtered_lines.txt'.")
    
except FileNotFoundError:
    print(f"Error: The file '{file_path}' was not found.")

except Exception as e:
    print(f"An error occurred: {str(e)}")