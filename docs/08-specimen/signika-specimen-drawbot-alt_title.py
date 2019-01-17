# -------------------------------------------------------------------
# code app switching ------------------------------------------------

## if you want to run this file from a code editor & command line, comment out the following line
runFromDrawbot = True

try:
    runFromDrawbot # checks if variable exists
    fileRoot = "/Users/stephennixon/type-repos/google-font-repos/signika-for-google/"

# if runFromDrawbot is commented out, this will set things up to run remotely
except NameError:
    # run with www.drawbot.com
    # run from root folder
    from drawBot import *
    fileRoot = "."

# -------------------------------------------------------------------
# set up vars -------------------------------------------------------

W, H = 800, 1200

newPage(W,H)

colorA = (0.8,0.8,0.9)
colorB = (0,0,0.25)

# fill(0.1)
fill(colorA[0],colorA[1],colorA[2])
rect(0,0,W/2,H)


fill(colorB[0],colorB[1],colorB[2])
rect(W/2,0,W/2,H)

# fill(0.8)

fontSizing = 24.7
align = "justified"
lineHeight = fontSizing*1.64
tracking = 4.30
# color = (1,0,0)

# -------------------------------------------------------------------
# normal charset ----------------------------------------------------

charSet = FormattedString()
charSet.font(f"{fileRoot}/fonts/signika/static/Signika-Regular.ttf")
charSet.fontSize(fontSizing)
charSet.align("left")
charSet.lineHeight(lineHeight)
charSet.tracking(tracking)

charSet.fill(colorB[0],colorB[1],colorB[2])
# charSet += glyphSet

glyph_names = open(f"{fileRoot}/docs/08-specimen/glyphNames.txt", "r")

for line in glyph_names:
    charSet.appendGlyph(line.replace('\n',''))
    
print(len(charSet))
    
padding = 20

stroke(1)

textBox(charSet, (padding, -80, W/2-padding*2, H-padding/2))

# -------------------------------------------------------------------
# negative charset --------------------------------------------------

charSet2 = FormattedString()
charSet2.font(f"{fileRoot}/fonts/signikanegative/static/SignikaNegative-Regular.ttf")
charSet2.fontSize(fontSizing)
charSet2.align("right")
charSet2.lineHeight(lineHeight)
charSet2.tracking(tracking*1.015)
charSet2.fill(colorA[0],colorA[1],colorA[2])


glyph_names2 = open(f"{fileRoot}/docs/08-specimen/glyphNames.txt", "r")
glyphList = []
for line in glyph_names2:
    glyphList.append(line.replace('\n',''))

for glyphName in glyphList[::-1]:
    charSet2.appendGlyph(glyphName)

textBox(charSet2, (W/2+padding,-80, W/2-padding*2, H-padding/2))
# print(charSet)

# saveImage("charset.pdf")

# -------------------------------------------------------------------
# Title -------------------------------------------------------------

# fill(colorA[0],colorA[1],colorA[2])
fill(colorB[0],colorB[1],colorB[2])
stroke(colorA[0],colorA[1],colorA[2])
strokeWidth(3)
titleHeight = 58
titleWidth = W-padding*2
rect((W-titleWidth)/2, H-titleHeight-padding, titleWidth,titleHeight)

fontName= FormattedString()

fontSizing = 60

fontName.fill(0,0,1)
fontName.fill(colorA[0],colorA[1],colorA[2])
fontName.strokeWidth(0.5)
fontName.fontSize(fontSizing)
fontName.tracking(2.2)
fontName.align("center")
fontName.font(f"{fileRoot}/fonts/signikanegative/static/SignikaNegative-Light.ttf")
fontName.lineHeight(fontSizing*1.55)
fontName.openTypeFeatures(smcp=True,c2sc=True)
fontName += "Signika & Signika Negative"

textBox(fontName, (padding, 0, W-padding*2, H))

# -------------------------------------------------------------------
# Save Image --------------------------------------------------------

path = f"{fileRoot}/docs/08-specimen/charset-tall-alt_title.png"
saveImage(path, imageResolution=144)
