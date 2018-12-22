# ### based on build script for Encode-Sans-VF, by Mike LaGuttuta
# ### requires a python 2 environment, for now



##############################################################################
############################### set vars below ###############################

# glyphsSource="sources/sources-buildready/Signika-MM-simple_rectangle_ds.glyphs"
glyphsSource="sources/sources-buildready/Signika-MM-prepped_designspace.glyphs"

timestampAndFontbakeInDist=false

keepDesignspace=true

############################### set vars above ###############################
##############################################################################

# # ============================================================================
# # Set up names ===============================================================

# # get font name from glyphs source
# VFname=`python sources/scripts/helpers/get-font-name.py ${glyphsSource}`
# # checking that the name has been pulled out of the source file
# echo "VF Name: ${VFname}"

# # smallCapFontName, e..g 'SignikaSC-VF'
# smallCapFontName=${VFname/"-VF"/"SC-VF"}

# ## make temp glyphs filename with "-build" suffix
# tempGlyphsSource=${glyphsSource/".glyphs"/"-Build.glyphs"}

# ## copy Glyphs file into temp file
# cp $glyphsSource $tempGlyphsSource

# # ============================================================================
# # Generate Variable Font =====================================================

# ## call fontmake to make a varfont
# fontmake -o variable -g $tempGlyphsSource

# ## keep designspace file if you want to look at values later
# if [ $keepDesignspace == true ]
# then
#     ## move font into dist, with timestamp – probably with a python script and datetime
#     ## and fontbake the font
#     echo "designspace in master_ufo folder"
# else
#     rm -rf master_ufo
# fi

# ## clean up temp glyphs file
# rm -rf $tempGlyphsSource

# # ============================================================================
# # SmallCap subsetting ========================================================


# echo making ${smallCapFontName}.ttf

# pyftfeatfreeze.py -f 'smcp' -S -U SC variable_ttf/${VFname}.ttf variable_ttf/${smallCapFontName}.ttf

# ttx variable_ttf/${VFname}.ttf
# ttxPath="variable_ttf/${VFname}.ttx"

# #get glyph names, minus .smcp glyphs
# subsetGlyphNames=`python sources/scripts/helpers/get-smallcap-subset-glyphnames.py $ttxPath`

# # echo $subsetGlyphNames
# echo "subsetting smallcap font"

# # subsetting with subsetGlyphNames list
# pyftsubset variable_ttf/${smallCapFontName}.ttf ${subsetGlyphNames}

# # remove feature-frozen font & simplifying name of subset font

# subsetSmallCapFontName=${smallCapFontName/"VF"/"VF.subset"}

# rm -rf variable_ttf/${smallCapFontName}.ttf

# mv variable_ttf/${subsetSmallCapFontName}.ttf variable_ttf/${smallCapFontName}.ttf

# # removes temp ttx file
# rm -rf $ttxPath


# # ============================================================================
# # Autohinting ================================================================

# for file in variable_ttf/*; do 
# if [ -f "$file" ]; then 
#     # echo "fix DSIG in " ${file}
#     gftools fix-dsig --autofix ${file}

#     echo "TTFautohint " ${file}
#     # autohint with detailed info
#     hintedFile=${file/".ttf"/"-hinted.ttf"}
    
#     # Hint with TTFautohint-VF ... currently janky – it would be better to properly add this dependency
#     # https://groups.google.com/forum/#!searchin/googlefonts-discuss/ttfautohint%7Csort:date/googlefonts-discuss/WJX1lrzcwVs/SIzaEvntAgAJ
#     # ./Users/stephennixon/Environments/gfonts3/bin/ttfautohint-vf ${ttfPath} ${ttfPath/"-unhinted.ttf"/"-hinted.ttf"}
#     echo "------------------------------------------------"
#     echo ttfautohint-vf $file $hintedFile  --increase-x-height 9
#     echo "------------------------------------------------"
#     ttfautohint-vf -I $file $hintedFile  --increase-x-height 9

#     cp ${hintedFile} ${file}
#     rm -rf ${hintedFile}

#     # open VF in default program; hopefully you have FontView
#     open ${file}
# fi 
# done

# ============================================================================
# OpenType table fixes =======================================================

insertPatch()
{
    FILE=$1
    TABLE=$2
    PATCH=$3

    echo $FILE $TABLE $PATCH
    
    ttx $FILE
    ttxPath=${FILE/".ttf"/".ttx"}
    patchPath=${ttxPath/".ttx"/"-patch.ttx"}
    # rm -rf $FILE

    cp $ttxPath $patchPath
    echo "---------------------------------------------------"
    echo `$patchPath | tr '\n' '\r' | sed -e `s~<$TABLE>.*<\/$TABLE>~$(cat $PATCH | tr '\n' '\r')~` | tr '\r' '\n' > $ttxPath`
    echo "---------------------------------------------------"
    cat $patchPath | tr '\n' '\r' | sed -e `s~<$TABLE>.*<\/$TABLE>~$(cat $PATCH | tr '\n' '\r')~` | tr '\r' '\n' > $ttxPath
    # rm -rf $patchPath

    ttx $ttxPath
    # rm -rf $ttxPath
}

for file in variable_ttf/*; do 
    if [[ $file == *".ttf" ]]; then 
        if [[ $file == *"SC"* ]]; 
        then 
            insertPatch $file name sources/scripts/helpers/patches/NAMEpatch-SC.xml
        fi
        if [[ $file != *"SC"* ]]; 
        then
            insertPatch $file name sources/scripts/helpers/patches/NAMEpatch.xml
        fi
    fi
done

# ============================================================================
# Sort into final folder =====================================================

# # set this to true/false at top of script
# for file in variable_ttf/*; do 
#     if [ -f "$file" ]; then 
#         if [ $timestampAndFontbakeInDist == true ]
#         then
#             newFontLocation=`python sources/scripts/helpers/distdate.py ${file}`

#             fontbakery check-googlefonts ${newFontLocation}/${VFname}.ttf --ghmarkdown ${newFontLocation}/${VFname}-fontbakery-report.md

#             echo "new VF location is " ${newFontLocation}
#         else
#             ## move font into fonts/, then fontbake
#             finalFontLocation=fonts/signika/full_vf
#             fileName=$(basename $file)
#             cp $file $finalFontLocation/$fileName
#             echo "new VF location is " $finalFontLocation/$fileName

#             fontbakery check-googlefonts $finalFontLocation/$fileName --ghmarkdown $finalFontLocation/${fileName/".ttf"/"-fontbakery-report.md"}
#         fi
#     fi
# done

# rm -rf variable_ttf
