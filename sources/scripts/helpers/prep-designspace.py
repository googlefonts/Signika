"""
    Makes a copy of a GlyphsApp source, with adjustments to designspace by:
    - making masters from "corner" instances
    - setting up new variable font axes
    - setting values in new masters to make a rectangular, 2-axis designspace.

    Specific to Signika for now.
"""

from Glyphs import *
import sys
import os
import objc

relPath = sys.argv[-1]
directory = os.getcwd()
fullPath = str(directory + "/" + relPath)
buildPath = fullPath.replace(".glyphs", "-build.glyphs")

doc = Glyphs.openDocumentWithContentsOfFile_display_(fullPath, False)
font = doc.font()

# ============================================================================
# get light and bold weight values ===========================================

normalWeights = []
negativeWeights = []

for instance in font.instances():
    if instance.visible() == 1 and instance.customValueForKey_("familyName") == None:
        instanceWeight = instance.interpolationWeight()
        normalWeights.append(instanceWeight)
    if instance.visible() == 1 and "Negative" in str(instance.customValueForKey_("familyName")):
        instanceWeight = instance.interpolationWeight()
        negativeWeights.append(instanceWeight)

normalWeights = sorted(normalWeights)
lightValue = normalWeights[0]
boldValue = normalWeights[-1]

negativeWeights = sorted(negativeWeights)
lightNegValue = negativeWeights[0]
boldNegValue = negativeWeights[-1]

# ============================================================================
# make masters from instance designspace corners =============================

print("Copying glyphs from interpolated corner instances:")

def copyFromInterpolatedFont(instanceIndex):
    instanceFont = font.generateInstance_error_(font.instances()[instanceIndex], None)
    instanceFontMasterID = instanceFont.fontMasters()[0].id()
    font.addFontMaster_(instanceFont.fontMasters()[0])

    print("\n=================================")
    print("Instance Weight: " + str(font.instances()[instanceIndex].interpolationWeight()))

    for index,glyph in enumerate(font.glyphs()[:10]): #first 10 glyphs only, while making/testing script
        print(". ", end="", flush=True)
        # make variable for glyph of interpolated font
        instanceGlyph = instanceFont.glyphs()[index]
        instanceFontLayer = instanceGlyph.layerForKey_(instanceFontMasterID)
        glyph.setLayer_forKey_(instanceFontLayer, instanceFontMasterID)

#     # # bring kerning in from interpolated font
#     # in Python API: currentFont.kerning[newMasterID] = instanceFont.kerning[newMasterID]
#     # font.setKerning_(instanceFont.fontMasters()[0].kerning(), instanceFontMasterID)

for index, instance in enumerate(font.instances()):
    if "SC" not in str(instance.customValueForKey_("familyName")):
        instanceWeight = instance.interpolationWeight()
        if instanceWeight == lightValue or instanceWeight == boldValue or instanceWeight == lightNegValue or instanceWeight == boldNegValue:
            copyFromInterpolatedFont(index)


# # set custom param "Axes"
#     # Weight, wght
#     # Negative, NEGA

# newCustomParam = GSCustomParameter().init()

# font.addCustomParameter_(newCustomParam)

# print(font.customParameterForKey("Axes"))


# # font.setCustomParameter_forKey_()

# # set weight value in each master
#     # if "light" in name, weight = light instance (50)
#     # if "bold"

# # set negative value in each master
#     # if "Negative" in name, Negative = -1
#     # else Negative = 0

# # set weight value in each instance
#     # if "light" in name, weight = light instance (50)
#     # if "bold"

# # set negative value in each instance
#     # if "Negative" in name, Negative = -1
#     # else Negative = 0


# # document.close()
font.save(buildPath)
doc.close()