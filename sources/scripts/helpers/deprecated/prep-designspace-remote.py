#MenuTitle: Prep Designspace
# -*- coding: utf-8 -*-
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

def copyFromInterpolatedFont(instanceIndex, isNegative=False):
    instanceFont = font.generateInstance_error_(font.instances()[instanceIndex], None)
    instanceFontMasterID = instanceFont.fontMasters()[0].id()
    if isNegative == True:
        instanceFontName = instanceFont.fontMasters()[0].name()
        instanceFont.fontMasters()[0].setName_(instanceFontName + " Negative")
        # print(instanceFont.fontMasters()[0].name())

    font.addFontMaster_(instanceFont.fontMasters()[0])
    newMasterID = instanceFontMasterID # these are the same; copying for clarity below



    print("\n=================================")
    print("Instance Weight: " + str(font.instances()[instanceIndex].interpolationWeight()))

    # copy glyphs from instance font to new master
    for index,glyph in enumerate(font.glyphs()[:5]): # (you can use font.glyphs()[:10] to do the first 10 glyphs only while making/testing script)
        print(". ", end="", flush=True) # shows progress while running script
        instanceGlyph = instanceFont.glyphs()[index] # make variable for glyph of interpolated font
        instanceFontLayer = instanceGlyph.layerForKey_(instanceFontMasterID) # get layer of glyph in instance font
        glyph.setLayer_forKey_(instanceFontLayer, newMasterID) # set layer in new master

    # bring kerning in from interpolated font # not yet working
    # font.kerning()[newMasterID] = instanceFont.kerning()[newMasterID]
    # font.kerning().setObject_forKey_(instanceFont.kerning().objectForKey_(newMasterID), newMasterID)
    


for index, instance in enumerate(font.instances()):
    if "SC" not in str(instance.customValueForKey_("familyName")):
        instanceWeight = instance.interpolationWeight()
        if instanceWeight == lightValue or instanceWeight == boldValue:
            copyFromInterpolatedFont(index)
        if instanceWeight == lightNegValue or instanceWeight == boldNegValue:
            copyFromInterpolatedFont(index, isNegative=True)



# ============================================================================
# set varfont axes ===========================================================

# may need to be done manually for now, pending forum question

print("=================================\n")

# # describe your variable axis names and tags
# fontAxes = {
# 	"Weight": "wght",
# 	"Negative": "NEGA"
# }

# # newParam = GSCustomParameter.alloc().init()

# # font.addCustomParameter_(newParam)
# # font.addCustomParameter_("Axes")
# # add them to the font
# font.setCustomParameter_forKey_(fontAxes, "Axes")

# print(font.customParameterForKey_("Axes"))

from Foundation import NSMutableDictionary, NSMutableArray
fontAxes = NSMutableArray.arrayWithArray_([
	NSMutableDictionary.dictionaryWithDictionary_({
		"Name": "Weight", "Tag": "wght"
	}),
	NSMutableDictionary.dictionaryWithDictionary_({
		"Name": "Negative", "Tag": "NEGA"
	})
])
font.setCustomParameter_forKey_(fontAxes, "Axes")


# ============================================================================
# remove old masters =========================================================

# just do it twice for now to delete original two – would need more flexibility to be abstracted to other fonts
font.removeFontMasterAtIndex_(0)
font.removeFontMasterAtIndex_(0)

# ============================================================================
# set axis values of new masters =============================================

# for master in font.fontMasters():
#     print(master.name())
#     # master.setCustomValue_forKey_(0.0, "Negative")
#     if "Light" in master.name():
#         master.setWeightValue_(lightValue)
#     if "Bold" in master.name():
#         master.setWeightValue_(boldValue)
#     # "Light" in str(instance.customValueForKey_("familyName"))
#     if "Negative" in master.name():
#         # master.setCustomValue_forKey_(-100, "Negative")
#         master.setCustomValue_(-50.0, "Negative")
#     # if "Negative" not in master.name():
#     #     # master.setCustomValue_forKey_(-100, "Negative")
#     #     master.setCustomValue_(0.0, "NEGA")

# add " Negative" to negative master names

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
buildPath = fullPath.replace(".glyphs", "-build.glyphs")
font.save(buildPath)
doc.close()