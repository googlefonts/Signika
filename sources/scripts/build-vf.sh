set -x -e

source="sources/sources-buildready/Signika-MM-prepped_designspace.glyphs"
pathNOSC="fonts/signikavf/Signika[NEGA,wght].ttf"
pathSC="fonts/signikavfsc/Signika[NEGA,wght]SC.ttf"
tmp="variable_ttf/Signika-VF.ttf"
tmpSC="variable_ttf/Signika-VFSC.ttf"

#------------------------------------------------------------------------------
# Remove previous build folder
#------------------------------------------------------------------------------
if [ -d "variable_ttf" ]; then
  rm -rf variable_ttf
fi


#------------------------------------------------------------------------------
# Compile from sources
#------------------------------------------------------------------------------
## make temp glyphs file with "-build" suffix
tmpSource=${source/".glyphs"/"-Build.glyphs"}

## copy Glyphs file into temp file
cp $source $tmpSource
fontmake -g $tmpSource -o variable

python sources/scripts/helpers/replace-family-name.py $tmp "Signika Light" "Signika"

#------------------------------------------------------------------------------
# Smallcap subsetting
#------------------------------------------------------------------------------

# Making a SC "frozen" font
# This mapps all smcp glyphs to their "substitute" and also renames their names with suffix "SC"
python sources/scripts/helpers/pyftfeatfreeze.py -f 'smcp' $tmp $tmpSC

# Removing SC from the font
# This removes the smcp features and involved glyphs
echo "subsetting smallcap font"
echo $tmpSC
pyftsubset $tmpSC --unicodes="*" --name-IDs='*' --glyph-names --layout-features="*" --layout-features-="smcp"

# Replace the SC file with the pyftsubset generated .subset file
rm -rf $tmpSC
mv ${tmpSC/".ttf"/".subset.ttf"} $tmpSC

#--------------------------------------------------------------------------
# Update names in font with smallcaps suffix
#--------------------------------------------------------------------------
python sources/scripts/helpers/add-smallcaps-suffix.py $tmpSC "SC" "Signika"


for file in variable_ttf/*; do 
if [ -f "$file" ]; then

    #--------------------------------------------------------------------------
    # Fix DSIG
    #--------------------------------------------------------------------------
    echo "Fix DSIG in " ${file}
    file="${file}"
    gftools fix-dsig --autofix ${file}


    #--------------------------------------------------------------------------
    # Autohint with detailed info
    #--------------------------------------------------------------------------
    echo "TTFautohint ${file}" 
    hintedFile=${file/".ttf"/"-hinted.ttf"}

    ./sources/scripts/helpers/ttfautohint-vf -I $file $hintedFile --stem-width-mode nnn --increase-x-height 9
    gftools fix-hinting $hintedFile # will create a file suffixed with .fix
    fixedFile="${hintedFile}.fix"
    cp $fixedFile $file # copy back to original ttf

    rm -rf $hintedFile # remove the -hinted.ttf file
    rm -rf $fixedFile # remove the -hinted.ttf.fix file


    #--------------------------------------------------------------------------
    # Various fixes MVAR
    #--------------------------------------------------------------------------
    echo "Fix MVAR and other name tables in ${file}"
    gftools fix-unwanted-tables $file

fi 
done


#------------------------------------------------------------------------------
# Copy to final location
#------------------------------------------------------------------------------
echo "Copy $tmp to output location $path"
cp $tmp $pathNOSC
echo "Copy $tmpSC to output location $pathSC"
cp $tmpSC $pathSC


#------------------------------------------------------------------------------
# Run fontbakery checks on the final files
#------------------------------------------------------------------------------
echo "Run fontbakery checks"
fontbakery check-googlefonts $pathNOSC --ghmarkdown ${pathNOSC/".ttf"/"-fontbakery-report.md"}
fontbakery check-googlefonts $pathSC --ghmarkdown ${pathSC/".ttf"/"-fontbakery-report.md"}
