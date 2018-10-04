import os
import shutil
import fontmake
from fontmake.font_project import FontProject
from datetime import datetime

######################################
##### DEFINE THE VARIABLES BELOW #####
 
familyName = 'Signika' # use for roman
# familyName = 'PlayfairItalic' # use for italic

DS_PATH = 'master_ufo/Signika.designspace' # use for designspace
GLYPHS_PATH = 'sources/Signika-MM-varprep.glyphs' # use for glyphs file

##### DEFINE THE VARIABLES ABOVE #####
######################################

# make timestamped folder in dist, like `SampleFont_2015-10-21-017_03`
currentDatetime = datetime.now().strftime('%Y-%m-%d-%H_%M')
outputFolder = 'dist/' + GLYPHS_PATH.replace('sources/', '').replace('.glyphs', '-VF-') + currentDatetime + '/'
if not os.path.exists(outputFolder):
    os.makedirs(outputFolder)


# define run args
def getRunArguments():
    u"""Arguments to be passed to a fontmake project run. The values below
    make Decovar build without errors. See also fontmake.__main__.py."""

    args = {
        'subset': None,
        'use_production_names': False,
        #'mark_writer_class': None,
        'reverse_direction': False,
        #'kern_writer_class': None,
        'interpolate_binary_layout': False,
        'remove_overlaps': True,
        'autohint': None,
        'conversion_error': None,
        #'no_round': False,
        'masters_as_instances': False,
        'interpolate': False,
        'use_afdko': False,
        'subroutinize': True,
        'output':['variable'],
        'designspace_path': 'master_ufo/' + familyName + '.designspace'
        # 'instance_dir': outputFolder
    }
    return args

project = FontProject()

args = getRunArguments()

print(project.run_from_designspace(**args))
# print(project.run_from_glyphs(glyphs_path=GLYPHS_PATH, **args))

# move font to the timestamped folder in dist
defaultFontPath = 'variable_ttf/' + familyName + '-VF.ttf'
# defaultFontPath = f"variable_ttf/{familyName}-VF.ttf"
newFontPath = outputFolder + familyName + '-VF.ttf'
# newFontPath = f'{outputFolder}{familyName}-VF.ttf'
shutil.move(defaultFontPath, newFontPath)

# remove now-empty default folder
if os.path.exists('variable_ttf'):
    os.rmdir('variable_ttf')

# open varfont in FontView (or whatever is set as the default app to view varfont files)
os.system('open %s' % newFontPath)

# run fontbakery check on new font
fontbakeryCommand = 'fontbakery check-googlefonts ' + newFontPath + ' --ghmarkdown ' + outputFolder + 'fontbakery-report.md'
# fontbakeryCommand = f'fontbakery check-googlefonts {newFontPath} --ghmarkdown {outputFolder} fontbakery-report.md'
# print("fontbakeryCommand is " + fontbakeryCommand)
print(os.system(fontbakeryCommand))