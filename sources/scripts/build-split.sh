### based on build script for Encode-Sans-VF, by Mike LaGuttuta
### requires a python 2 environment, for now



##############################################################################
############################### set vars below ###############################

glyphsSource="sources/sources-buildready/Signika-MM-prepped_designspace-split.glyphs"

fontName="Signika-VF"

timestampAndFontbakeInDist=false

keepDesignspace=false

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


## fix file metadata with gftools
gftools fix-dsig --autofix variable_ttf/${fontName}.ttf



# ============================================================================
# Autohinting ================================================================

ttfPath=variable_ttf/${VFname}.ttf
hintedPath=${ttfPath/".ttf"/"-hinted.ttf"}

# Hint with TTFautohint-VF 
# currently janky – I need to find how to properly add this dependency
# https://groups.google.com/forum/#!searchin/googlefonts-discuss/ttfautohint%7Csort:date/googlefonts-discuss/WJX1lrzcwVs/SIzaEvntAgAJ
# ./Users/stephennixon/Environments/gfonts3/bin/ttfautohint-vf ${ttfPath} ${ttfPath/"-unhinted.ttf"/"-hinted.ttf"}
echo "================================================"
echo ttfautohint-vf -I $ttfPath $hintedPath
echo "================================================"
ttfautohint-vf -I $ttfPath $hintedPath

finalHintedFont=${hintedPath/"-hinted"/""}
cp $hintedPath $finalHintedFont

open ${finalHintedFont}

# ============================================================================
# Sort into final folder =====================================================

# open VF in default program; hopefully you have FontView
open ${finalHintedFont}

fontbakeFile()
{
    FILEPATH=$1
    fontbakery check-googlefonts ${FILEPATH} --ghmarkdown ${FILEPATH/".ttf"/"-fontbakery-report.md"}
}

outputDir="fonts"


finalFontLocation=fonts/signika/split_vf/${VFname}.ttf
cp $finalHintedFont $finalFontLocation
echo "new VF location is " ${finalFontLocation}

fontbakery check-googlefonts ${finalFontLocation} --ghmarkdown ${finalFontLocation/".ttf"/"-fontbakery-report.md"}

rm -rf variable_ttf
