# Signika Grade Test

The stylistic axis "grade" refers to changes of font outlines to make type more or less dense, specifically without causing any change to the width of letters. As Mozilla defines it:

> The term 'grade' refers to the relative weight or density of the typeface design, but differs from traditional 'weight' in that the physical space the text occupies does not change, so changing the text grade doesn't change the overall layout of the text or elements around it.

— [Grade, MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Fonts/Variable_Fonts_Guide#Grade)

I wanted to test out the grades of Signika vs Signika Negative, in their static versions currently-hosted on Google Fonts. These are intended as two grades of the same typeface, but do they actually meet the no-text-reflow criterion of "grades," or are they simply different font weights?

As this test shows, they cause reflow:

![Signika vs Signika Negative](assets/signika-grade-test.gif)

This shows that the two versions are, in fact, different weights rather than different grades. Or, at least, they might be called "grades" by some people, but they change letters on both stroke thickness and in character width.

This is consistent with the Glyphs source. It has two masters:

![Signika Masters](masters.png)

...and the postive/negative instances are derived from that (here, the Signika Negative Light is an extrapolated -15 weight):

![Signika Instances](instances.png)

## Potential Action

I'll add the shifted instances as new masters for grade, then write a script to duplicate letter widths from the normal to these Negative masters. I'll try keeping the ratio of spacing the same between left and right sides, to prevent spacing from being worsened by the update.

This will allow a grade axis (GRAD) in the future.
