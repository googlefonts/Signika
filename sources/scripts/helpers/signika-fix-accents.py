#MenuTitle: Signika - Fix Accents
# -*- coding: utf-8 -*-
"""
    Find all `comb` accents in font.
    Make them equal to the non-comb verions.
    Erase the non-comb versions, 
    and give them components of the `comb` versions.
"""

font = Glyphs.font

# for glyph in font.glyphs:
#     if "comb" in glyph.name:
#         for layer in glyph.layers:
#             if len(layer.anchors) <= 1:
#                 print("/" + glyph.name + " ")
#                 # print(layer.anchors)

for glyph in font.glyphs:
    for layer in glyph.layers:
        for anchor in layer.anchors:
            if anchor.name == "_top_U":
                print(glyph.name, anchor.name, " fixed")
                anchor.name = "_top"
            if anchor.name == "top_U":
                anchor.name = "top"
                print(glyph.name, anchor.name, " fixed")

