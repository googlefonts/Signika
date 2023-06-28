# Script helper to sync layers for Thin and Negative Thing as well as Bold and
# Negative Bold WIDTHS.
# The negative masters are glyphs interpolated from wght, but their widths are
# slightly off from their non-negative. To sync their widths, this script looks
# at the width different and rectivfies their sidebearings in proportion to
# the original glyph's sidebearing proportions.

glyphs = [l.parent for l in Glyphs.font.selectedLayers]

def syncLayerWidth(src, dst):
	print("syncWidth", src, dst)
	add_left = 0
	add_right = 0
	
	src.LSB = round(src.LSB)
	src.width = round(src.width)
	src.RSB = round(src.RSB)
	
	dst.LSB = round(dst.LSB)
	dst.width = round(dst.width)
	dst.RSB = round(dst.RSB)	
	print("src", src.LSB, src.width, src.RSB)
	print("dst", dst.LSB, dst.width, dst.RSB)
	
	missing = src.width - dst.width
	src_SB = src.LSB + src.RSB
	
	if src_SB == 0:
		relative_LSB = 0
		relative_RSB = 0
	else:
		relative_LSB = src.LSB / src_SB
		relative_RSB = src.RSB / src_SB
		
	print("missing", missing, relative_LSB, relative_RSB)
	
	if relative_LSB < 0 and relative_RSB > 0:
		l = relative_LSB
		relative_LSB = relative_RSB
		relative_RSB = l
	
	add_left = round(missing * relative_LSB)
	add_right = round(missing * relative_RSB)
	
	new_width = add_left + add_right + dst.width
	
	if new_width > src.width:
		print("overshoots", new_width, src.width)
		add_right = round(add_right - (new_width - src.width))
	elif new_width < src.width:
		print("undershoots", new_width, src.width)
		add_right = add_right + 1
	
	# Negative RSB
	if add_left > 0 and add_right < 0:
		if add_left > abs(add_right):
			add_left = add_left + add_right
			add_right = 0

	print("add left", add_left, "add right", add_right)

	dst.LSB = dst.LSB + add_left
	dst.RSB = dst.RSB + add_right

	# Uncomment to disable metric keys for automatically aligned compound
	# glyphs that will sync to unmatching widths

	#if src.parent.leftMetricsKey:
	#	src.parent.leftMetricsKey = None
		
	#if src.parent.rightMetricsKey:
	#	src.parent.rightMetricsKey = None

	print()

	
for g in glyphs:
	g.beginUndo()
	syncLayerWidth(g.layers[0], g.layers[2])
	syncLayerWidth(g.layers[1], g.layers[3])
	g.endUndo()
