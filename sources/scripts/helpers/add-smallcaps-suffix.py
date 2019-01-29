__doc__ = """
    Use to add a suffix to the family name of a font that has has an opentype feature "frozen" with pyftfeatfreeze.py

    Adds a suffix to names 1, 3, 4, and 6.

    USAGE

    From the command line or a shell script, run:

    python SCRIPT/PATH/add-smallcaps-suffix.py [FONT/PATH/font.ttf] [suffix]
"""

import sys
import os
import subprocess

# ---------------------------------------------------------------------
# capture args from command line cue ----------------------------------

filePath = sys.argv[-3]
suffix = sys.argv[-2]
familyName = sys.argv[-1]

fileName = os.path.basename(filePath)

print(familyName)

print('------------------------------------------------------------------------------------------')
print('------------------------------------------------------------------------------------------')
print('adding suffix ' + suffix + ' to → ' + filePath)
print('------------------------------------------------------------------------------------------')
print('------------------------------------------------------------------------------------------')

# ---------------------------------------------------------------------
# make command line calls more convenient -----------------------------

# run command without grabbing the output
def run(command):
    print('')
    print('----------')
    print('running  → ', command)
    print('----------')
    return subprocess.call(command, shell=True)

# run command and return the output
def get(command):
    print('')
    print('----------')
    print('checking → ', command)
    print('----------')
    # also strips out xml junk
    return str(subprocess.check_output(command, shell=True)).replace("b'","").replace("'","").replace('\\n','').replace('  ','')

# # ---------------------------------------------------------------------
# # TTX the input TTF file ----------------------------------------------

ttxPath = filePath.replace('.ttf', '.ttx')

# Check if ttx exists. If it does, replace it with a new one.
if os.path.isfile(ttxPath) == False:
    run("ttx " + filePath)
else:
    os.remove(ttxPath)
    run("ttx " + filePath)


# ---------------------------------------------------------------------
# get nameID values and morph into updated dictionary -----------------

def getNameId(num):
    return get('xml sel -t -v "//*/namerecord[@nameID=\''+ str(num) + '\']" ' + ttxPath)

namesToEdit = {}

def dictFromNameIDs(dictionary, *args):
    dictionary = {}
    for arg in args:
        try:
            dictionary[arg] = (getNameId(arg))
        except subprocess.CalledProcessError as e:
            print(e.output)

    return dictionary

namesToEdit = dictFromNameIDs("namesToEdit", 1,3,4,6,16)

print(namesToEdit)

def newName(nameValue):
    return nameValue.replace(familyName, familyName + ' ' + suffix)

def newNameNoSpaces(nameValue):
    return nameValue.replace(familyName.replace(' ',''), familyName.replace(' ','') + suffix)

def addSuffix(suffix):
    for nameID, nameValue in namesToEdit.items():
        if nameID in [1, 4, 16]:
            namesToEdit[nameID] = newName(nameValue)
        if nameID == 6:
            namesToEdit[nameID] = newNameNoSpaces(nameValue)
        if nameID == 3:
            if ' ' in nameValue:
                namesToEdit[nameID] = newName(nameValue)
            else:
                namesToEdit[nameID] = newNameNoSpaces(nameValue)

addSuffix(namesToEdit)
print(namesToEdit)

# ---------------------------------------------------------------------
# update names in TTX -------------------------------------------------

# this doesn't make pretty formatting in the updated TTX file (newlines and indents are messed up), but that doesn't impact the final output

def updateNameId(num, newName):
    run('xml ed --inplace -u "//*/namerecord[@nameID=\''+ str(num) + '\']" -v "' + newName + '" ' + ttxPath)

    print("nameID " + str(num) + " is now " + newName)

for nameID in namesToEdit:
    updateNameId(nameID, namesToEdit[nameID])


# ---------------------------------------------------------------------
# check edited TTX ----------------------------------------------------

namesToCheck = dictFromNameIDs("namesToCheck", 1,3,4,6,16)

for nameID in namesToCheck:
    print(namesToCheck[nameID])

# ---------------------------------------------------------------------
# save back to TTF ----------------------------------------------------

# remove original font file
os.remove(filePath)

# make new font file from edited TTX
run("ttx " + ttxPath)

# remove edited TTX
os.remove(ttxPath)