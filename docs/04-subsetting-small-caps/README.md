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

## Making a subsetting script for Glyphs

Making a script which:
- goes through font and finds all glyphs holding `.smcp` suffix. These are smallcaps.
- deletes glyphs with the "root name" of the `smcp` glyphs
- updates the `smcp` glyphs to remove that suffix
- doesn't ruin alignment of component glyphs (diacritics), doesn't remove kerning, and doesn't break opentype features

First big challenge: properly deleting root glyphs. I initially had the `smcp` finder and glyph-deletion code in the same loop, but this was messing up the indexing of glyphs and getting thrown off. It's working better to make a list first, then go through this list, and delete glyphs with that name.
