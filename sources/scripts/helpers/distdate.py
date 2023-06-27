import sys
import os
import shutil
from datetime import datetime

arg = sys.argv[-1]

if "/" in arg:
    fontFile = arg.split("/")[1]
else:
    fontFile = arg

fontName = fontFile.split(".")[0]

# make timestamped folder in dist, like `SampleFont_2015-10-21-017_03`
currentDatetime = datetime.now().strftime('%Y-%m-%d-%H_%M')

# outputFolder = f'dist/{fontName}-{currentDatetime}'
outputFolder = f'dist/{currentDatetime}'


if not os.path.exists(outputFolder):
    os.makedirs(outputFolder)

defaultFontPath = arg
newFontPath = f'{outputFolder}/{fontFile}'
shutil.move(defaultFontPath, newFontPath)

print(outputFolder)

sys.exit(0)
