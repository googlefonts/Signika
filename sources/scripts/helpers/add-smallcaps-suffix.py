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
suffix = sys.argv[-2]
familyName = sys.argv[-1]

fileName = os.path.basename(filePath)

f = TTFont(filePath)
for id in [1, 3, 4, 6, 16]:
    name = f["name"].getDebugName(id)
    newFamilyName = familyName
    if not name:
        continue
    if id in [3, 6]:
        # No spaces in these name tables
        newFamilyName = familyName.replace(" ", "")
        newName = name.replace(newFamilyName, newFamilyName + suffix)
    else:
        newName = name.replace(newFamilyName, newFamilyName + " " + suffix)
    f["name"].setName(newName, id, 3, 1, 0x409)
    print("replaced name ID %d '%s' with '%s'" % (id, name, newName))
f.save(filePath)
