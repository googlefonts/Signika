
for g in Glyphs.font.glyphs:
	if g.layers[0].width != g.layers[2].width or g.layers[1].width != g.layers[3].width:
		print("Manually check glyph", g)	