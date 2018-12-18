# copyToFontDir()
# {
#     DIRECTORY=$1
#     if [ ! -d "$DIRECTORY" ]; then
#         mkdir ${outputDir}/$DIRECTORY
#     fi

#     newPath=${outputDir}/$DIRECTORY/${fileName}
#     cp ${file} ${newPath}
# }

fontsDir="fonts"

fontbakeFile()
{
    FILEPATH=$1
    fontbakery check-googlefonts ${FILEPATH} --ghmarkdown ${FILEPATH/".ttf"/"-fontbakery-report.md"}
}

for file in fonts/*/*; do 
if [ -f "$file" ]; then 
    fileName=$(basename $file)
    # echo $fileName
    if [[ $fileName == "Signika-"* ]] && [[ $fileName == *".ttf" ]]; then
        echo fileName
        echo ${file}
        fontbakeFile ${file}
    fi
    if [[ $fileName == "SignikaNegative-"* ]] && [[ $fileName == *".ttf" ]]; then
        fontbakeFile ${file}
    fi
    if [[ $fileName == "SignikaSC-"* ]] && [[ $fileName == *".ttf" ]]; then
        fontbakeFile ${file}
    fi
    if [[ $fileName == "SignikaNegativeSC-"* ]] && [[ $fileName == *".ttf" ]]; then
        fontbakeFile ${file}
    fi
fi 
done