#MenuTitle: Signika - Prep Designspace
# -*- coding: utf-8 -*-
"""
    Makes a copy of a GlyphsApp source, with adjustments to designspace by:
    - making masters from "corner" instances
    - setting up new variable font axes
    - setting values in new masters to make a rectangular, 2-axis designspace.

    Specific to Signika for now.

    To use, symlink this script into glyphs script folder with:

    ln -s THIS/PATH/sources/scripts/helpers/prep-designspace-glyphs_script.py GLYPHS/SCRIPTS/PATH/prep-designspace-glyphs_script.py
"""

font = Glyphs.font

# ============================================================================
# get light and bold weight values ===========================================

normalWeights = []
negativeWeights = []

for instance in font.instances:
    if instance.active == True and instance.customParameters["familyName"] == None:
        instanceWeight = instance.weightValue
        normalWeights.append(instanceWeight)
    if instance.active == True and "Negative" in str(instance.customParameters["familyName"]):
        instanceWeight = instance.weightValue
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
    # instanceFont = font.generateInstance_error_(font.instances()[instanceIndex], None)
    instanceFont = font.instances[instanceIndex].interpolatedFont

    # instanceFontMasterID = instanceFont.fontMasters()[0].id()
    instanceFontMasterID = instanceFont.masters[0].id

    if isNegative == True:
        instanceFontName = instanceFont.masters[0].name
        instanceFont.masters[0].name = instanceFontName + " Negative"
        # print(instanceFont.fontMasters()[0].name())

    font.masters.append(instanceFont.masters[0])
    newMasterID = instanceFontMasterID # these are the same; copying for clarity below



    print("\n=================================")
    print("Instance Weight: " + str(font.instances[instanceIndex].weightValue))

    # copy glyphs from instance font to new master
    for index,glyph in enumerate(font.glyphs): # (you can use font.glyphs()[:10] to do the first 10 glyphs only while making/testing script)
        instanceGlyph = instanceFont.glyphs[index] # make variable for glyph of interpolated font
        glyph.layers[instanceFontMasterID] = instanceGlyph.layers[instanceFontMasterID]

    # bring kerning in from interpolated font # not yet working
    font.kerning[instanceFontMasterID] = instanceFont.kerning[instanceFontMasterID]

for index, instance in enumerate(font.instances):
    if "SC" not in str(instance.customParameters["familyName"]):
        instanceWeight = instance.weightValue
        if instanceWeight == lightValue or instanceWeight == boldValue:
            copyFromInterpolatedFont(index)
        if instanceWeight == lightNegValue or instanceWeight == boldNegValue:
            copyFromInterpolatedFont(index, isNegative=True)



# ============================================================================
# set varfont axes ===========================================================


fontAxes = [
	{"Name": "Weight", "Tag": "wght"},
	{"Name": "Negative", "Tag": "NEGA"}
]
Font.customParameters["Axes"] = fontAxes


# ============================================================================
# remove old masters and update axis values ==================================

# just do it twice for now to delete original two – would need more flexibility to be abstracted to other fonts
font.removeFontMasterAtIndex_(0)
font.removeFontMasterAtIndex_(0)

# to make more flexible for another font, this would first find the axis index of "Negative" or other targeted axis
for master in font.masters:
    if "Light" in master.name:
        master.weightValue = lightValue
    
    if "Bold" in master.name:
        master.weightValue = boldValue

    if "Negative" not in master.name:
        master.axes[1] = 0
    
    if "Negative" in master.name:
        master.axes[1] = -1

# ============================================================================
# clean up extraneous instances ==============================================

instancesToRemove = []

for index, instance in enumerate(font.instances):
    print(instance.customParameters["familyName"])

    instanceFamilyName = str(instance.customParameters["familyName"])

    if " SC" in instanceFamilyName or instance.active == False:
        instancesToRemove.append(index)

for instanceIndex in instancesToRemove[::-1]:
    print(instanceIndex)
    del font.instances[instanceIndex]

# ============================================================================
# round all coordinates ======================================================

for glyph in font.glyphs:
    for layer in glyph.layers:
        for path in layer.paths:
            for node in path.nodes:
                node.position.x = round(node.position.x)
                node.position.y = round(node.position.y)
        for anchor in layer.anchors:
            anchor.x = round(anchor.x)
            anchor.y = round(anchor.y)





