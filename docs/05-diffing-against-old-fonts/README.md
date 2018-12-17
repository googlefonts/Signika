# Diffing against old (currently hosted) files

Currently, vertical metrics are the most-noticeable difference between newly-built files of Signika and the old versions currently hosted on Google Fonts. (If I'm reading this correctly), the new versions have metrics that are significantly taller than before:

![](assets/vert_metrics-diff.gif)

Using font-line, I can easily compare the vertical metrics of the new and hosted versions. 

![](assets/2018-12-17-15-49-03.png)

The UPM of Signika is now 2000 rather than the original 1000, so all values on the left are doubled from what they would otherwise be. Google Sheets makes it easy to compare this:

![](assets/2018-12-17-17-13-38.png)

However, aside from this, they should probably match the hosted vertical metrics (almost) exactly to prevent websites from breaking. Luckily, font-line gives a simple comparison of the overall line height: the `Ratios` which are `1.2` in the new fonts, and `1.23` in the old fonts.

My hunch is that the ratio difference of `0.03` is linked to the Ascent to Descent difference of `0.032`. 

But, how should I go about matching the old versions? First, I'll match [Marc Foley's recommendation for vertical metrics](https://github.com/googlefonts/fontbakery/issues/2164#issuecomment-436595886). Then, I will adjust these as needed to match the line heights of the old fonts, when viewed on the web and ideally also in word processors. The recommended vertical metrics are:

- TypoAscender and hheaAscender are set to height of tallest Cap glyph with single accent (Â, Å)
- Linegaps set to 0
- TypoDescender and hheaDescender set to lowest a-z letter (p, j, q)
- Win Ascent and Win Decent set to yMax and yMin
- fsSelection bit 7 enabled
- Vertical metrics on average were around 130% of upm. I felt this number was the sweet spot. Anything greater and the metrics just looked too loose.