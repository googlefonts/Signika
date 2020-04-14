__doc__ = """
    Use to add a suffix to the family name of a font that has has an opentype feature "frozen" with pyftfeatfreeze.py

    Adds a suffix to names 1, 3, 4, 6 and 16 if set.

    USAGE

    From the command line or a shell script, run:

    python SCRIPT/PATH/add-smallcaps-suffix.py [FONT/PATH/font.ttf] [suffix]
"""

from fontTools.ttLib import TTFont

import sys
import os

# ---------------------------------------------------------------------
# capture args from command line cue ----------------------------------
filePath = sys.argv[-3]
oldFamilyName = sys.argv[-2] # Signika or Signika Negative
newFamilyName = sys.argv[-1] # Signika SC or Signika Negative SC

fileName = os.path.basename(filePath)

f = TTFont(filePath)
for id in [1, 3, 4, 6, 16]:
    name = f["name"].getDebugName(id)
    old = oldFamilyName
    if not name:
        continue

    if id in [3, 6]:
        # No spaces in these name tables
        old = oldFamilyName.replace(" ", "-")
        newFam = newFamilyName.replace(" ", "-")

    newName = name.replace(old, newFamilyName)
    f["name"].setName(newName, id, 3, 1, 0x409)
    print("replaced name ID %d '%s' with '%s'" % (id, name, newName))
f.save(filePath)
