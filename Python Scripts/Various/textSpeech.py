
from gtts import gTTS

text = 'Welcome. To the desert, of the real'
filename = 'file'

tts = gTTS(text, slow=False)
tts.save(filename + '.mp3')