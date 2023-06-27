review = []
for g in Glyphs.font.glyphs:
	if round(g.layers[0].width) != round(g.layers[2].width) or round(g.layers[1].width) != round(g.layers[3].width):
		print("Check glyph", g, g.layers[0].width, g.layers[2].width, g.layers[1].width, g.layers[3].width)
		review.append(g)

Glyphs.font.newTab(" ".join(["/" + g.name for g in review]))