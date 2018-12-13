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