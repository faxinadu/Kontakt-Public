# Kontakt Mapping Editor - Lua Auto Mapper

This script will parse information from file names in order to fill a sample mapping.

Suppose we have a high number of samples that we want to map according to tokens we place in the sample name.

We can let the script know which token corresponds to which mapping parameter and then use that in order to
map each sample.

This script is built to be highly generic and re-usable for many scenarios. 

The first section contains user variables that can be set in order to adapt the script. 
It is possible to use various naming conventions by telling the script where each token located.

The second section declares a number of helper functions used in the script.

The third section looks at the file system and prepares tables containing the paths and the tokens.

The fourth section prepares the mapping itself.

The example samples for this tutorial use the following naming convention:
sampleName_root_lowKey_highKey_lowVel_highVel_roundRobin_articulation_signalType
e.g.:
broken piano_r60_lk0_hk127_lv0_hv127_rr0_normal_close

# Example Usage
- Download the script folder from the repository
- Launch Kontakt
- Double click on the Kontakt rack to create a new NKI
- Enter the NKI's edit mode
- Launch Creator Tools
- Navigate to the Lua tab in Creator Tools
- Drag and drop the Lua script unto the Lua tool
- Press play in the Lua tool
- Click the arrow in Creator Tools to push to Kontakt

# Adapt Scenario
- Click the "Open in text editor" icon next to the play button in Creator Tools
- Edit the USER VARIABLES section according to your scenario
