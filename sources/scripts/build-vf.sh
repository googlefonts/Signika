set -x -e

while [ ! $# -eq 0 ]
    do
    case "$1" in
        --full | -f)
            fullVF=true
            splitVF=false
            negativeSplit=false

            glyphsSource="sources/sources-buildready/Signika-MM-prepped_designspace.glyphs"
            finalLocation="fonts/signika/full_vf"
            scFinalLocation="fonts/signikasc/full_vf"
        ;;
        --normal | -n)
            fullVF=false
            splitVF=true

            glyphsSource="sources/sources-buildready/Signika-MM-prepped_designspace-split.glyphs"
            finalLocation="fonts/signika/split_vf"
            scFinalLocation="fonts/signikasc/split_vf"

            negativeSplit=true

            negGlyphsSource="sources/sources-buildready/Signika-MM-prepped_designspace-split-negative.glyphs"
            negFinalLocation="fonts/signikanegative/split_vf"
            negScFinalLocation="fonts/signikanegativesc/split_vf"
        ;;
        *) 
            echo "Error: please supply an argument of --normal (-n) or --full (-f)"
    esac
    shift
done

# if varfont folder exists, clean it up
if [ -d "variable_ttf" ]; then
  rm -rf variable_ttf
fi


##############################################################################
############################### set vars below ###############################

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

# smallCapFontName, e..g 'SignikaSC-VF'
smallCapFontName=${VFname/"-VF"/"SC-VF"}

## make temp glyphs filename with "-build" suffix
tempGlyphsSource=${glyphsSource/".glyphs"/"-Build.glyphs"}

## copy Glyphs file into temp file
cp $glyphsSource $tempGlyphsSource

if [ $negativeSplit == true ]
then
    # get font name from glyphs source
    negVFname=`python sources/scripts/helpers/get-font-name.py ${negGlyphsSource}`
    # checking that the name has been pulled out of the source file
    echo "Negative VF Name: ${negVFname}"

    # smallCapFontName, e..g 'SignikaSC-VF'
    negSmallCapFontName=${negVFname/"-VF"/"SC-VF"}

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

## keep designspace file if you want to look at values later
if [ $keepDesignspace == true ]
then
    echo "designspace in master_ufo folder"
else
    rm -rf master_ufo
fi

## clean up temp glyphs file
rm -rf $tempGlyphsSource
if [ $negativeSplit == true ]
then
    rm -rf $negTempGlyphsSource
fi

# ============================================================================
# SmallCap subsetting ========================================================

subsetSmallCaps()
{
    FILE=$1
    SC_NAME=$2

    echo making ${smallCapFontName}.ttf

    python sources/scripts/helpers/pyftfeatfreeze.py -f 'smcp' -S -U SC $FILE $SC_NAME

    ttx $FILE
    # ttxPath="variable_ttf/${VFname}.ttx"
    ttxPath=${FILE/".ttf"/".ttx"}

    #get glyph names, minus .smcp glyphs
    subsetGlyphNames=`python sources/scripts/helpers/get-smallcap-subset-glyphnames.py $ttxPath`

    # echo $subsetGlyphNames
    echo "subsetting smallcap font"

    # subsetting with subsetGlyphNames list
    pyftsubset $SC_NAME ${subsetGlyphNames} --glyph-names

    # remove feature-frozen font & simplifying name of subset font

    subsetSmallCapFontName=${SC_NAME/"VF"/"VF.subset"}

    rm -rf $SC_NAME

    mv ${subsetSmallCapFontName} $SC_NAME

    # removes temp ttx file
    rm -rf $ttxPath
}

subsetSmallCaps variable_ttf/${VFname}.ttf variable_ttf/${smallCapFontName}.ttf

if [ $negativeSplit == true ]
then
    subsetSmallCaps variable_ttf/${negVFname}.ttf variable_ttf/${negSmallCapFontName}.ttf
fi


# ============================================================================
# Autohinting ================================================================

