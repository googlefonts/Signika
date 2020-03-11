source="sources/sources-buildready/Signika-MM-prepped_designspace.glyphs"
pathNOSC="fonts/signikavf/Signika[NEGA,wght].ttf"
pathSC="fonts/signikavfsc/Signika[NEGA,wght]SC.ttf"
tmp="variable_ttf/Signika-VF.ttf"

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

fontmake -o variable -g $tmpSource

# # Add the [axes] to all names according to GF naming scheme
# for file in variable_ttf/*; do 
#     cp $file ${file/"-"/"[NEGA,wght]"}
#     rm $file
# done


#------------------------------------------------------------------------------
# Smallcap subsetting
#------------------------------------------------------------------------------

# Making a SC "frozen" font
# This mapps all smcp and c2sc glyphs to their "substitute" and also renames their names with suffix "SC"
tmpSC="${tmp/.ttf/SC.ttf}"
python sources/scripts/helpers/pyftfeatfreeze.py -S -U "SC" -f 'c2sc,smcp' $tmp $tmpSC

# Removing SC from the font
# This removes the smcp and c2sc features and involved glyphs
tmpNOSC="${tmp/.ttf/NO-SC.ttf}"
pyftsubset $tmp --notdef-glyph --name-IDs='*' --unicodes="*" --output-file=$tmpNOSC --layout-features-="c2sc,smcp"
# Rename the "NO-SC" file to the original file
rm -rf $tmp
cp $tmpNOSC $tmp
rm -rf $tmpNOSC


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

    ttfautohint-vf -I $file $hintedFile --stem-width-mode nnn --increase-x-height 9
    gftools fix-hinting $hintedFile # will create a file suffixed with .fix
    fixedFile="${hintedFile}.fix"
    cp $fixedFile $file # copy back to original ttf

    rm -rf $hintedFile # remove the -hinted.ttf file
    rm -rf $fixedFile # remove the -hinted.ttf.fix file


    #--------------------------------------------------------------------------
    # Various fixes MVAR
    #--------------------------------------------------------------------------
    # TODO update names (for SC), insert STAT
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
