"""
Helper script to insert a bunch of designspace rules for swapping certing glyphs
at certain weights
We're simply appending the contents without any XML parsing
"""
with open("sources/scripts/helpers/patches/designspace-rules.xml", "r") as rules, open("master_ufo/Signika.designspace", "r+") as designspace:
    rules_content = rules.read()
    ds = designspace.read()
    ds = ds.replace("</axes>", "</axes>\n" + rules_content)
    designspace.seek(0)
    designspace.write(ds)
