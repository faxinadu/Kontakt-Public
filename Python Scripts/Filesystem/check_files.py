import os

def get_file_names(folder_path):
    file_names = set()
    for file in os.listdir(folder_path):
        if os.path.isfile(os.path.join(folder_path, file)):
            file_name, _ = os.path.splitext(file)
            file_names.add(file_name)
    return file_names

def compare_folders(folder1, folder2):
    folder1_files = get_file_names(folder1)
    folder2_files = get_file_names(folder2)

    unique_to_folder1 = folder1_files - folder2_files
    unique_to_folder2 = folder2_files - folder1_files

    return unique_to_folder1, unique_to_folder2

if __name__ == "__main__":
    folder1_path = "/Users/yaron.eshkar/Documents/Native Instruments/User Content/Kontakt/Porphyra Hybrid"
    folder2_path = "/Users/Shared/NI Preview Generation/previews_wav/Native Instruments/Porphyra Hybrid/Kontakt/Porphyra Hybrid"

    unique_to_folder1, unique_to_folder2 = compare_folders(folder1_path, folder2_path)

    print("Files unique to folder1:")
    for file in unique_to_folder1:
        print(file)

    print("\nFiles unique to folder2:")
    for file in unique_to_folder2:
        print(file)
