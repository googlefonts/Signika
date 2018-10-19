### based on build script for Encode-Sans-VF, by Mike LaGuttuta
### requires a python 2 environment, for now


###### set vars ######

glyphsSource="sources/Signika-MM-ext_wght_ext_grad-H.glyphs"

fontName="Signika-VF"

timestampAndFontbakeInDist=false

keepDesignspace=true

###### set vars ######

## make temp glyphs filename with "-build" suffix
tempGlyphsSource=${glyphsSource/".glyphs"/"-Build.glyphs"}

## ttfVFName=${glyphsSource/".glyphs"/"-VF.ttf"} # can't quite do this very sensibly without python

## copy Glyphs file into temp file
cp $glyphsSource $tempGlyphsSource

## call the designspace fixing script
# python2 scripts/fix-designspace.py $tempGlyphsSource


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

cd variable_ttf

## fix file metadata with gftools
gftools fix-nonhinting ${fontName}.ttf ${fontName}.ttf
gftools fix-dsig --autofix ${fontName}.ttf
gftools fix-gasp ${fontName}.ttf

## sets up temp ttx file to insert correct values into tables
ttx ${fontName}.ttf

rm -rf ${fontName}.ttf
rm -rf ${fontName}-backup-fonttools-prep-gasp.ttf

cd ..

ttxPath="variable_ttf/${fontName}.ttx"


## inserts patch files into new temp naming ttx
# cat $ttxPath | tr '\n' '\r' | sed -e "s~<name>.*<\/name>~$(cat scripts/NAMEpatch.xml | tr '\n' '\r')~" | tr '\r' '\n' > variable_ttf/${fontName}-name.ttx
# cat variable_ttf/${fontName}-name.ttx | tr '\n' '\r' | sed -e "s,<STAT>.*<\/STAT>,$(cat scripts/STATpatch.xml | tr '\n' '\r')," | tr '\r' '\n' > $ttxPath

# rm -rf variable_ttf/${fontName}-name.ttx

## copies temp ttx file back into a new ttf file
ttx $ttxPath

# removes temp ttx file
rm -rf $ttxPath

ttfPath=${ttxPath/".ttx"/".ttf"}

open $ttfPath

## if you set timestampAndFontbakeInDist variable to true, this creates a new folder in 'dist' to put it into and run fontbake on
if [ $timestampAndFontbakeInDist == true ]
then
    ## move font into dist, with timestamp – probably with a python script and datetime
    ## and fontbake the font
    python3 scripts/distdate-and-fontbake.py $ttfPath
    rm -rf variable_ttf
else
    ttx $ttfPath
    echo "font and ttx in variable_ttf folder"
fi
