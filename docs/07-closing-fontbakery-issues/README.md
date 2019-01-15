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

- [x] ~~test this (and maybe ask Micah about it)~~ Solved! This can just be an argument in the TTFautohint command


<details>
<summary>:fire: <b>FAIL:</b> Copyright notices match canonical pattern?</summary>

* [com.google.fonts/check/102](https://github.com/googlefonts/fontbakery/search?q=com.google.fonts/check/102)
* :fire: **FAIL** METADATA.pb: Copyright notices should match a pattern similar to: 'Copyright 2017 The Familyname Project Authors (git url)'
But instead we have got: 'Copyright (c) 2018 by Anna Giedrys (info@ancymonic.com), with Reserved Font Names 'Signika'.'
* :fire: **FAIL** Name table entry: Copyright notices should match a pattern similar to: 'Copyright 2017 The Familyname Project Authors (git url)'
But instead we have got: 'Copyright (c) 2018 by Anna Giedrys. All rights reserved. Reserved Font Name: Signika.'
</details>

- [x] fix as much as possible, without removing RFN

<details>
<summary>:fire: <b>FAIL:</b> Check font has same encoded glyphs as version hosted on fonts.google.com</summary>

* [com.google.fonts/check/154](https://github.com/googlefonts/fontbakery/search?q=com.google.fonts/check/154)
* :fire: **FAIL** Font is missing the following glyphs from the previous release [0x009E, 0x008E]

</details>

- [x] ~~find these glyphs and list next step~~ Add these two glyphs. Not sure if really necessary.


<details>
<summary>:warning: <b>WARN:</b> Font contains .notdef as first glyph?</summary>

* [com.google.fonts/check/046](https://github.com/googlefonts/fontbakery/search?q=com.google.fonts/check/046)
* :warning: **WARN** Font should contain the .notdef glyph as the first glyph, it should not have a Unicode value assigned and should contain a drawing.

</details>

- ~~this should be inserted by fontmake, right? check this~~
- [x] this has been added to the main font, and it will go into the others when I split the font again


<details>
<summary>:warning: <b>WARN:</b> Check for points out of bounds.</summary>

* [com.google.fonts/check/075](https://github.com/googlefonts/fontbakery/search?q=com.google.fonts/check/075)
* :warning: **WARN** The following glyphs have coordinates which are out of bounds:
[('periodcentered', 159.64, 573.0), ('periodcentered', 159.64, 591.0), ('periodcentered', 159.64, 555.0), ('napostrophe', 89.0864, 1490.2904), ('napostrophe', 162.5312, 1490.2904), ('napostrophe', 194.54559999999998, 1490.2904), ('napostrophe.smcp', 68.0864, 1488.2904), ('napostrophe.smcp', 141.5312, 1488.2904), ('napostrophe.smcp', 173.54559999999998, 1488.2904), ('approxequal', 300.3472, 1007.056), ('approxequal', 395.4368, 1007.056), ('approxequal', 472.0624, 1007.056), ('approxequal', 875.5008, 189.88), ('approxequal', 780.4112, 189.88), ('approxequal', 702.8624, 189.88), ('uni2219', 445.0, 449.74), ('uni2219', 406.0, 449.74), ('uni2219', 366.0, 449.74), ('bullet', 189.696, 536.0272), ('bullet', 189.696, 565.2808), ('bullet', 523.216, 280.87080000000003), ('bullet', 464.092, 280.87080000000003), ('bullet', 403.452, 280.87080000000003), ('bullet', 189.696, 506.7736)]
This happens a lot when points are not extremes, which is usually bad. However, fixing this alert by adding points on extremes may do more harm than good, especially with italics, calligraphic-script, handwriting, rounded and other fonts. So it is common to ignore this message

</details>

- [x] Many of the outlines in Signika have short paths that are curved subtly, so it would damage their curvature to add extreme points

<details>
<summary>:fire: <b>FAIL:</b> Font has old ttfautohint applied?</summary>

* [com.google.fonts/check/056](https://github.com/googlefonts/fontbakery/search?q={checkid})
* :fire: **FAIL** Failed to parse ttfautohint version values: installed = '1.8.2'; used_in_font = '1.8.1.43-b0c9' [code: parse-error]

</details>

- [x] Nope, this is the new version for VFs

<details>
<summary>:fire: <b>FAIL:</b> Checks METADATA.pb font.post_script_name matches postscript name declared on the name table.</summary>

* [com.google.fonts/check/093](https://github.com/googlefonts/fontbakery/search?q={checkid})
* :fire: **FAIL** Unmatched postscript name in font: TTF has "Signika" while METADATA.pb has "Signika-Light". [code: mismatch]

</details>
<details>
<summary>:fire: <b>FAIL:</b> METADATA.pb font.full_name value matches fullname declared on the name table?</summary>

* [com.google.fonts/check/094](https://github.com/googlefonts/fontbakery/search?q={checkid})
* :fire: **FAIL** Unmatched fullname in font: TTF has "Signika" while METADATA.pb has "Signika Light". [code: mismatch]

</details>
<details>
<summary>:fire: <b>FAIL:</b> METADATA.pb font.filename and font.post_script_name fields have equivalent values?</summary>

* [com.google.fonts/check/097](https://github.com/googlefonts/fontbakery/search?q={checkid})
* :fire: **FAIL** METADATA.pb font filename="Signika-VF.ttf" does not match post_script_name="Signika-Light".

</details>
<details>
<summary>:fire: <b>FAIL:</b> METADATA.pb: Filename is set canonically?</summary>

* [com.google.fonts/check/105](https://github.com/googlefonts/fontbakery/search?q={checkid})
* :fire: **FAIL** METADATA.pb: filename field ("Signika-VF.ttf") does not match canonical name "Signika-Light.ttf".

</details>
<details>
<summary>:fire: <b>FAIL:</b> METADATA.pb font.name and font.full_name fields match the values declared on the name table?</summary>

* [com.google.fonts/check/108](https://github.com/googlefonts/fontbakery/search?q={checkid})
* :fire: **FAIL** METADATA.pb: Fullname ("Signika Light") does not match name table entry "Signika" ! [code: fullname-mismatch]

</details>
<details>
<summary>:fire: <b>FAIL:</b> Checking OS/2 usWeightClass matches weight specified at METADATA.pb.</summary>

* [com.google.fonts/check/112](https://github.com/googlefonts/fontbakery/search?q={checkid})
* :fire: **FAIL** OS/2 usWeightClass (400:"Regular") does not match weight specified at METADATA.pb (300:"Light").

</details>

---

# Smallcaps issues

<details>
<summary>:fire: <b>FAIL:</b> Font has correct post table version (2 for TTF, 3 for OTF)?</summary>

* [com.google.fonts/check/015](https://github.com/googlefonts/fontbakery/search?q={checkid})
* :fire: **FAIL** Post table should be version 2 instead of 3.0. More info at https://github.com/google/fonts/issues/215

</details>
<details>

- [x] I'm not yet quite sure how to fix this ... it's described here: https://github.com/google/fonts/issues/215

I am getting this `WARN` on a subset SC font which has been subset by fontTools, and as you Dave says in the opening comment,

> They should be flipped to v3 when served to web browsers where file size savings do matter, and the fontTools subsetter does use v3.

<details>
<summary>:warning: <b>WARN:</b> Check if OS/2 xAvgCharWidth is correct.</summary>

* [com.google.fonts/check/034](https://github.com/googlefonts/fontbakery/search?q={checkid})
* :warning: **WARN** OS/2 xAvgCharWidth is 1024 but it should be 1043 which corresponds to the weighted average of the widths of the latin lowercase glyphs in the font

</details>

Subsetting out the lowercase makes the font narrower, on average, and this value is calculated from the average of all glyphs in the font, per [the MS OpenType spec](https://docs.microsoft.com/en-us/typography/opentype/spec/os2#xavgcharwidth). This made me realize that FontBakery isn't quite defining this correctly, so I filed an issue at https://github.com/googlefonts/fontbakery/issues/2285.