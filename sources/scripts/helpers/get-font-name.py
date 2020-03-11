import sys
from glyphsLib import GSFont

filename = sys.argv[-1]
font = GSFont(filename)

# get font name, remove spaces # add default instance name
varFontName = font.familyName.replace(' ','')

print(varFontName)

sys.exit(0)