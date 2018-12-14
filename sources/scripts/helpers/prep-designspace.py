from Glyphs import *
import sys
import os
import objc

relPath = sys.argv[-1]
# font = GSFont(filename)
directory = os.getcwd()
fullPath = str(directory + "/" + relPath)
# document = Glyphs.open((fullPath), False)
# font = document.font()
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

print(lightValue, boldValue)
print(lightNegValue, boldNegValue)

# ============================================================================
# make masters from instance designspace corners =============================

for index, instance in enumerate(font.instances()):
    if "SC" not in str(instance.customValueForKey_("familyName")):
        if instance.interpolationWeight() == lightValue:
            print(instance.name())
            print(instance.interpolationWeight())

            currentLightFont = font.generateInstance_error_(font.instances()[index], None)

            currentLightFontMasterID = currentLightFont.fontMasters()[0].id()

            font.addFontMaster_(currentLightFont.fontMasters()[0])

            for index,glyph in enumerate(font.glyphs()):
                # make variable for glyph of interpolated font
                instanceGlyph = currentLightFont.glyphs()[index
                
                print(glyph.layerForKey_(currentLightFontMasterID).paths())
                print(instanceGlyph.layerForKey_(currentLightFontMasterID).paths())

                lightFontLayer = instanceGlyph.layerForKey_(currentLightFontMasterID)

                glyph.setLayer_forKey_(lightFontLayer, currentLightFontMasterID)


                # # bring kerning in from interpolated font
            font.setKerning_(currentLightFont.kerning(), newMasterID)

                ## these need to be layer indexes, it seems
                # bring glyph data into glyph of new master
                # glyph.layers()[newMasterID] = currentGlyph.layers()[currentLightFontMasterID]


        # if instance.interpolationWeight() == boldValue:
        #     currentBoldFont = font.generateInstance_error_(font.instances()[-1], None)
        #     print(currentBoldFont.fontMasters()[0])
        #     currentBoldFontMasterID = currentBoldFont.fontMasters()[0].id()
        #     font.addFontMaster_(currentBoldFont.fontMasters()[0])

        # if instance.interpolationWeight() == lightNegValue or instance.interpolationWeight() == boldNegValue:
        #     print(instance.name() + " Negative")
        #     print(instance.interpolationWeight())




# make masters from instance interpolations of:
    # light
    # bold
    # light negative
    # bold negative

# set custom param "Axes"
    # Weight, wght
    # Negative, NEGA

# set weight value in each master
    # if "light" in name, weight = light instance (50)
    # if "bold"

# set negative value in each master
    # if "Negative" in name, Negative = -1
    # else Negative = 0

# set weight value in each instance
    # if "light" in name, weight = light instance (50)
    # if "bold"

# set negative value in each instance
    # if "Negative" in name, Negative = -1
    # else Negative = 0


# document.close()
font.save(fullPath)
doc.close()