# Set bash to exit on errors and print all commands
set -x -e

#------------------------------------------------------------------------------
# Remove previous build folder
#------------------------------------------------------------------------------

# clear previous builds if they exist
if [ -d "instance_ttf" ]; then
  rm -rf instance_ttf
fi

#------------------------------------------------------------------------------
# Generated TTFs from glyph source
#------------------------------------------------------------------------------

glyphsSource="sources/sources-buildready/Signika-MM-prepped_designspace.glyphs"

echo $glyphsSource

tempGlyphsSource=${glyphsSource/".glyphs"/"-build.glyphs"}

## copy Glyphs file into temp file
cp $glyphsSource $tempGlyphsSource

## call fontmake to make all the static fonts
fontmake -g ${tempGlyphsSource} --output ttf --interpolate --overlaps-backend booleanOperations --no-subset
## OR to just make one static font, as a test, use:
# fontmake -g sources/sources-buildready/Signika-MM-prepped_designspace.glyphs -i "Signika Light" --output ttf --overlaps-backend booleanOperations

## clean up temp glyphs file
rm -rf $tempGlyphsSource

# #------------------------------------------------------------------------------
# # Generate SC file versions and remove SC glyphs from non-SC files
# #------------------------------------------------------------------------------

for file in instance_ttf/*; do 
if [ -f "$file" ]; then 
    echo "FILE"
    echo $file

    # For all Signika files the new file should be SignikaSC
    if [[ $file != *"SignikaNegative-"* ]]; then
        smallCapFile=${file/"Signika"/"SignikaSC"}
        oldFamilyName="Signika"
        newFamilyName="Signika SC"
    fi

    # For all SignikaNegative files the new file should be SignikaNegativeSC
    if [[ $file == *"SignikaNegative-"* ]]; then
        smallCapFile=${file/"SignikaNegative"/"SignikaNegativeSC"}
        oldFamilyName="Signika Negative"
        newFamilyName="Signika Negative SC"
    fi


    #--------------------------------------------------------------------------
    # Freeze smcp feature from $file into $smallCapFile
    #--------------------------------------------------------------------------
    # This means all glyphs of the smcp features will be swapped as if the smcp
    # feature was on
    python sources/scripts/helpers/pyftfeatfreeze.py -f 'smcp' $file $smallCapFile
    
    echo "subsetting smallcap font"
    echo $smallCapFile
    pyftsubset $smallCapFile --unicodes='*' --name-IDs='*' --glyph-names --layout-features="*" --layout-features-='smcp' --recalc-bounds --recalc-average-width

    # Replace the SC file with the pyftsubset output from the generated file
    rm -rf $smallCapFile
    mv ${smallCapFile/".ttf"/".subset.ttf"} $smallCapFile


    #--------------------------------------------------------------------------
    # Update names in font with smallcaps suffix
    #--------------------------------------------------------------------------
    smallCapSuffix="SC"
    python sources/scripts/helpers/replace-family-name.py "$smallCapFile" "$oldFamilyName" "$newFamilyName"

fi 
done

# ------------------------------------------------------------------------------
# Autohinting & fixes
# ------------------------------------------------------------------------------

for file in instance_ttf/*; do 
if [ -f "$file" ]; then 

    #--------------------------------------------------------------------------
    # Fix DSIG
    #--------------------------------------------------------------------------
    echo "fix DSIG in " ${file}
    gftools fix-dsig --autofix ${file}


    #--------------------------------------------------------------------------
    # Autohint with detailed info
    #--------------------------------------------------------------------------
    echo "TTFautohint " ${file}
    hintedFile=${file/".ttf"/"-hinted.ttf"}
    ttfautohint -I ${file} ${hintedFile} --increase-x-height 9 --stem-width-mode nnn
    cp ${hintedFile} ${file}
    rm -rf ${hintedFile}


    #--------------------------------------------------------------------------
    # Fixing some hinting issues with gftools
    #--------------------------------------------------------------------------
    echo "fix hinting in " ${file}
    gftools fix-hinting ${file}
    fixedFile=${file/".ttf"/".ttf.fix"}
    if [ -f "$fixedFile" ]; then
        echo "fixed file " ${fixedFile}
        cp ${fixedFile} ${file}
        rm -rf ${fixedFile}
    fi
fi 
done

#------------------------------------------------------------------------------
# Sort into final folder
#------------------------------------------------------------------------------

outputDir="fonts"

for file in instance_ttf/*; do 
if [ -f "$file" ]; then 
    fileName=$(basename $file)
    echo $fileName
    if [[ $file == *"Signika-"* ]]; then
        newDirectory=signika
    fi
    if [[ $file == *"SignikaNegative-"* ]]; then
        newDirectory=signikanegative
    fi
    if [[ $file == *"SignikaSC-"* ]]; then
        newDirectory=signikasc
    fi
    if [[ $file == *"SignikaNegativeSC-"* ]]; then
        newDirectory=signikanegativesc
    fi

    newPath=$outputDir/$newDirectory/$fileName
    cp ${file} ${newPath}
        
    fontbakePath=$outputDir/$newDirectory/fontbakery-checks/${fileName/".ttf"/"-fontbakery_checks.md"}

    fontbakery check-googlefonts ${newPath} --ghmarkdown $fontbakePath
fi
done

# # clean up build folders
rm -rf instance_ufo
rm -rf instance_ttf
rm -rf master_ufo