# ============================================================================
# set instance interpolation values ==========================================

# Go through Instances, setting the Negative instances to the same Weight values as their non-negative counterparts (`50, 360, 650, 920`) and their Negative values as `-1`. Set non-negative masters to a Negative value of `0`. 

instanceWeightValues = []

for index, instance in enumerate(font.instances):
    if "familyName" not in instance.customParameters:
        print(instance.customParameters)

        instanceWeightValues.append(instance.weightValue)

print(sorted(instanceWeightValues))

for instance in font.instances:
    # apply Negative values
    instance.axes[1] = 0
    # add actual negative value if instance is "Negative"
    if "Negative" in str(instance.customParameters["familyName"]):
        instance.axes[1] = -1

    # apply weight values so they match
    if "Light" in instance.name:
        instance.weightValue = instanceWeightValues[0]

    if "Regular" in instance.name:
        instance.weightValue = instanceWeightValues[1]
    
    if "Semibold" in instance.name:
        instance.weightValue = instanceWeightValues[2]
        instance.name = "SemiBold"
    
    if "Bold" in instance.name and "Semi" not in instance.name:
        instance.weightValue = instanceWeightValues[3]
    

# ============================================================================
# save as "build" file =======================================================


buildreadyFolder = 'sources-buildready'
buildreadySuffix = 'prepped_designspace'

fontPath = font.filepath

if "sources-buildready" not in fontPath:    
    fontPathHead = os.path.split(fontPath)[0] # file folder
    fontPathTail = os.path.split(fontPath)[1] # file name
    buildreadyPathHead = fontPathHead + "/" + buildreadyFolder + "/"

    if os.path.exists(buildreadyPathHead) == False:
        os.mkdir(buildreadyPathHead)

    buildPath = buildreadyPathHead + fontPathTail.replace(".glyphs", "-" + buildreadySuffix + ".glyphs")

else:
    buildPath = fontPath.replace(".glyphs", "-" + buildreadySuffix + ".glyphs")

font.save(buildPath)

# close original
font.close()

# ============================================================================
# simplify for split VF ======================================================

Glyphs.open(buildPath)
splitFont = Glyphs.font

fontAxes = [
	{"Name": "Weight", "Tag": "wght"}
]
splitFont.customParameters["Axes"] = fontAxes

# remove Negative instances

instancesToDelete = []

for index, instance in enumerate(splitFont.instances):
    if "Negative" in str(instance.customParameters["familyName"]):
        instancesToDelete.append(index)

for instanceIndex in instancesToDelete[::-1]:
    del splitFont.instances[instanceIndex]

# remove Negative masters

mastersToDelete = []

for index, master in enumerate(splitFont.masters):
    if "Negative" in str(master.name):
        mastersToDelete.append(index)

for masterIndex in mastersToDelete[::-1]:
    del splitFont.masters[masterIndex]


splitBuildPath = buildPath.replace(buildreadySuffix, buildreadySuffix+"-split")

splitFont.save(splitBuildPath)

Glyphs.open(splitBuildPath)

splitFont.close()


# ============================================================================
# simplify for split negative VF =============================================

# open it
Glyphs.open(buildPath)
negFont = Glyphs.font

fontAxes = [
	{"Name": "Weight", "Tag": "wght"}
]
negFont.customParameters["Axes"] = fontAxes


instancesToDelete = []

for index, instance in enumerate(negFont.instances):
    if "Negative" not in str(instance.customParameters["familyName"]):
        instancesToDelete.append(index)

for instanceIndex in instancesToDelete[::-1]:
    del negFont.instances[instanceIndex]

# remove Negative masters

mastersToDelete = []

for index, master in enumerate(negFont.masters):
    if "Negative" not in str(master.name):
        mastersToDelete.append(index)

for masterIndex in mastersToDelete[::-1]:
    del negFont.masters[masterIndex]

for master in negFont.masters:
    masterName = master.name
    master.name = masterName.replace(" Negative", "")

negFontName = negFont.familyName

negFont.familyName = negFontName + " Negative"


splitNegativePath = buildPath.replace(buildreadySuffix, buildreadySuffix+"-split-negative")

negFont.save(splitNegativePath)

Glyphs.open(splitNegativePath)

# close original
negFont.close()


# Open the main prepped-designspace font
Glyphs.open(buildPath)