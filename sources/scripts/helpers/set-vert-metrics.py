# glyphsapp script, specific to signica
typoLineGap = 0
typoDescender = -584
typoAscender = 1880

for master in font.masters:

  master.customParameters["typoLineGap"] = typoLineGap
  master.customParameters["hheaLineGap"] = typoLineGap

  master.customParameters["typoDescender"] = typoDescender
  master.customParameters["hheaDescender"] = typoDescender

  master.customParameters["typoAscender"] = typoAscender
  master.customParameters["hheaAscender"] = typoAscender