for file in variable_ttf/*; do 
if [ -f "$file" ]; then 
    # echo "fix DSIG in " ${file}
    gftools fix-dsig --autofix ${file}

    echo "TTFautohint " ${file}
    # autohint with detailed info
    hintedFile=${file/".ttf"/"-hinted.ttf"}
    
    # Hint with TTFautohint-VF ... currently janky – it would be better to properly add this dependency
    # https://groups.google.com/forum/#!searchin/googlefonts-discuss/ttfautohint%7Csort:date/googlefonts-discuss/WJX1lrzcwVs/SIzaEvntAgAJ
    # ./Users/stephennixon/Environments/gfonts3/bin/ttfautohint-vf ${ttfPath} ${ttfPath/"-unhinted.ttf"/"-hinted.ttf"}
    echo "------------------------------------------------"
    echo ttfautohint-vf $file $hintedFile  --increase-x-height 9 --stem-width-mode nnn
    echo "------------------------------------------------"
    ttfautohint-vf -I $file $hintedFile  --increase-x-height 9 --stem-width-mode nnn

    cp ${hintedFile} ${file}
    rm -rf ${hintedFile}

    # open VF in default program; hopefully you have FontView
    open ${file}
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

    cp $ttxPath $patchPath
    echo "---------------------------------------------------"
    if [[ $fullVF == true && $splitVF == false ]]; then
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

    # add patches for normal-split VF

    if [[ $splitVF == true && $fullVF == false ]]; then
        if [[ $file != *"Negative"* && $file != *"SC"* ]]; then
        cat $patchPath | tr '\n' '\r' | sed -e "s~<name>.*<\/name>~$(cat sources/scripts/helpers/patches/NAMEpatch-split.xml | tr '\n' '\r')~" | tr '\r' '\n' > $ttxPath
        fi
        if [[ $file != *"Negative"* && $file == *"SC"* ]]; then
        cat $patchPath | tr '\n' '\r' | sed -e "s~<name>.*<\/name>~$(cat sources/scripts/helpers/patches/NAMEpatch-split-SC.xml | tr '\n' '\r')~" | tr '\r' '\n' > $ttxPath
        fi
        if [[ $file != *"Negative"* ]]; then
        rm -rf $patchPath
        fi
    fi

    if [[ $negativeSplit == true && $fullVF == false ]]; then
        if [[ $file == *"Negative"* && $file != *"SC"* ]]; then
        cat $patchPath | tr '\n' '\r' | sed -e "s~<name>.*<\/name>~$(cat sources/scripts/helpers/patches/NAMEpatch-split-neg.xml | tr '\n' '\r')~" | tr '\r' '\n' > $ttxPath
        fi
        if [[ $file == *"Negative"* && $file == *"SC"* ]]; then
        cat $patchPath | tr '\n' '\r' | sed -e "s~<name>.*<\/name>~$(cat sources/scripts/helpers/patches/NAMEpatch-split-neg-SC.xml | tr '\n' '\r')~" | tr '\r' '\n' > $ttxPath
        fi
        if [[ $file == *"Negative"* ]]; then
        rm -rf $patchPath
        fi
    fi

    ttx $ttxPath
    rm -rf $ttxPath
}

for file in variable_ttf/*; do 
    if [[ $file == *".ttf" ]]; then 
        insertPatch $file
    fi
done

# ============================================================================
# Sort into final folder =====================================================

# set this to true/false at top of script
for file in variable_ttf/*; do 
    if [ -f "$file" ]; then 
        if [ $timestampAndFontbakeInDist == true ]
        then
            newFontLocation=`python sources/scripts/helpers/distdate.py ${file}`

            fontbakery check-googlefonts ${newFontLocation}/${VFname}.ttf --ghmarkdown ${newFontLocation}/${VFname}-fontbakery-report.md

            echo "new VF location is " ${newFontLocation}
        else
            fileName=$(basename $file)

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
    fi
done

rm -rf variable_ttf
