set -x

# while [ ! $# -eq 0 ]
#     do
#     case "$1" in
#         --full | -f)
fullVF=true
splitVF=false
negativeSplit=false

glyphsSource="sources/sources-buildready/Signika-MM-prepped_designspace.glyphs"
finalLocation="fonts/signikavf"
scFinalLocation="fonts/signikascvf"
#         ;;
#         --normal | -n)
#             fullVF=false
#             splitVF=true

#             glyphsSource="sources/sources-buildready/Signika-MM-prepped_designspace-split.glyphs"
#             finalLocation="fonts/signika/split_vf"
#             scFinalLocation="fonts/signikasc/split_vf"

#             negativeSplit=true

#             negGlyphsSource="sources/sources-buildready/Signika-MM-prepped_designspace-split-negative.glyphs"
#             negFinalLocation="fonts/signikanegative/split_vf"
#             negScFinalLocation="fonts/signikanegativesc/split_vf"
#         ;;
#         *) 
#             echo "Error: please supply an argument of --normal (-n) or --full (-f)"
#     esac
#     shift
# done

# if varfont folder exists, clean it up
if [ -d "variable_ttf" ]; then
  rm -rf variable_ttf
fi

# ============================================================================
# Set up names ===============================================================

# get font name from glyphs source
VFname=`python sources/scripts/helpers/get-font-name.py ${glyphsSource}`
# VFname='SignikaVF'
# checking that the name has been pulled out of the source file
echo "VF Name: ${VFname}"

# smallCapFontName, e..g 'SignikaSCVF'
smallCapFontName=${VFname/"VF"/"SCVF"}

## make temp glyphs filename with "-build" suffix
tempGlyphsSource=${glyphsSource/".glyphs"/"-Build.glyphs"}

## copy Glyphs file into temp file
cp $glyphsSource $tempGlyphsSource

if [ $negativeSplit == true ]
then
    # get font name from glyphs source
    negVFname=`python sources/scripts/helpers/get-font-name.py ${negGlyphsSource}`
    # negVFname='SignikaNegativeVF[wght]'
    # checking that the name has been pulled out of the source file
    echo "Negative VF Name: ${negVFname}"

    # smallCapFontName, e..g 'SignikaSCVF'
    negSmallCapFontName=${negVFname/"VF"/"SCVF"}

    ## make temp glyphs filename with "-build" suffix
    negTempGlyphsSource=${negGlyphsSource/".glyphs"/"-Build.glyphs"}

    cp $negGlyphsSource $negTempGlyphsSource
fi

# ============================================================================
# Generate Variable Font =====================================================

## call fontmake to make a varfont
fontmake -o variable -g $tempGlyphsSource

if [ $negativeSplit == true ]
then
    fontmake -o variable -g $negTempGlyphsSource
fi

## clean up temp glyphs file
rm -rf $tempGlyphsSource
if [ $negativeSplit == true ]
then
    rm -rf $negTempGlyphsSource
fi

