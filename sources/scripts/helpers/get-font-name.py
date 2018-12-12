import sys
from glyphsLib import GSFont

filename = sys.argv[-1]
font = GSFont(filename)

# get font name, remove spaces
varFontName = font.familyName.replace(' ','') + '-VF'

print(varFontName)

sys.exit(0)