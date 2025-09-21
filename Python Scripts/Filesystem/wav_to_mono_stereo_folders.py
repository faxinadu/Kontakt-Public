import os
import shutil
import wave

def sort_wav_files(root_folder):
    # Create Mono and Stereo subfolders inside the root folder
    mono_folder = os.path.join(root_folder, "Mono")
    stereo_folder = os.path.join(root_folder, "Stereo")
    os.makedirs(mono_folder, exist_ok=True)
    os.makedirs(stereo_folder, exist_ok=True)

    # Walk through folder and subfolders
    for dirpath, _, filenames in os.walk(root_folder):
        for filename in filenames:
            if filename.lower().endswith(".wav"):
                file_path = os.path.join(dirpath, filename)

                try:
                    with wave.open(file_path, "rb") as wav_file:
                        channels = wav_file.getnchannels()

                    # Move file based on channel count
                    if channels == 1:
                        shutil.move(file_path, os.path.join(mono_folder, filename))
                        print(f"Moved mono file: {file_path}")
                    elif channels == 2:
                        shutil.move(file_path, os.path.join(stereo_folder, filename))
                        print(f"Moved stereo file: {file_path}")
                    else:
                        print(f"Skipped (not mono/stereo): {file_path}")
                except Exception as e:
                    print(f"Error processing {file_path}: {e}")

if __name__ == "__main__":
    folder = input("Enter the root folder path: ").strip()
    sort_wav_files(folder)
