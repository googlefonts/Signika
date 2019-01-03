# Subesetting small caps

Since the initial publication of Signika, small caps have been added. On Google Fonts, fonts are specifically subset with only small caps, in order to keep this uncommonly-used feature available without adding weight to core font files.

But how, exactly, are Google Fonts subset?

- Playfair Display SC
  - uppercase present
  - small caps substituted for lowercase
  - :( lowercase subsituted for smallcaps, including `.smcp` suffixes. This is almost certainly incorrect, so I've submitted [an issue for it](https://github.com/clauseggers/Playfair-Display/issues/18). I may circle back and fix this, if I have time after my main PRs.

- Spectral SC, Vollkorn SC, and Alegreya SC
  - replaces lowercase glyphs with smallcaps
  - otherwise, appears to leave all punctuation intact

There is a mismatch in approach to the non-SC versions, however:
- Spectral and Alegreya both have "SC" versions, with main font versions that include smallcap characters. This makes sense if we wish to support open type small cap features with these fonts, and we are just adding "SC" versions to make this feature available in Google Docs / MS Word etc.
- Vollkorn also has "SC" versions, but the main font _excludes_ smallcaps. This would make sense if we wish to make SC versions available in word processors, _plus_ make the main versions a bit smaller (if at the expense of some level of usability).

I see pros and cons for each approach. Smallcaps make up about 20–25% of the glyphs in Signika, Encode, Spectral, and Alegreya, so removing them would certainly make the files smaller. However, it would reduce the typographic flexibility of the core fonts, and perhaps render the original designers's work on these characters (even more) hidden to most users. 

Critically, for both Encode and Signika, core versions exist with smallcaps included, so they should not be removed now, or they might break websites that make use of them. So, I will make "SC" versions that allow smallcaps in word processors, and I will leave the core fonts intact.

## Making a subsetting script for Glyphs

~~
Making a script which:
- goes through font and finds all glyphs holding `.smcp` suffix. These are smallcaps.
- deletes glyphs with the "root name" of the `smcp` glyphs
- updates the `smcp` glyphs to remove that suffix
- doesn't ruin alignment of component glyphs (diacritics), doesn't remove kerning, and doesn't break opentype features

First big challenge: properly deleting root glyphs. I initially had the `smcp` finder and glyph-deletion code in the same loop, but this was messing up the indexing of glyphs and getting thrown off. It's working better to make a list first, then go through this list, and delete glyphs with that name.
~~

## Better method: use a combination of Twardoch's `pyftfeatfreeze`, some glyph list data transformation, and fontTools subsetting

The build scripts now use the following process:

1. running `pyftfeatfreeze.py -f 'smcp' -S -U SC ${VFpath} ${smallCapFontPath}` to turn the `smcp` feature on by default
2. running `python sources/scripts/helpers/get-smallcap-subset-glyphnames.py $ttxPath` to get a space-separated list of glyphs in the TTXed font, with all lowercase "siblings" removed
3. running `pyftsubset ${smallCapFontPath} ${subsetGlyphNames}` to use the edited glyph list to subset the font. This results in a font with smallcap forms in place of lowercase unicodes.