# Add the [wght] to all names according to GF naming scheme
for file in variable_ttf/*; do 
    cp $file ${file/"-VF"/"VF[NEGA,wght]"}
    rm $file
done
# ============================================================================
# SmallCap subsetting ========================================================

ttx variable_ttf/SignikaVF[NEGA,wght].ttf
ttxPath="variable_ttf/SignikaVF[NEGA,wght].ttx"

#get glyph names, minus .smcp glyphs
subsetGlyphNames=`python sources/scripts/helpers/get-smallcap-subset-glyphnames.py $ttxPath`
rm -rf $ttxPath

echo $subsetGlyphNames

for file in variable_ttf/*; do 
if [ -f "$file" ]; then 

    if [[ $file != *"SignikaNegative"* ]]; then
        smallCapFile=${file/"Signika"/"SignikaSC"}
        familyName="Signika"
    fi
    if [[ $file == *"SignikaNegative"* ]]; then
        smallCapFile=${file/"SignikaNegative"/"SignikaNegativeSC"}
        familyName="Signika Negative"
    fi

    python sources/scripts/helpers/pyftfeatfreeze.py -f 'smcp' $file $smallCapFile
    
    echo "subsetting smallcap font"
    # subsetting with subsetGlyphNames list
    pyftsubset --name-IDs='*' $smallCapFile $subsetGlyphNames --glyph-names --notdef-glyph

    subsetSmallCapFile=${smallCapFile/".ttf"/".subset.ttf"}
    rm -rf $smallCapFile
    mv $subsetSmallCapFile $smallCapFile

    smallCapSuffix="SC"
    # update names in font with smallcaps suffix
    python sources/scripts/helpers/add-smallcaps-suffix.py $smallCapFile $smallCapSuffix "$familyName"

fi 
done



# ============================================================================
# Autohinting ================================================================

for file in variable_ttf/*; do 
if [ -f "$file" ]; then 
    echo "fix DSIG in " ${file}
    gftools fix-dsig --autofix ${file}

    echo "TTFautohint " ${file}
    # autohint with detailed info
    hintedFile=${file/".ttf"/"-hinted.ttf"}
    
    echo "------------------------------------------------"
    # echo ttfautohint-vf $file $hintedFile --stem-width-mode nnn --increase-x-height 9
    # echo "------------------------------------------------"
    ttfautohint-vf -I $file $hintedFile --stem-width-mode nnn --increase-x-height 9
    gftools fix-hinting $hintedFile
    $hintedFile="${hintedFile}.fix"

    cp ${hintedFile} ${file}
    rm -rf ${hintedFile}

    
fi 
done

# ============================================================================
# OpenType table fixes =======================================================

insertPatch()
{
    FILE=$1

    echo $FILE

    ## sets up temp ttx file to insert correct values into tables # also drops MVAR table to fix vertical metrics issue
    ttx -x "MVAR" $FILE

    ttxPath=${FILE/".ttf"/".ttx"}
    patchPath=${ttxPath/".ttx"/"-patch.ttx"}
    rm -rf $FILE

    echo "---------------------------------------------------"
    if [[ $fullVF == true && $splitVF == false ]]; then
        cp $ttxPath $patchPath
        if [[ $file != *"SC"* ]]; then
        cat $patchPath | tr '\n' '\r' | sed -e "s~<name>.*<\/name>~$(cat sources/scripts/helpers/patches/NAMEpatch.xml | tr '\n' '\r')~" | tr '\r' '\n' > $ttxPath
        fi
        if [[ $file == *"SC"* ]]; then
        cat $patchPath | tr '\n' '\r' | sed -e "s~<name>.*<\/name>~$(cat sources/scripts/helpers/patches/NAMEpatch-SC.xml | tr '\n' '\r')~" | tr '\r' '\n' > $ttxPath
        fi
        rm -rf $patchPath

        cp $ttxPath $patchPath
        echo "---------------------------------------------------"
        cat $patchPath | tr '\n' '\r' | sed -e "s~<STAT>.*<\/STAT>~$(cat sources/scripts/helpers/patches/STATpatch.xml | tr '\n' '\r')~" | tr '\r' '\n' > $ttxPath
        rm -rf $patchPath
    fi

    ttx $ttxPath
    rm -rf $ttxPath

    # if [[ $fullVF == false && $splitVF == true ]]; then
    #     # Marc's solution to fix VF metadata
    #     gftools fix-vf-meta $FILE
    #     mv "$FILE.fix" $FILE
    # fi
}

# for file in variable_ttf/*; do 
#     if [[ $file == *".ttf" ]]; then 
#         insertPatch $file
#     fi
# done

# ============================================================================
# Sort into final folder =====================================================

# set this to true/false at top of script
for file in variable_ttf/*; do 
    if [ -f "$file" ]; then
        fileName=$(basename $file)
        # fileName=${fileName/"Light"/"[wght]"}

        if [[ $fullVF == true && $splitVF == false ]]; then
            if [[ $file != *"SC"* ]]; then
                cp $file $finalLocation/$fileName
                echo "new VF location is " $finalLocation/$fileName
                fontbakery check-googlefonts $finalLocation/$fileName --ghmarkdown $finalLocation/${fileName/".ttf"/"-fontbakery-report.md"}
            fi
            if [[ $file == *"SC"* ]]; then
                cp $file $scFinalLocation/$fileName
                echo "new VF location is " $scFinalLocation/$fileName
                fontbakery check-googlefonts $scFinalLocation/$fileName --ghmarkdown $scFinalLocation/${fileName/".ttf"/"-fontbakery-report.md"}
            fi
        fi

        if [[ $splitVF == true && $fullVF == false ]]; then
            if [[ $file != *"Negative"* && $file != *"SC"* ]]; then
                cp $file $finalLocation/$fileName
                echo "new VF location is " $finalLocation/$fileName
                fontbakery check-googlefonts $finalLocation/$fileName --ghmarkdown $finalLocation/${fileName/".ttf"/"-fontbakery-report.md"}
            fi
            if [[ $file != *"Negative"* && $file == *"SC"* ]]; then
                cp $file $scFinalLocation/$fileName
                echo "new VF location is " $scFinalLocation/$fileName
                fontbakery check-googlefonts $scFinalLocation/$fileName --ghmarkdown $scFinalLocation/${fileName/".ttf"/"-fontbakery-report.md"}
            fi
            if [[ $file == *"Negative"* && $file != *"SC"* ]]; then
                cp $file $negFinalLocation/$fileName
                echo "new VF location is " $negFinalLocation/$fileName
                fontbakery check-googlefonts $negFinalLocation/$fileName --ghmarkdown $negFinalLocation/${fileName/".ttf"/"-fontbakery-report.md"}
            fi
            if [[ $file == *"Negative"* && $file == *"SC"* ]]; then
                cp $file $negScFinalLocation/$fileName
                echo "new VF location is " $negScFinalLocation/$fileName
                fontbakery check-googlefonts $negScFinalLocation/$fileName --ghmarkdown $negScFinalLocation/${fileName/".ttf"/"-fontbakery-report.md"}
            fi
        fi

    fi
done

rm -rf variable_ttf
