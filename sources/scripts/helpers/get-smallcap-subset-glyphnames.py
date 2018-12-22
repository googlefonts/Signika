"""
Usage: on the command line or in a shell script, use:

python get-smallcap-subset-glyphnames.py FONTNAME.ttx

(be sure to use a TTX file)

"""

import sys
import xml.etree.ElementTree as ET

ttxFile = sys.argv[-1]

tree = ET.parse(ttxFile)
root = tree.getroot()

glyphsInFont = []

for hmtx in root.findall('hmtx'):
    for mtx in hmtx.findall('mtx'):
        glyphName = mtx.get('name')
        glyphsInFont.append(glyphName)

glyphsToRemove = []

for index, glyphName in enumerate(glyphsInFont):
    if ".smcp" in glyphName:
        rootName = glyphName.replace(".smcp", "")

        if rootName in glyphsInFont:
            glyphsToRemove.append(rootName)

for glyphName in glyphsToRemove[::-1]:
    glyphsInFont.remove(glyphName)

# print(glyphsInFont)
# print(glyphsToRemove)

# print space-separated list
for glyphName in set(glyphsInFont):
    print(glyphName, " ", end="")



# find and remove any small caps that don't have lowercase correlaries (e.g. /q.ss02.smcp, in Signika)
# loneSmallCaps = []
# for index, glyphName in enumerate(glyphsInFont):
#     if ".smcp" in glyphName:
#         rootName = glyphName.replace(".smcp", "")

#         if rootName not in glyphsInFont:
#             loneSmallCaps.append(index)


# # iterate backwards so it doesn't change index as it removes names
# for index in loneSmallCaps[::-1]:
#     del glyphsInFont[index]

# # remove ".smcp" glyphs
# noSmallCapsSubset = []
# for glyphName in glyphsInFont:
#     if ".smcp" not in glyphName:
#         noSmallCapsSubset.append(glyphName)

# # print space-separated list
# for glyphName in set(noSmallCapsSubset):
#     print(glyphName, " ", end="")
