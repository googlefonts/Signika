############################################
################# set vars #################

glyphsSource="sources/experiments/Signika-MM-simple_rectangle_ds.glyphs"

## if the Glyphs source has a non-rectangular master/instance arrangement, this fixes it (WIP)
fixGlyphsDesignspace=true

################# set vars #################
############################################

pwd

echo $glyphsSource

tempGlyphsSource=${glyphsSource/".glyphs"/"-build.glyphs"}

## copy Glyphs file into temp file
cp $glyphsSource $tempGlyphsSource




fontmake -g ${tempGlyphsSource} --output ttf --interpolate --overlaps-backend booleanOperations
## OR to just make one static font, as a test, use:
## fontmake -g sources/split/Encode-Sans-fixed_designspace.glyphs -i "Encode Sans Condensed Bold" --output ttf --overlaps-backend booleanOperations

## clean up temp glyphs file
rm -rf $tempGlyphsSource

# python sources/scripts/helpers/shorten-nameID-4-6.py instance_ttf

for file in instance_ttf/*; do 
if [ -f "$file" ]; then 
    echo "fix DSIG in " ${file}
    gftools fix-dsig --autofix ${file}

    echo "TTFautohint " ${file}
    # autohint with detailed info
    hintedFile=${file/".ttf"/"-hinted.ttf"}
    ttfautohint -I ${file} ${hintedFile}
    cp ${hintedFile} ${file}
    rm -rf ${hintedFile}
fi 
done


copyToFontDir()
{
    DIRECTORY=$1
    if [ ! -d "$DIRECTORY" ]; then
        mkdir ${outputDir}/$DIRECTORY
        mkdir ${outputDir}/$DIRECTORY/static
    fi

    newPath=${outputDir}/$DIRECTORY/static/${fileName}
    cp ${file} ${newPath}
}

fontbakeFile()
{
    FILEPATH=$1
    fontbakery check-googlefonts ${FILEPATH} --ghmarkdown ${FILEPATH/".ttf"/"-fontbakery-report.md"}
}

outputDir="fonts"

for file in instance_ttf/*; do 
if [ -f "$file" ]; then 
    fileName=$(basename $file)
    echo $fileName
    if [[ $file == *"Signika-"* ]]; then
        copyToFontDir signika
        fontbakeFile ${newPath}
    fi
    if [[ $file == *"SignikaNegative-"* ]]; then
        copyToFontDir signikanegative
        fontbakeFile ${newPath}
    fi
    if [[ $file == *"SignikaSC-"* ]]; then
        copyToFontDir signikasc
        fontbakeFile ${newPath}
    fi
    if [[ $file == *"SignikaNegativeSC-"* ]]; then
        copyToFontDir signikanegativesc
        fontbakeFile ${newPath}
    fi
fi 
done

# # clean up build folders
rm -rf instance_ufo
rm -rf instance_ttf
rm -rf master_ufo