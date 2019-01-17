W, H = 800, 1200

newPage(W,H)

# fill(0.1)
fill(0.35,0,0.1)
rect(0,0,W,H)

# fill(0.8)

charSet = FormattedString()

# charSet.font("./EncodeSans-VF.ttf")
charSet.font("../../fonts/signika/static/Signika-Regular.ttf")
# charSet.fontVariations(wght=400.0,wdth=100.0)

# fontSizing = 30
fontSizing = 26

charSet.fontSize(fontSizing)
charSet.align("justified")
charSet.lineHeight(fontSizing*1.78)
# charSet.tracking(0.32)
charSet.tracking(4.15)
charSet.fill(1)
# charSet += glyphSet

glyph_names = open("/Users/stephennixon/type-repos/google-font-repos/signika-for-google/docs/08-specimen/glyphNames.txt", "r")

# glyphList = glyph_names.readlines()

# print(str(glyph_names).split(" ")

for line in glyph_names:
    print(type(line))
    print(line.replace('\n',''))
# for glyph in glyphNamesSignika3.glyphNames:
#     # print(glyph)
    charSet.appendGlyph(line.replace('\n',''))
    
print(len(charSet))
    
padding = 20

stroke(1)

# rect(padding, 0, W-padding*2, H-padding)

# charSet.appendGlyph(listFontGlyphNames())
textBox(charSet, (padding, -8, W-padding*2, H-padding/2))
# print(charSet)

# saveImage("charset.pdf")


fill(1,0,0)

fontName= FormattedString()

fontSizing = 190

fontName.fill(1,1,1,0.25)
fontName.fontSize(fontSizing)
fontName.tracking(0)
fontName.align("center")
fontName.font("../../fonts/signika/static/Signika-Bold.ttf")
fontName.lineHeight(fontSizing*.85)
fontName += "Signika"
fontName += " => & <="
fontName += " Signika"
fontName += " Negative"


textBox(fontName, (padding, 0, W-padding*2, H-padding*1.3))


saveImage("charset-tall3.png", imageResolution=144)
