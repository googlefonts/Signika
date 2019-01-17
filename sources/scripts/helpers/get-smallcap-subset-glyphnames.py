"""
Usage: on the command line or in a shell script, use:

python get-smallcap-subset-glyphnames.py FONTNAME.ttx

This script:

1. parses TTX to get list glyph names
2. finds all lowercase counterparts to smallcaps glyphs
3. outputs a list of all glyphnames, minus lowercase counterparts

The output list can then be used in pyftsubset to subset the old lowercase out of the font.

(be sure to use a TTX file)
"""

# set this if different
smallCapSuffix = "sc"

import sys
import xml.etree.ElementTree as ET

ttxFile = sys.argv[-1]

tree = ET.parse(ttxFile)
root = tree.getroot()

# sets up list that pyftsubset will leave in the font
glyphsInFont = []

# use XMLstarlet to part TTX xml and find all glyph names to add to list
for hmtx in root.findall('hmtx'):
    for mtx in hmtx.findall('mtx'):
        glyphName = mtx.get('name')
        glyphsInFont.append(glyphName)

# sets up list that pyftsubset will remove
glyphsToRemove = []

for index, glyphName in enumerate(glyphsInFont):
    if ".smcp" in glyphName:
        # erases ".smcp" suffix to make smallcaps glyphs take the place of lowercase
        rootName = glyphName.replace(f'.{smallCapSuffix}', '')

        # adds the smallcap glyphs to a list to be removed
        if rootName in glyphsInFont:
            glyphsToRemove.append(rootName)

# removes the former small cap glyphs from the font
for glyphName in glyphsToRemove[::-1]:
    glyphsInFont.remove(glyphName)

# print space-separated list
for glyphName in set(glyphsInFont):
    print(glyphName, " ", end="")
