
from fontTools.ttLib import TTFont

import sys
import os

# ---------------------------------------------------------------------
# capture args from command line cue ----------------------------------
filePath = sys.argv[-3]  # first argument, ttf file
oldName = sys.argv[-2]  # second argument, old glyph name
newName = sys.argv[-1]  # third argument, new glyph name

filePath = os.path.abspath(filePath)
print(sys.argv, "FILE", filePath)

font = TTFont(filePath)

cmap = font.getBestCmap()

for unicode, glyphName in cmap.items():
    if glyphName == oldName:
        cmap[unicode] = newName

# Remove old glyph from glyphOrder, thus "removing" it from the font
# order = font.getGlyphOrder()
# order = [g for g in order if g != oldName]
# font.setGlyphOrder(order)

font.save(filePath)
