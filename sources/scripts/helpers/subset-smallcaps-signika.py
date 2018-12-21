#MenuTitle: Subset Signika Smallcaps for Gfonts
# -*- coding: utf-8 -*-
__doc__="""
Make a separate glyphs file that replaces lowercase glyphs with small caps, for exporting via FontMake.

- Finds all lowercase correlaries to smallcap glyphs, and removes them
- Removes ".smcp" suffix from smallcap names to map them to default lowercase
- Triggers a feature code update
- Updates family name and instances (this is especially specific to Signika)

This script takes care to not disrupt component glyphs, kerning, or features. 

Currently specific to Sigkika, but could be modified/extended for other families fairly easily.
You might also just want to use https://github.com/twardoch/fonttools-utils/tree/master/pyftfeatfreeze
"""

smallCapSuffix = ".smcp"

font = Glyphs.font

Glyphs.showMacroWindow()
typeFamilyName = font.familyName

# build lists
smallCaps = []
glyphsToDelete = []
for glyph in font.glyphs:
    print("-----------------------------")
    print(glyph.name)
    if smallCapSuffix in glyph.name:
        #  get root name: e.g. /a.smcp yields variable "a"
        rootName = glyph.name.replace(smallCapSuffix, "").lower()
        print(glyph.name + " is a smallcap with rootname of " + rootName)
        smallCaps.append(glyph.name)
        glyphsToDelete.append(rootName)

# delete the root glyph so the .smcp version is the only one left
for glyphName in glyphsToDelete:
    print("deleting " + glyphName)
    del font.glyphs[glyphName]


# update smallcap names to be just lowercase names
for glyphName in smallCaps:
    rootName = glyphName.replace(smallCapSuffix, "").lower()
    print("updating smallcap name " + glyphName + " to " + rootName)
    font[glyphName].name = rootName

# make sure kerning is preserved
    # a.smcp v.smcp is -86
    # l.smcp v.smcp is -146
    # 👍 it is

# make sure component glyphs are taken care of
    # correct components
    # correct placement
    # 👍 looking good

# make sure unicodes are set
    # 👍 they are


# delete instances that are labeled as "SC"

instancesToRemove = []

for index, instance in enumerate(font.instances):
    print(instance.customParameters["familyName"])

    instanceFamilyName = str(instance.customParameters["familyName"])

    if " SC" in instanceFamilyName or instance.active == False:
        instancesToRemove.append(index)

for instanceIndex in instancesToRemove[::-1]:
    print(instanceIndex)
    del font.instances[instanceIndex]

# kerning class names are still using .smcp suffixes, but it still works when exported
# [ ] test this in a browser, as well


# add "update" for opentype features

# this works for signika because all features are set to auto – would likely need more care for other families
for feature in font.features:
    if feature.automatic:
        feature.update()

# add " SC" to font main family name
font.familyName = "Signika SC"

# add " SC" to font instance custom family name params
for index, instance in enumerate(font.instances):
    instanceFamilyName = str(instance.customParameters["familyName"])
    if " Negative" in instanceFamilyName:
        instance.customParameters["familyName"] = "Signika Negative SC"


# make sure opentype features still work

fontPath = font.filepath
scSavePath = str(fontPath.replace(".glyphs","-sc.glyphs"))
font.save(scSavePath)
font.close()

Glyphs.open(scSavePath)