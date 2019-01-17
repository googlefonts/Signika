# run with www.drawbot.com
# run from root folder

## if you want to run this file from a code editor/command line, comment out the following line
# runFromDrawbot = True

try:
    runFromDrawbot # checks if variable exists
    fileRoot = "/Users/stephennixon/type-repos/google-font-repos/signika-for-google/"
except NameError:
    from drawBot import *
    fileRoot = "."

W, H = 800, 1200

newPage(W,H)

# fill(0.1)
fill(0.8,0.8,0.85)
rect(0,0,W/2,H)


fill(0,0,0.1)
rect(W/2,0,W/2,H)

# fill(0.8)

fontSizing = 24.7
align = "justified"
lineHeight = fontSizing*1.75
tracking = 4.30
# color = (1,0,0)

# normal charset

charSet = FormattedString()
charSet.font(f"{fileRoot}/fonts/signika/static/Signika-Regular.ttf")
charSet.fontSize(fontSizing)
charSet.align("right")
charSet.lineHeight(lineHeight)
charSet.tracking(tracking)

charSet.fill(0)
# charSet += glyphSet

glyph_names = open(f"{fileRoot}/docs/08-specimen/glyphNames.txt", "r")

for line in glyph_names:
    charSet.appendGlyph(line.replace('\n',''))
    
print(len(charSet))
    
padding = 20

stroke(1)

textBox(charSet, (padding, -8, W/2-padding*2, H-padding/2))

# negative charset

charSet2 = FormattedString()
charSet2.font(f"{fileRoot}/fonts/signikanegative/static/SignikaNegative-Regular.ttf")
charSet2.fontSize(fontSizing)
charSet2.align("left")
charSet2.lineHeight(lineHeight)
charSet2.tracking(tracking*1.015)
charSet2.fill(1)


glyph_names2 = open(f"{fileRoot}/docs/08-specimen/glyphNames.txt", "r")
glyphList = []
for line in glyph_names2:
    glyphList.append(line.replace('\n',''))

for glyphName in glyphList[::-1]:
    charSet2.appendGlyph(glyphName)

textBox(charSet2, (W/2+padding+7,-8, W/2-padding*2, H-padding/2))
# print(charSet)

# saveImage("charset.pdf")


fill(1,0,0)

fontName= FormattedString()

fontSizing = 180

fontName.fill(0.35,0.35,0.5,0.25)
fontName.strokeWidth(0.5)
# fontName.stroke(0.35,0.35,1,1)
# fontName.stroke(0,1,0)
fontName.fontSize(fontSizing)
fontName.tracking(0)
fontName.align("center")
fontName.font(f"{fileRoot}/fonts/signika/static/Signika-Bold.ttf")
fontName.lineHeight(fontSizing*1.55)
fontName.openTypeFeatures(smcp=True,c2sc=True)
fontName += "Signika"
# fontName.openTypeFeatures(smcp=True,c2sc=True)
fontName += " ••• & •••"
# fontName.openTypeFeatures(smcp=False,c2sc=False)
fontName += " Signika"
fontName += " Negative"


textBox(fontName, (padding, 0, W-padding*2, H-padding*1.3))

path = f"{fileRoot}/docs/08-specimen/charset-tall.png"
saveImage(path, imageResolution=144)
