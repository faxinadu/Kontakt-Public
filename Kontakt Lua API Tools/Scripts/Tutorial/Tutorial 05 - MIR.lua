----------------------------------------------------------------------------------------------------
-- Tutorial 05: MIR
----------------------------------------------------------------------------------------------------
--[[ 
Music Information Retrieval (MIR) is the science of retrieving information from music. 
Among others, it allows the extraction of information from audio files, such as the pitch or velocity of a sample.
The API comes with a collection of MIR functions, that can assist or automate parts of the instrument creation process.
Note that all functions live in the global MIR table.
--]]

-- Set a path to a directory containing example files.
local path = Filesystem.preferred(Kontakt.script_path .. "/assets")

-- A separator to structure the print out information.
local dash_sep = "-------------------------------------------------"

-- Print out annotations about what happens next.
print("Searching for all sample files in: " .. path)
print("Working... this make take some time")
print(dash_sep)

-- Inside a for loop, WAV files get collected in a table for later use.
-- Declaration of a table.
local paths_table = {}
-- Recursive loop over the filepath.
for _,p in Filesystem.recursive_directory(path) do
    -- Looking for WAV files and storing the paths to the files in the declared table.
    if Filesystem.extension(p) == ".wav" then
        table.insert(paths_table,p)
    end
end

-- Print how many sample files are stored in the table.
print("Found: " .. #paths_table .. " sample files")
print(dash_sep)

-- Iterate over the table using Lua pairs. In this case v represents the value of each table entry, ie one of our sample paths.
for k,v in pairs(paths_table) do
    -- Lets do some MIR.

    -- Type detection is a means to determine which category a given audio sample belongs to. 
    -- Currently, the Kontakt API supports detection of three distinct types: Sample, Drum, and Instrument.
    -- Sample type detection is used to determine if a sample belongs to a drum or an instrument category. 
    -- Drum and Instrument type detections further refine to which drum or instrument category a sample belongs to.

    -- Detection of the sample type.
    -- Returns the following types or nil: drum, instrument.
    local sample_type =  MIR.detect_sample_type(v)

    -- Detection of the instrument type.
    -- Returns the following typer or nil: bass, bowed_string, brass, flute, guitar, keyboard, mallet, organ, plucked_string, reed, synth, vocal.
    local insrument_type =  MIR.detect_instrument_type(v)

    -- Detection of the drum type. 
    -- Returns one of the following types or nil: kick, snare, hihat_closed, hihat_open, tom, cymbal, clap, shaker, percussion_drum, percussion_other.
    local drum_type = MIR.detect_drum_type(v)
    
    -- Loudness, Peak, and RMS functions return a value in dB, with a maximum at 0dB.
    -- The RMS and Loudness functions are calculated over small blocks of audio. 
    -- The duration of those blocks is called frame size and is expressed in seconds. 
    -- The process is repeated in intervals equal to the hop size (also expressed in seconds), until it reaches the end of the sample. 
    -- These functions return the overall loudest/highest value of the different blocks.
    -- If frame size and hop size are not indicated, the default values 0.4 (frame size in seconds) and 0.1 (hop size in seconds) are applied respectively.
    local loudness =  MIR.detect_loudness(v)
    local peak =  MIR.detect_peak(v)
    local rms =  MIR.detect_rms(v)
    
    -- The pitch detection tries to detect the fundamental frequency of a monophonic/single note sample. 
    -- It corresponds to the MIDI scale (69 = 440 Hz) and ranges from semitone 15 (~20Hz) to semitone 120 (~8.4 kHz).
    local pitch =  MIR.detect_pitch(v)
    
    -- Printing the results.
    print("Sample file " ..Filesystem.stem(v) .. " is a " .. sample_type)
    print("Sample file " ..Filesystem.stem(v) .. " is a " .. drum_type)
    print("Sample file " ..Filesystem.stem(v) .. " is a " .. insrument_type)
    print("Sample file " ..Filesystem.stem(v) .. " loudness " .. loudness)
    print("Sample file " ..Filesystem.stem(v) .. " peak " .. peak)
    print("Sample file " ..Filesystem.stem(v) .. " RMS " .. rms)
    print("Sample file " ..Filesystem.stem(v) .. " pitch " .. pitch)

    -- The find_loop function can be used to find suitable loop start and end points.
    -- A minimum audio file length of 0.5 seconds is required for the function to run.
    -- The examples contain some shorter files. 
    -- For those short samples, start_loop and end_loop will return nil.
    local start_loop, end_loop = MIR.find_loop(v)
    if start_loop then 
        print("Suggested loop start: " .. start_loop)
        print("Suggested loop end: " .. end_loop)
        print("Suggested loop length: " .. end_loop - start_loop)
    end 
    print(dash_sep)
end