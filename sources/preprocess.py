import fontmake.instantiator
import fontTools.designspaceLib
from glyphsLib.cli import main
import os, shutil
from pathlib import Path
import ufoLib2



sources = [
    Path("sources/Signika.glyphs"),
]

try:
    os.mkdir("sources/UFO")
except:
    pass
try:
    os.mkdir("sources/instance_UFO")
except:
    pass

sourceURL = Path("sources/UFO")
instanceURL = Path("sources/instance_UFO")

for s in sources:

    main(("glyphs2ufo", str(s), "--write-public-skip-export-glyphs", "--output-dir", str(sourceURL)))

    designspace = fontTools.designspaceLib.DesignSpaceDocument.fromfile(
            sourceURL / "Signika.designspace"
        )

    designspace.loadSourceFonts(ufoLib2.Font.open)

    generator = fontmake.instantiator.Instantiator.from_designspace(designspace)
    for instance_descriptor in designspace.instances:
        instance = generator.generate_instance(instance_descriptor)

        name = instance_descriptor.familyName+"-"+instance_descriptor.styleName
        instance.save(instanceURL / str(name.replace(" ","")+".ufo"), overwrite = True)

shutil.rmtree(sourceURL,ignore_errors = True)