# Closing (or explaining) FontBakery issues

<details>
<summary>:broken_heart: <b>ERROR:</b> Check METADATA.pb parse correctly. </summary>

* [com.google.fonts/check/metadata/parses](https://github.com/googlefonts/fontbakery/search?q=com.google.fonts/check/metadata/parses)
* :broken_heart: **ERROR** Failed with IndexError: list index out of range

</details>

Metadata is failing to parse due to current non-support of utf8 in the protobuff project. 

https://github.com/googlefonts/fontbakery/issues/2200

https://github.com/protocolbuffers/protobuf/issues/4721

<details>
<summary>:fire: <b>FAIL:</b> TTFAutohint x-height increase value is same as in previous release on Google Fonts?</summary>

* [com.google.fonts/check/119](https://github.com/googlefonts/fontbakery/search?q=com.google.fonts/check/119)
* :fire: **FAIL** TTFAutohint --increase-x-height is 14. It should match the previous version's value (9).

</details>

- [ ] test this (and maybe ask Micah about it)


<details>
<summary>:fire: <b>FAIL:</b> Copyright notices match canonical pattern?</summary>

* [com.google.fonts/check/102](https://github.com/googlefonts/fontbakery/search?q=com.google.fonts/check/102)
* :fire: **FAIL** METADATA.pb: Copyright notices should match a pattern similar to: 'Copyright 2017 The Familyname Project Authors (git url)'
But instead we have got: 'Copyright (c) 2011 by Anna Giedrys (info@ancymonic.com), with Reserved Font Names 'Signika'.'
* :fire: **FAIL** Name table entry: Copyright notices should match a pattern similar to: 'Copyright 2017 The Familyname Project Authors (git url)'
But instead we have got: 'Copyright (c) 2011 by Anna Giedrys. All rights reserved. Reserved Font Name: Signika.'
</details>

- [ ] fix as much as possible, without removing RFN

<details>
<summary>:fire: <b>FAIL:</b> Check font has same encoded glyphs as version hosted on fonts.google.com</summary>

* [com.google.fonts/check/154](https://github.com/googlefonts/fontbakery/search?q=com.google.fonts/check/154)
* :fire: **FAIL** Font is missing the following glyphs from the previous release [0x009E, 0x008E]

</details>

- [ ] find these glyphs and list next step


<details>
<summary>:warning: <b>WARN:</b> Font contains .notdef as first glyph?</summary>

* [com.google.fonts/check/046](https://github.com/googlefonts/fontbakery/search?q=com.google.fonts/check/046)
* :warning: **WARN** Font should contain the .notdef glyph as the first glyph, it should not have a Unicode value assigned and should contain a drawing.

</details>

- [ ] ~~this should be inserted by fontmake, right? check this~~
- [x] this has been added to the main font, and it will go into the others when I split the font again


<details>
<summary>:warning: <b>WARN:</b> Check for points out of bounds.</summary>

* [com.google.fonts/check/075](https://github.com/googlefonts/fontbakery/search?q=com.google.fonts/check/075)
* :warning: **WARN** The following glyphs have coordinates which are out of bounds:
[('periodcentered', 159.64, 573.0), ('periodcentered', 159.64, 591.0), ('periodcentered', 159.64, 555.0), ('napostrophe', 89.0864, 1490.2904), ('napostrophe', 162.5312, 1490.2904), ('napostrophe', 194.54559999999998, 1490.2904), ('napostrophe.smcp', 68.0864, 1488.2904), ('napostrophe.smcp', 141.5312, 1488.2904), ('napostrophe.smcp', 173.54559999999998, 1488.2904), ('approxequal', 300.3472, 1007.056), ('approxequal', 395.4368, 1007.056), ('approxequal', 472.0624, 1007.056), ('approxequal', 875.5008, 189.88), ('approxequal', 780.4112, 189.88), ('approxequal', 702.8624, 189.88), ('uni2219', 445.0, 449.74), ('uni2219', 406.0, 449.74), ('uni2219', 366.0, 449.74), ('bullet', 189.696, 536.0272), ('bullet', 189.696, 565.2808), ('bullet', 523.216, 280.87080000000003), ('bullet', 464.092, 280.87080000000003), ('bullet', 403.452, 280.87080000000003), ('bullet', 189.696, 506.7736)]
This happens a lot when points are not extremes, which is usually bad. However, fixing this alert by adding points on extremes may do more harm than good, especially with italics, calligraphic-script, handwriting, rounded and other fonts. So it is common to ignore this message

</details>

- [x] Many of the outlines in Signika have short paths that are curved subtly, so it would damage their curvature to add extreme points