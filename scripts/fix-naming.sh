#!/bin/sh

fonts=$(ls ./fonts/variable_negative/*.ttf)
for font in $fonts;
do
    gftools rename-font $font "Signika Negative" -o $font.fix;
    mv "$font.fix" $font
	gftools update-nameids -c "Copyright 2018 The Signika Project Authors (https://github.com/googlefonts/Signika)." $font;
    mv "$font.fix" $font;
done