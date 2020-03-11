source="sources/sources-buildready/Signika-MM-prepped_designspace.glyphs"
foldername="fonts/signikavf"
filename="SignikaVF[NEGA,wght].ttf"
output="${foldername}/${filename}"

# if varfont folder exists, clean it up
if [ -d "variable_ttf" ]; then
  rm -rf variable_ttf
fi

## make temp glyphs filename with "-build" suffix
tmpSource=${source/".glyphs"/"-Build.glyphs"}

## copy Glyphs file into temp file
cp $source $tmpSource

fontmake -o variable -g $tmpSource

# Add the [axes] to all names according to GF naming scheme
for file in variable_ttf/*; do 
    cp $file ${file/"-VF"/"VF[NEGA,wght]"}
    rm $file
done



# # Smallcap subsetting
# ttx "variable_ttf/SignikaVF[NEGA,wght].ttf"
# ttxPath="variable_ttf/SignikaVF[NEGA,wght].ttx"
# subsetGlyphNames=`python sources/scripts/helpers/get-smallcap-subset-glyphnames.py $ttxPath`
# rm -rf $ttxPath

# echo $subsetGlyphNames
    
# echo "subsetting smallcap font"
# # subsetting with subsetGlyphNames list
# pyftsubset --name-IDs='*' $smallCapFile $subsetGlyphNames --glyph-names --notdef-glyph

# subsetSmallCapFile=${smallCapFile/".ttf"/".subset.ttf"}
# rm -rf $smallCapFile
# mv $subsetSmallCapFile $smallCapFile

# smallCapSuffix="SC"
# # update names in font with smallcaps suffix
# python sources/scripts/helpers/add-smallcaps-suffix.py $smallCapFile $smallCapSuffix "$familyName"




# Fix DSIG
echo "Fix DSIG in " ${file}
file="variable_ttf/${filename}"
gftools fix-dsig --autofix ${file}


# Autohint with detailed info
echo "TTFautohint ${file}" 
hintedFile=${file/".ttf"/"-hinted.ttf"}

ttfautohint-vf -I $file $hintedFile --stem-width-mode nnn --increase-x-height 9
gftools fix-hinting $hintedFile # will create a file suffixed with .fix
$fixedFile="${hintedFile}.fix"
cp ${fixedFile} ${file} # copy back to original ttf

rm -rf ${hintedFile} # remove the -hinted.ttf file
rm -rf ${fixedFile} # remove the -hinted.ttf.fix file


# TODO update names (for SC), insert STAT


# Removes MVAR
echo "Fix MVAR and other name tables in ${file}"
gftools fix-unwanted-tables $file

# Copy to final location
echo "Copy file ${file} to output location ${output}"
cp $file $output

# Run fontbakery checks on the final files
echo "Run fontbakery checks"
fontbakery check-googlefonts $output --ghmarkdown ${output/".ttf"/"-fontbakery-report.md"}