### based on build script for Encode-Sans-VF, by Mike LaGuttuta
### requires a python 2 environment, for now



##############################################################################
############################### set vars below ###############################

glyphsSource="sources/sources-buildready/Signika-MM-simple_rectangle_ds.glyphs"

fontName="Signika-VF"

timestampAndFontbakeInDist=false

keepDesignspace=true

############################### set vars above ###############################
##############################################################################

# ============================================================================
# Set up names ===============================================================

# get font name from glyphs source
VFname=`python sources/scripts/helpers/get-font-name.py ${glyphsSource}`
# checking that the name has been pulled out of the source file
echo "VF Name: ${VFname}"

## make temp glyphs filename with "-build" suffix
tempGlyphsSource=${glyphsSource/".glyphs"/"-Build.glyphs"}


## copy Glyphs file into temp file
cp $glyphsSource $tempGlyphsSource

# ============================================================================
# Generate Variable Font =====================================================

## call fontmake to make a varfont
fontmake -o variable -g $tempGlyphsSource

## keep designspace file if you want to look at values later
if [ $keepDesignspace == true ]
then
    ## move font into dist, with timestamp – probably with a python script and datetime
    ## and fontbake the font
    echo "designspace in master_ufo folder"
else
    rm -rf master_ufo
fi

## clean up temp glyphs file
rm -rf $tempGlyphsSource


# ============================================================================
# OpenType table fixes =======================================================

# cd variable_ttf

## fix file metadata with gftools
gftools fix-dsig --autofix variable_ttf/${fontName}.ttf

## sets up temp ttx file to insert correct values into tables
ttx ${fontName}.ttf

rm -rf ${fontName}.ttf

# cd ..

ttxPath="variable_ttf/${fontName}.ttx"


## inserts patch files into new temp naming ttx
# cat $ttxPath | tr '\n' '\r' | sed -e "s~<name>.*<\/name>~$(cat scripts/NAMEpatch.xml | tr '\n' '\r')~" | tr '\r' '\n' > variable_ttf/${fontName}-name.ttx
# cat variable_ttf/${fontName}-name.ttx | tr '\n' '\r' | sed -e "s,<STAT>.*<\/STAT>,$(cat scripts/STATpatch.xml | tr '\n' '\r')," | tr '\r' '\n' > $ttxPath

# rm -rf variable_ttf/${fontName}-name.ttx

## copies temp ttx file back into a new ttf file
ttx $ttxPath

# removes temp ttx file
rm -rf $ttxPath


# ============================================================================
# Autohinting ================================================================

ttfPath=variable_ttf/${ttxPath/".ttx"/".ttf"}
hintedPath=${ttxPath/".ttx"/"-hinted.ttf"}

# Hint with TTFautohint-VF 
# currently janky – I need to find how to properly add this dependency
# https://groups.google.com/forum/#!searchin/googlefonts-discuss/ttfautohint%7Csort:date/googlefonts-discuss/WJX1lrzcwVs/SIzaEvntAgAJ
# ./Users/stephennixon/Environments/gfonts3/bin/ttfautohint-vf ${ttfPath} ${ttfPath/"-unhinted.ttf"/"-hinted.ttf"}
echo "================================================"
echo ttfautohint-vf $ttfPath $hintedPath
echo "================================================"
ttfautohint-vf -I $ttfPath $hintedPath

finalHintedFont=${hintedPath/"-hinted"/""}
cp $hintedPath $finalHintedFont

open ${finalHintedFont}

# ============================================================================
# Sort into final folder =====================================================

# open VF in default program; hopefully you have FontView
open ${finalHintedFont}

# set this to true/false at top of script
if [ $timestampAndFontbakeInDist == true ]
then
    newFontLocation=`python sources/scripts/helpers/distdate.py variable_ttf/${VFname}.ttf`

    fontbakery check-googlefonts ${newFontLocation}/${VFname}.ttf --ghmarkdown ${newFontLocation}/${VFname}-fontbakery-report.md

    echo "new VF location is " ${newFontLocation}
else
    ## move font into fonts/, then fontbake
    finalFontLocation=fonts/${VFname}.ttf
    cp $finalHintedFont $finalFontLocation
    echo "new VF location is " ${finalFontLocation}

    fontbakery check-googlefonts ${finalFontLocation} --ghmarkdown ${finalFontLocation/".ttf"/"-fontbakery-report.md"}
fi

rm -rf variable_ttf
